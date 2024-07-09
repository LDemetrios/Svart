// #let escape = rgb("#cc7700")
// #let comment = gray
// #let string = rgb("#007700")
// #let string-inlay = rgb("#cc7700")
// #let keyword = rgb("#770000")
// #let typed = rgb("#77aaff")
// #let literal = rgb("#cc0000")

#let escape = rgb("#ff7700")
#let comment = gray
#let string = rgb("#33ff33")
#let string-inlay = rgb("#cc7700")
#let keyword = rgb("#ff0077")
#let typed = rgb("#77aaff")
#let literal = rgb("#ff7744")

#let rainbow = (
  rgb("#3F9101"),
  rgb("#0E4A8E"),
  rgb("#B4960A"),
  rgb("#BC0BA2"),
  rgb("#61AA0D"),
  rgb("#3D017A"),
  rgb("#D6A60A"),
  rgb("#7710A3"),
  rgb("#A502CE"),
  rgb("#eb5a00"),
)
#let shine(what, key) = strong(text(fill: rainbow.at(calc.rem(key, rainbow.len())), what))

#let colorize-svr(code) = {
  show regex("impl|enum|where|static|override|match|abstract|break|cast|class|override|continue|do\s|else|false|\sfor|fun\s|if|\sin\s|!in|interface|is\s|!is|null|object|package|return|super|this|throw|true|\stry|type|val\s|var\s|when|while|operator"): it => text(
    fill: keyword,
    strong(it),
  )

  show regex("\s[0-9.]+[uUlL]*"): set text(fill: literal)
  show regex("<[a-zA-Z, :]*>"): set text(fill: typed)
  code
}

#let show-rule(body) = {
  let code = body.text
  let stack = ()
  let part = ""
  let mode = "code" // another option is string or comment
  let i = 0
  let color-key = 0
  while i < code.len() {
    let char = code.at(i)
    let prev-char = code.at(i - 1, default: "")
    let next-char = code.at(i + 1, default: "")
    if mode == "code" {
      if char == "(" {
        color-key += 1
        stack.push(colorize-svr(part))
        stack.push(shine("(", color-key))
        part = ""
      } else if char == ")" {
        stack.push(colorize-svr(part))
        stack.push(shine(")", color-key))
        color-key -= 1
        part = ""
      } else if char == "[" {
        color-key += 2
        stack.push(colorize-svr(part))
        stack.push(shine("[", color-key))
        part = ""
      } else if char == "]" {
        stack.push(colorize-svr(part))
        stack.push(shine("]", color-key))
        color-key -= 2
        part = ""
      } else if char == "{" {
        color-key += 3
        stack.push(colorize-svr(part))
        stack.push(shine("{", color-key))
        part = ""
      } else if char == "}" {
        stack.push(colorize-svr(part))
        stack.push(shine("}", color-key))
        color-key -= 3
        part = ""
      } else if char == "\"" {
        stack.push(colorize-svr(part))
        mode = "string"
        part = char
      } else if char == "/" {
        if next-char == "/" {
          stack.push(colorize-svr(part))
          mode = "line-comment"
          part = "//"
          i += 1
        } else if next-char == "*" {
          stack.push(colorize-svr(part))
          mode = "multiline-comment"
          part = "/*"
          i += 1
        } else {
          part += char
        }
      } else {
        part += char
      }
    } else if mode == "string" {
      if char == "\\" {
        stack.push(text(fill: string, part))
        stack.push(text(fill: escape, char + next-char))
        part = ""
        i += 1
      } else if char == "$" {
        stack.push(text(fill: string, part))
        part = "$"
        while (code.at(i + 1).match(regex("[a-zA-Z0-9]")) != none) {
          part += code.at(i + 1)
          i += 1
        }
        stack.push(text(fill: string-inlay, part))
        part = ""
      } else if char == "\"" {
        stack.push(text(fill: string, part + char))
        part = ""
        mode = "code"
      } else {
        part += char
      }
    } else if mode == "line-comment" {
      if char == "\r" or char == "\n" {
        stack.push(text(fill: comment, part + char))
        part = ""
        mode = "code"
      } else {
        part += char
      }
    } else if mode == "multiline-comment" {
      if char == "*" and next-char == "/" {
        stack.push(text(fill: comment, part + char + next-char))
        part = ""
        mode = "code"
        i += 1
      } else {
        part += char
      }
    } else {
      assert(false, message: mode)
    }
    i += 1
  }
  stack.push(colorize-svr(part))
  for el in stack {
    el
  }
}
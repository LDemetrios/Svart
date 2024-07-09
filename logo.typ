#import "@preview/cetz:0.2.2"

#let logo(back:rgb("#08053f")) = cetz.canvas({
  import cetz.draw: *
  content(
    (0, 0),
    block(
      radius: 50%,
      width: 10cm,
      height: 10cm,
      clip: true,

      image("gold.png", width: 10cm, height: 10cm),
    ),
  )

  let sh = .7
  let letter = {
    bezier((2.1, -0.3 + sh), (.25, 3.7), (13 / 20, 2))
    line((-.7, 3.3), (.25, 3.7))
    bezier((-.7, 3.3), (-.25, -.9 - sh - .2), (-6 / 20, 1 / 4))
    bezier((-.25, -.9 - sh - .2), (-1.7, 0.7 - sh), (-0.8, -0.8))
    line((-1.7, 0.7 - sh), (-2.1, 0.3 - sh))
    bezier((-2.1, 0.3 - sh), (-.25, -3.7), (-13 / 20, -2))
    line((-.25, -3.7), (.7, -3.3))
    bezier((.7, -3.3), (.25, .9 + sh + .2), (6 / 20, -1 / 4))
    bezier((.25, .9 + sh + .2), (1.7, -0.7 + sh), (0.8, 0.8))
    line((1.7, -0.7 + sh), (2.1, -0.3 + sh))
  }

  merge-path(
    letter + circle((0, 0), radius: 5, stroke: rgb("#2c2b1e") + .15cm),
    fill: back,
    stroke: none,
  )

  circle((0, 0), radius: 5, stroke: rgb("#2c2b1e") + .15cm)
  merge-path(
    letter,
    stroke: (paint: rgb("#2c2b1e"), thickness: .1cm, cap: "round"),
  )
})

#set page(height: auto, width: auto)

#logo()

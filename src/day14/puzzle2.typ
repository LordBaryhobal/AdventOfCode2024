#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas, draw
#import "puzzle1.typ": parse-input, simulate

#let input = get-input(14)
#let bots = parse-input(input)
#let res = 8270
#let (width, height) = (101, 103)
#let sim-x = simulate.with(max: width, steps: res)
#let sim-y = simulate.with(max: height, steps: res)
#let size = 0.1

#figure(
  canvas({
    draw.rect(
      (0, 0),
      (width * size, -height * size)
    )
    for bot in bots {
      let x = sim-x(bot.pos.x, bot.vel.x)
      let y = sim-y(bot.pos.y, bot.vel.y)
      draw.rect(
        (x * size, -y * size),
        ((x + 1) * size, -(y + 1) * size),
        stroke: none,
        fill: black
      )
    }
  }),
  caption: "Christmas tree easter egg"
)

#show-result(res)
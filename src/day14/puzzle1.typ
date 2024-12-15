#import "/src/utils.typ": *

#let regexp = regex("^p=(.*?),(.*?) v=(.*?),(.*?)$")

#let simulate(v0, dv, max: 1, steps: 1) = {
  return calc.rem-euclid(v0 + dv * steps, max)
}

#let solve(w: 0, h: 0, steps: 100, input) = {
  assert(w != 0, message: "Width must be != 0")
  assert(h != 0, message: "Height must be != 0")

  let bots = input.split("\n").map(b => {
    let m = b.match(regexp)
    return (
      pos: (
        x: int(m.captures.at(0)),
        y: int(m.captures.at(1)),
      ),
      vel: (
        x: int(m.captures.at(2)),
        y: int(m.captures.at(3))
      )
    )
  })

  let quadrants = (
    tl: 0,
    tr: 0,
    bl: 0,
    br: 0
  )
  let half-w = calc.div-euclid(w, 2)
  let half-h = calc.div-euclid(h, 2)

  let sim-x = simulate.with(max: w, steps: steps)
  let sim-y = simulate.with(max: h, steps: steps)
  for bot in bots {
    let x2 = sim-x(bot.pos.x, bot.vel.x)
    let y2 = sim-y(bot.pos.y, bot.vel.y)

    if x2 == half-w or y2 == half-h {
      continue
    }
    let quadrant = (
      (if y2 < half-h {"t"} else {"b"}) +
      (if x2 < half-w {"l"} else {"r"})
    )
    quadrants.at(quadrant) += 1
  }

  return quadrants.values().product()
}

#show-puzzle(
  14, 1,
  solve.with(w: 101, h: 103),
  example: (
    (result: 12, args: (w: 11, h: 7)),
  )
)
#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas
#import "@preview/cetz-plot:0.1.0": plot

#let process(rock) = {
  if rock == 0 {
    return (1,)
  }
  let rock-str = str(rock)
  if calc.rem(rock-str.len(), 2) == 0 {
    let hl = calc.div-euclid(rock-str.len(), 2)
    return (
      int(rock-str.slice(0, hl)),
      int(rock-str.slice(hl))
    )
  }
  return (rock * 2024,)
}

#let blink(rocks) = {
  let new-rocks = ()

  for rock in rocks {
    new-rocks += process(rock)
  }

  return new-rocks
}

#let solve(input) = {
  let rocks = input.split(" ").map(int)
  for _ in range(25) {
    rocks = blink(rocks)
  }
  return rocks.len()
}

#let visualize(input) = {
  let rocks = input.split(" ").map(int)
  let values = (rocks.len(),)
  for _ in range(25) {
    rocks = blink(rocks)
    values.push(rocks.len())
  }
  canvas({
    plot.plot(
      {
        plot.add(range(26).zip(values))
      },
      size: (6,6),
      x-tick-step: 5,
      y-tick-step: 10000,
      x-label: "Blinks",
      y-label: "Rocks"
    )
  })
}

#show-puzzle(
  11, 1,
  solve,
  example: 55312,
  visualize: visualize
)
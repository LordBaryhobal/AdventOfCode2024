#import "/src/utils.typ": *

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

#show-puzzle(
  11, 1,
  solve,
  example: 55312
)
#import "/src/utils.typ": *

#let process(rock, depth) = {
  if depth == 0 {
    return 1
  }
  if rock == 0 {
    return process(1, depth - 1)
  }
  let rock-str = str(rock)
  if calc.rem(rock-str.len(), 2) == 0 {
    let hl = calc.div-euclid(rock-str.len(), 2)
    let a = int(rock-str.slice(0, hl))
    let b = int(rock-str.slice(hl))
    return process(a, depth - 1) + process(b, depth - 1)
  }
  return process(rock * 2024, depth - 1)
}

#let solve(input) = {
  let rocks = input.split(" ").map(int)
  let total = 0
  for rock in rocks {
    total += process(rock, 75)
  }
  return total
}

#show-puzzle(
  11, 2,
  solve,
  only-example: true
)

// Too long to recompile everytime
#show-result(228651922369703)
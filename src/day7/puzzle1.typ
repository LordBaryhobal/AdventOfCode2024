#import "/src/utils.typ": *

#let solveable(values, target) = {
  if values.len() == 1 {
    return values.last() == target
  }

  let values = values
  let v = values.pop()
  if calc.rem(target, v) == 0 {
    if solveable(values, target / v) {
      return true
    }
  }
  if v > target {
    return false
  }

  return solveable(values, target - v)
}

#let solve(input) = {
  let equations = input.split("\n")

  let total = 0
  for equation in equations {
    let (target, values) = equation.split(": ")
    target = int(target)
    values = values.split(" ").map(int)

    if solveable(values, target) {
      total += target
    }
  }
  return total
}

#show-puzzle(
  7, 1,
  solve,
  example: 3749
)
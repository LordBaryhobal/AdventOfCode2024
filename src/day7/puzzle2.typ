#import "/src/utils.typ": *

#let concat(a, b) = {
  return int(str(a) + str(b))
}

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
  let str-target = str(target)
  let str-v = str(v)
  if str-target == str-v {
    return false
  }
  if str-target.ends-with(str-v) {
    let target2 = str-target.slice(
      0,
      str-target.len() - str-v.len()
    )
    if solveable(values, int(target2)) {
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
  7, 2,
  solve,
  example: 11387
)
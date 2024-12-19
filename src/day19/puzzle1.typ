#import "/src/utils.typ": *

#let is-possible(target, towels: none) = {
  if towels == none {
    panic()
  }

  for towel in towels {
    if towel == target {
      return true
    }
    if target.starts-with(towel) {
      if is-possible(target.slice(towel.len()), towels: towels) {
        return true
      }
    }
  }

  return false
}

#let solve(input) = {
  let (towels, targets) = input.split("\n\n")

  towels = towels.split(", ")
  let is-possible = is-possible.with(towels: towels)

  let total = 0
  for target in targets.split("\n") {
    if is-possible(target) {
      total += 1
    }
  }
  return total
}

#show-puzzle(
  19, 1,
  solve,
  example: 6
)
#import "/src/utils.typ": *

#let solve(input) = {
  let (towels, targets) = input.split("\n\n")

  towels = towels.split(", ")
  let by-initial = (:)
  for towel in towels {
    let initial = towel.first()
    if initial not in by-initial {
      by-initial.insert(initial, ())
    }
    by-initial.at(initial).push(towel)
  }

  let count(target) = {
    let initial = target.first()
    if initial not in by-initial {
      return 0
    }
    let cnt = 0
    for towel in by-initial.at(initial) {
      if towel == target {
        cnt += 1
      } else if target.starts-with(towel) {
        cnt += count(target.slice(towel.len()))
      }
    }

    return cnt
  }

  let total = 0
  for target in targets.split("\n") {
    total += count(target)
  }
  return total
}

#show-puzzle(
  19, 2,
  solve,
  example: 16,
  only-example: true
)
#show-result(632423618484345)
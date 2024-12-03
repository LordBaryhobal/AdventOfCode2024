#import "/src/utils.typ": *

#let solve(input) = {
  let matches = input.matches(regex("mul\((\d{1,3}),(\d{1,3})\)"))
  let total = matches.map(m => {
    m.captures.map(int)
              .product()
  }).sum()
  return total
}

#show-puzzle(
  3, 1,
  solve,
  example: 161
)
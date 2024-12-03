#import "/src/utils.typ": *

#let solve(input) = {
  let dos = input.matches(regex("do\(\)"))
  let donts = input.matches(regex("don't\(\)"))
  let toggles = dos.map(m => (m.end, true))
  toggles += donts.map(m => (m.end, false))
  toggles = toggles.sorted(key: t => t.first())

  let is-enabled(i) = {
    let t = toggles.rev().find(t => t.first() <= i)
    return t == none or t.last()
  }

  let matches = input.matches(regex("mul\((\d{1,3}),(\d{1,3})\)"))
  let total = matches.map(m => {
    if is-enabled(m.start) {
      m.captures.map(int)
                .product()
    } else {
      0
    }
  }).sum()
  return total
}

#show-puzzle(
  3, 2,
  solve,
  example: ("2": 48)
)
#import "/src/utils.typ": *

#let solve(input) = {
  let lines = input.split("\n")
  let (l1, l2) = ((), ())
  let reg = regex("^(\d+)\s+(\d+)$")
  for line in lines {
    let digits = line.match(reg)
    l1.push(int(digits.captures.first()))
    l2.push(int(digits.captures.last()))
  }

  let total = l1.sorted().zip(l2.sorted()).map(((a, b)) => calc.abs(a - b)).sum()
  return total
}

#show-puzzle(
  1,
  solve,
  example: 11
)
#import "/src/utils.typ": *

#let solve(input) = {
  let lines = input.split("\n")
  let (l1, l2) = ((), ())
  let reg = regex("^(\d+)\s+(\d+)$")
  for line in lines {
    let digits = line.match(reg)
    l1.push(digits.captures.first())
    l2.push(digits.captures.last())
  }

  let nums = (:)

  for n in l1 {
    if n not in nums.keys() {
      nums.insert(n, (0, 0))
    }
    nums.at(n).first() += 1
  }

  for n in l2 {
    if n in nums.keys() {
      nums.at(n).last() += 1
    }
  }

  let total = nums.pairs().map(((num, (a, b))) => int(num) * a * b).sum()
  return total
}

#show-puzzle(
  1,
  solve,
  example: 31
)
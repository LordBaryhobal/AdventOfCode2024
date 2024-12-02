#import "/src/utils.typ": *

#let solve(input) = {
  let safe-cnt = 0
  for line in input.split("\n") {
    let nums = line.split(" ").map(n => int(n))

    let increasing
    let safe = true
    for i in range(nums.len() - 1) {
      let d = nums.at(i + 1) - nums.at(i)
      let abs-d = calc.abs(d)
      if abs-d < 1 or abs-d > 3 {
        safe = false
        break
      }
      if i == 0 {
        increasing = d > 0
      } else if (d > 0) != increasing {
        safe = false
        break
      }
    }
    if safe {
      safe-cnt += 1
    }
  }
  return safe-cnt
}

#show-puzzle(
  2, 1,
  solve,
  example: 2
)
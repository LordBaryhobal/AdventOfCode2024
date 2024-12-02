#import "/src/utils.typ": *

#let is-safe(levels) = {
  let increasing
  let safe = true
  for i in range(levels.len() - 1) {
    let d = levels.at(i + 1) - levels.at(i)
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
  return safe
}

#let solve-bruteforce(input) = {
  let safe-cnt = 0
  for line in input.split("\n") {
    let nums = line.split(" ").map(n => int(n))
    if is-safe(nums) {
      safe-cnt += 1
    } else {
      for i in range(nums.len()) {
        if is-safe(nums.slice(0, i) + nums.slice(i+1)) {
          safe-cnt += 1
          break
        }
      }
    }
  }
  return safe-cnt
}

#let visualize(input) = {
  let safe-cnt = 0
  for line in input.split("\n") {
    let nums = line.split(" ").map(n => int(n))

    let remove-i = none
    if not is-safe(nums) {
      for i in range(nums.len()) {
        if is-safe(nums.slice(0, i) + nums.slice(i+1)) {
          remove-i = i
          break
        }
      }
    }

    let cells = ()
    cells += nums.enumerate().map(((i, n)) => grid.cell(
      colspan: 3,
      fill: if i == remove-i {gray.transparentize(40%)},
      str(n)
    ))
    cells += (none,none,)
    cells += range(nums.len() - 1).map(i => nums.at(i + 1) - nums.at(i))
                                  .map(n => {
                                    let col = if calc.abs(n) in (1,2,3) {green} else {red}
                                    grid.cell(
                                      colspan: 2,
                                      fill: gradient.linear(
                                        angle: if n >= 0 {0deg} else {180deg},
                                        (white, 0%),
                                        (white, 50%),
                                        (col, 50%),
                                        (col, 100%)
                                      ),
                                      str(n)
                                    )
                                  })
                                  .intersperse(none)

    grid(
      columns: (1fr,) * 3 * nums.len(),
      inset: (x: 0.2em, y: 0.4em),
      stroke: (x, y) => {
        if y == 0 or (calc.rem(x, 3) == 2 and x != nums.len() * 3 - 1) {
          black + .5pt
        }
      },
      ..cells
    )
  }
}

#show-puzzle(
  2, 2,
  solve-bruteforce,
  example: 4,
  visualize: visualize
)
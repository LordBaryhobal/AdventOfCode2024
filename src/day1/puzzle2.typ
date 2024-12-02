#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas, draw

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

#let visualize(input) = {
  let lines = input.split("\n")
  let (l1, l2) = ((), ())
  let reg = regex("^(\d+)\s+(\d+)$")
  for line in lines {
    let digits = line.match(reg)
    l1.push(digits.captures.first())
    l2.push(digits.captures.last())
  }

  let unique = l1.dedup()
  let colors = (red,green)
  canvas({
    for (i, n) in l1.enumerate() {
      let y = -0.9 * i
      draw.circle(
        (0, y),
        radius: 0.35,
        stroke: black,
        name: "l" + str(i)
      )
      draw.content((0, y), n)
    }
    for (i, n) in l2.enumerate() {
      let y = -0.9 * i
      draw.circle(
        (4, y),
        radius: 0.35,
        stroke: black,
        name: "r" + str(i)
      )
      draw.content((4, y), n)
    }
    for (i, a) in l1.enumerate() {
      for (j, b) in l2.enumerate() {
        if a == b {
          draw.line(
            "l" + str(i),
            "r" + str(j),
            stroke: colors.at(unique.position(n => n == a)) + 1.5pt,
            mark: (end: "straight")
          )
        }
      }
    }
  })
}

#show-puzzle(
  1, 2,
  solve,
  example: 31,
  visualize: visualize
)
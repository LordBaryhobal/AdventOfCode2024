#import "/src/utils.typ": *

#let check-xmas(lines, ox, oy) = {
  let w = lines.first().len()
  let h = lines.len()

  let total = 0
  for dy in (-1, 0, 1) {
    for dx in (-1, 0, 1) {
      if dx == 0 and dy == 0 {
        continue
      }
      let buffer = ""
      let x = ox
      let y = oy
      for i in range(4) {
        buffer += lines.at(y).at(x)
        x += dx
        y += dy
        if (
          not "XMAS".starts-with(buffer) or
          x < 0 or x >= w or
          y < 0 or y >= h
        ) {
          break
        }
      }
      if buffer == "XMAS" {
        total += 1
      }
    }
  }
  return total
}

#let solve(input) = {
  let lines = input.split("\n")
  let w = lines.first().len()
  let h = lines.len()

  let total = 0
  for y in range(h) {
    for x in range(h) {
      if lines.at(y).at(x) == "X" {
        total += check-xmas(lines, x, y)
      }
    }
  }

  return total
}

#show-puzzle(
  4, 1,
  solve,
  example: 18
)
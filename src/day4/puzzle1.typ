#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas, draw

#let check-xmas(lines, ox, oy) = {
  let w = lines.first().len()
  let h = lines.len()

  let dirs = ()
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
        dirs.push((dx, dy))
      }
    }
  }
  return dirs
}

#let solve(input) = {
  let lines = input.split("\n")
  let w = lines.first().len()
  let h = lines.len()

  let total = 0
  for y in range(h) {
    for x in range(w) {
      if lines.at(y).at(x) == "X" {
        total += check-xmas(lines, x, y).len()
      }
    }
  }

  return total
}

#let visualize(input) = {
  let lines = input.split("\n")
  let w = lines.first().len()
  let h = lines.len()

  canvas({
    for y in range(h) {
      for x in range(w) {
        if lines.at(y).at(x) == "X" {
          let key = str(x) + "-" + str(y)
          let dirs = check-xmas(lines, x, y)
          draw.on-layer(2, {
            for (dx, dy) in dirs {
              draw.line(
                (x + dx * 0.2, y + dy * 0.2),
                (x + dx * 2.8, y + dy * 2.8),
                stroke: red,
                fill: red,
                mark: (end: ">")
              )
            }
          })
        }
        draw.content(
          (x, y),
          lines.at(y).at(x)
        )
      }
    }
  })
}

#show-puzzle(
  4, 1,
  solve,
  example: 18,
  visualize: visualize
)
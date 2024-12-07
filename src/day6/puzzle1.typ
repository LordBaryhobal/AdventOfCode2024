#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas, draw

#let offsets = (
  (0, -1),
  (1, 0),
  (0, 1),
  (-1, 0)
)

#let in-grid(x, y, w, h) = {
  return 0 <= x and x < w and 0 <= y and y < h
}

#let solve(input) = {
  let grid = input.split("\n").map(l => l.clusters())

  let w = grid.first().len()
  let h = grid.len()

  let ox = 0
  let oy = 0
  let found-start = false
  for y in range(h) {
    for x in range(w) {
      if grid.at(y).at(x) == "^" {
        ox = x
        oy = y
        found-start = true
        break
      }
    }
    if found-start {
      break
    }
  }

  grid.at(oy).at(ox) = "v"

  let x = ox
  let y = oy
  let dir = 0
  let count = 1
  let (dx, dy) = offsets.at(dir)
  while in-grid(x, y, w, h) {
    if grid.at(y).at(x) != "v" {
      grid.at(y).at(x) = "v"
      count += 1
    }

    let x2 = x + dx
    let y2 = y + dy
    if not in-grid(x2, y2, w, h) {
      break
    }

    for _ in range(4) {
      let next = grid.at(y2).at(x2)

      if next == "#" {
        dir = calc.rem(dir + 1, 4)
        (dx, dy) = offsets.at(dir)
        x2 = x + dx
        y2 = y + dy
      } else {
        break
      }
    }

    x = x2
    y = y2
  }
  return count
}

#let visualize(input) = {
  let grid = input.split("\n").map(l => l.clusters())

  let w = grid.first().len()
  let h = grid.len()

  canvas(length: 2em, {
    let (ox, oy) = (0, 0)
    for y in range(h) {
      for x in range(w) {
        let c = grid.at(y).at(x)
        draw.circle(
          (x, -y),
          radius: if c == "#" {0.4} else {0.2},
          fill: if c == "#" {
            red
          } else if c == "^" {
            green
          } else {
            gray.lighten(40%)
          }
        )
        if c == "^" {
          (ox, oy) = (x, y)
        }
      }
    }

    let x = ox
    let y = oy
    let dir = 0
    let path = ()
    let (dx, dy) = offsets.at(dir)
    while in-grid(x, y, w, h) {
      path.push((x, y))

      let x2 = x + dx
      let y2 = y + dy
      if not in-grid(x2, y2, w, h) {
        break
      }

      for _ in range(4) {
        let next = grid.at(y2).at(x2)

        if next == "#" {
          dir = calc.rem(dir + 1, 4)
          (dx, dy) = offsets.at(dir)
          x2 = x + dx
          y2 = y + dy
        } else {
          break
        }
      }

      let col = if path.len() == 1 {green} else {blue}
      draw.line(
        (x, -y),
        (x2, -y2),
        mark: (end: ">"),
        fill: col,
        stroke: col
      )

      x = x2
      y = y2
    }
    //draw.line(..path, stroke: blue)
  })
}

#show-puzzle(
  6, 1,
  solve,
  example: 41,
  visualize: visualize
)
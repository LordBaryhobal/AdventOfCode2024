#import "/src/utils.typ": *

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
    for x in range(h) {
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

#show-puzzle(
  6, 1,
  solve,
  example: 41
)
#import "/src/utils.typ": *

#let offsets = (
  (1, 0),
  (0, 1),
  (-1, 0),
  (0, -1)
)

#let EMPTY = "."
#let WALL = "#"
#let START = "S"
#let END = "E"

#let in-grid(w, h, x, y) = {
  return 0 <= x and x < w and 0 <= y and y < h
}

#let count-shortcuts(grid, w, h, save, path) = {
  let in-grid = in-grid.with(w, h)
  let total = 0
  for (x1, y1) in path {
    let v1 = grid.at(y1).at(x1)

    for (dx1, dy1) in offsets {
      let (x2, y2) = (x1 + dx1, y1 + dy1)
      if not in-grid(x2, y2) {
        continue
      }
      let v2 = grid.at(y2).at(x2)
      if v2 < 0 {
        for (dx2, dy2) in offsets {
          let (x3, y3) = (x2 + dx2, y2 + dy2)
          if not in-grid(x3, y3) {
            continue
          }
          let v3 = grid.at(y3).at(x3)
          if v3 > 0 {
            if v3 - v1 >= save + 2 {
              total += 1
            }
          }
        }
      }
    }
  }
  return total
}

#let solve(input, save: 1) = {
  let input-grid = input.split("\n").map(l => l.clusters())

  let w = input-grid.first().len()
  let h = input-grid.len()
  let in-grid = in-grid.with(w, h)

  let grid = ((-1,)*w,)*h
  let start = none
  let end = none
  for y in range(h) {
    for x in range(w) {
      let c = input-grid.at(y).at(x)
      if c == WALL {
        continue
      }
      if c == START {
        start = (x, y)
      } else if c == END {
        end = (x, y)
      }
      grid.at(y).at(x) = 0
    }
  }

  let (x, y) = start
  let (ex, ey) = end
  let path = ()

  while x != ex or y != ey {
    path.push((x, y))
    grid.at(y).at(x) = path.len()
    for (dx, dy) in offsets {
      let (x2, y2) = (x + dx, y + dy)
      if not in-grid(x2, y2) {
        continue
      }
      let v = grid.at(y2).at(x2)
      if v == 0 {
        (x, y) = (x2, y2)
        break
      }
    }
  }
  path.push((x, y))
  grid.at(y).at(x) = path.len()

  return count-shortcuts(
    grid, w, h,
    save,
    path
  )
}

#let examples = (
  (64, 1),
  (40, 1),
  (38, 1),
  (36, 1),
  (20, 1),
  (12, 3),
  (10, 2),
  (8, 4),
  (6, 2),
  (4, 14),
  (2, 14),
)
#let n-tot = 0
#let examples2 = ()
#for (save, cnt) in examples {
  n-tot += cnt
  examples2.push((result: n-tot, args: (save: save)))
}

#show-puzzle(
  20, 1,
  solve.with(save: 100),
  example: examples2
)
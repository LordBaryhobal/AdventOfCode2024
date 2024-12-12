#import "/src/utils.typ": *

#let offsets = (
  (-1, 0),
  (0, -1),
  (1, 0),
  (0, 1)
)

#let in-grid(w, h, x, y) = {
  return 0 <= x and x < w and 0 <= y and y < h
}

#let solve(input) = {
  let grid = input.split("\n").map(l => l.clusters())
  let w = grid.first().len()
  let h = grid.len()
  let in-grid = in-grid.with(w, h)

  let visited = ((false,) * w,) * h
  let total = 0

  for y in range(h) {
    for x in range(w) {
      if visited.at(y).at(x) {
        continue
      }
      let char = grid.at(y).at(x)
      let cells = ()
      let borders = 0
      let next-cells = ((x, y),)
      while next-cells.len() != 0 {
        let (cx, cy) = next-cells.remove(0)
        cells.push((cx, cy))
        visited.at(cy).at(cx) = true
        for (dx, dy) in offsets {
          let (x2, y2) = (cx + dx, cy + dy)
          if (x2, y2) in cells or (x2, y2) in next-cells {
            continue
          }
          if in-grid(x2, y2) {
            let char2 = grid.at(y2).at(x2)
            if char2 == char {
              next-cells.push((x2, y2))
            } else {
              borders += 1
            }
          } else {
            borders += 1
          }
        }
      }
      total += borders * cells.len()
    }
  }

  return total
}

#show-puzzle(
  12, 1,
  solve,
  example: (
    "1": 140,
    "2": 772,
    "3": 1930
  )
)
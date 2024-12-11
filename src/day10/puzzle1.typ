#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas, draw, matrix

#let offsets = (
  (-1, 0),
  (0, -1),
  (1, 0),
  (0, 1)
)

#let in-grid(w, h, x, y) = {
  return 0 <= x and x < w and 0 <= y and y < h
}

#let count-paths(grid, w, h, ox, oy) = {
  let tails = ()
  let in-grid = in-grid.with(w, h)

  let to-visit = ((ox, oy),)
  while to-visit.len() != 0 {
    let (x, y) = to-visit.remove(0)
    let v = grid.at(y).at(x)
    for (dx, dy) in offsets {
      let (x2, y2) = (x + dx, y + dy)
      if not in-grid(x2, y2) {
        continue
      }
      let v2 = grid.at(y2).at(x2)
      if v2 == v + 1 {
        let pos2 = (x2, y2)
        if v2 == 9 {
          if pos2 not in tails {
            tails.push(pos2)
          }
        } else {
          to-visit.push(pos2)
        }
      }
    }
  }

  return tails.len()
}

#let get-paths(grid, w, h, ox, oy) = {
  let paths = ()
  let tails = ()
  let in-grid = in-grid.with(w, h)

  let to-visit = ((ox, oy),)
  while to-visit.len() != 0 {
    let (x, y) = to-visit.remove(0)
    let v = grid.at(y).at(x)
    for (dx, dy) in offsets {
      let (x2, y2) = (x + dx, y + dy)
      if not in-grid(x2, y2) {
        continue
      }
      let v2 = grid.at(y2).at(x2)
      if v2 == v + 1 {
        let pos2 = (x2, y2)
        if v2 == 9 {
          if pos2 not in tails {
            tails.push(pos2)
            paths.push(((ox, oy), (x2, y2)))
          }
        } else {
          to-visit.push(pos2)
        }
      }
    }
  }

  return paths
}

#let solve(input) = {
  let grid = input.split("\n").map(l => l.clusters().map(int))

  let w = grid.first().len()
  let h = grid.len()

  let count-paths = count-paths.with(grid, w, h)

  let total = 0
  for y in range(h) {
    for x in range(w) {
      if grid.at(y).at(x) == 0 {
        total += count-paths(x, y)
      }
    }
  }

  return total
}

#let visualize(input) = {
  let grid = input.split("\n").map(l => l.clusters().map(int))

  let w = grid.first().len()
  let h = grid.len()

  let count-paths = count-paths.with(grid, w, h)
  let get-paths = get-paths.with(grid, w, h)

  let total = 0
  canvas({
    let starts = ()
    let c
    for y in range(h) {
      for x in range(w) {
        c = grid.at(y).at(x)
        draw.rect(
          (x, -y),
          (x + 1, -y - 1),
          fill: black.lighten((9 - c) / 9 * 90% + 10%)
        )
        if c == 0 {
          starts.push((x, y))
        }
      }
    }
    for (ox, oy) in starts {
      let paths = get-paths(ox, oy)
      for path in paths {
        draw.line(
          ..path.map(
            ((x, y)) => (x + .5, -y - .5)
          ),
          stroke: red,
          mark: (end: ">")
        )
      }
    }
  })
}

#show-puzzle(
  10, 1,
  solve,
  example: 36,
  visualize: visualize
)
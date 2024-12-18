#import "/src/utils.typ": *
#let offsets = (
  (1, 0),
  (0, 1),
  (-1, 0),
  (0, -1)
)

#let get-lowest(nodes, scores) = {
  let lowest-score = none
  let lowest-i = none
  for (i, (x, y)) in nodes.enumerate() {
    let score = scores.at(y).at(x)

    if lowest-i == none or score < lowest-score {
      lowest-score = score
      lowest-i = i
    }
  }

  if lowest-i == none {
    panic()
  }
  return lowest-i
}

#let make-path(parents, end) = {
  let path = (end,)
  let (x, y) = end
  let pos = parents.at(y).at(x)
  while pos != none {
    (x, y) = pos
    path.insert(0, pos)
    pos = parents.at(y).at(x)
  }
  return path
}

#let find-path(w, h, grid, start: (0, 0), end: auto) = {
  let end = if end == auto {(w - 1, h - 1)} else {end}
  let (x, y) = start
  let open = ((x, y),)
  let closed = ()
  let g-scores = ((0,) * w,) * h
  let f-scores = ((calc.inf,) * w,) * h
  let parents = ((none,)*w,)*h
  while open.len() != 0 {
    let cur = open.remove(get-lowest(open, f-scores))
    
    if cur == end {
      return true
    }

    let g-score = g-scores.at(y).at(x)
    let f-score = f-scores.at(y).at(x)
    
    let (x, y) = cur
    for (dx, dy) in offsets {
      let (x2, y2) = (x + dx, y + dy)
      if x2 < 0 or x2 >= w or y2 < 0 or y2 >= h {
        continue
      }
      if grid.at(y2).at(x2) {
        continue
      }
      if (x2, y2) in closed {
        continue
      }
      let g = calc.abs(x2 - start.first()) + calc.abs(y2 - start.last())
      let h = calc.abs(end.first() - x2) + calc.abs(end.last() - y2)
      let f = g + h

      if f < f-scores.at(y2).at(x2) {
        g-scores.at(y2).at(x2) = g
        f-scores.at(y2).at(x2) = f
        parents.at(y2).at(x2) = (x, y)
        open.push((x2, y2))
      }
    }
    closed.push(cur)
  }
  return false
}

#let solve(input, w: 0, h: 0, n-bytes: 0) = {
  assert(w != 0, message: "Width cannot be 0")
  assert(h != 0, message: "Height cannot be 0")
  let grid = ((false,) * w,) * h

  let obstacles = input.split("\n")
  let a = 0
  let b = obstacles.len()

  while b - a > 1 {
    let m = calc.div-euclid(a + b, 2)
    let grid2 = grid
    for obs in obstacles.slice(0, m) {
      let (x, y) = obs.split(",").map(int)
      grid2.at(y).at(x) = true
    }

    if find-path(w, h, grid2) {
      a = m
    } else {
      b = m
    }
  }
  return obstacles.at(a)
}

#show-puzzle(
  18, 2,
  solve.with(w: 71, h: 71),
  example: (
    (result: "6,1", args: (w: 7, h: 7)),
  )
)
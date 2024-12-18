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

#let find-path(w, h, grid) = {
  let end = (w - 1, h - 1)
  let (x, y) = (0, 0)
  let open = ((x, y),)
  let closed = ()
  let g-scores = ((0,) * w,) * h
  let f-scores = ((calc.inf,) * w,) * h
  let parents = ((none,)*w,)*h
  while open.len() != 0 {
    let cur = open.remove(get-lowest(open, f-scores))
    
    if cur == end {
      return make-path(parents, cur)
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
      let g = x2 + y2
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
  panic("No path was found")
}

#let solve(input, w: 0, h: 0, n-bytes: 0) = {
  assert(w != 0, message: "Width cannot be 0")
  assert(h != 0, message: "Height cannot be 0")
  let grid = ((false,) * w,) * h

  let obstacles = input.split("\n")
  for obs in obstacles.slice(0, n-bytes) {
    let (x, y) = obs.split(",").map(int)
    grid.at(y).at(x) = true
  }

  let path = find-path(w, h, grid)
  return path.len() - 1
}

#let visualize(input, w: 0, h: 0, n-bytes: 0, s: 2em) = {
  let grid_ = ((false,) * w,) * h

  let obstacles = input.split("\n")
  for obs in obstacles.slice(0, n-bytes) {
    let (x, y) = obs.split(",").map(int)
    grid_.at(y).at(x) = true
  }

  let path = find-path(w, h, grid_)
  for (x, y) in path {
    grid_.at(y).at(x) = grid.cell(fill: green.lighten(60%))[O]
  }
  
  let cells = grid_.flatten().map(c => {
    if c == false []
    else if c == true {grid.cell(fill: red.lighten(60%))[\#]}
    else {c}
  })
  
  grid(
    columns: (s,) * w,
    rows: (s,) * h,
    align: center + horizon,
    stroke: black,
    ..cells
  )
}

#show-puzzle(
  18, 1,
  solve.with(w: 71, h: 71, n-bytes: 1024),
  example: (
    (result: 22, args: (w: 7, h: 7, n-bytes: 12)),
  ),
  visualize: visualize.with(w: 7, h: 7, n-bytes: 12)
)

/*
#pagebreak()
#set page(width: auto, height: auto)
#visualize(get-input(18), w: 71, h: 71, n-bytes: 1024, s: 1em)
*/
#import "/src/utils.typ": *

#let empty = 0
#let up = 1
#let right = 2
#let down = 4
#let left = 8
#let obstacle = 16
#let possible-obstacle = 32

#let offsets = (
  str(up): (0, -1),
  str(right): (1, 0),
  str(down): (0, 1),
  str(left): (-1, 0)
)

#let values = (
  ".": empty,
  "#": obstacle,
  "^": up,
  "O": possible-obstacle
)

#let in-grid(x, y, w, h) = {
  return 0 <= x and x < w and 0 <= y and y < h
}

#let rotate(dir) = {
  return if dir == left {up} else {dir.bit-lshift(1)}
}

#let puzzle1(grid, ox, oy, dir) = {
  let w = grid.first().len()
  let h = grid.len()
  let path = ((ox, oy, dir),)
  let (x, y) = (ox, oy)
  
  let (dx, dy) = (0, 0)
  let (x2, y2) = (x, y)
  while true {
    (dx, dy) = offsets.at(str(dir))
    (x2, y2) = (x + dx, y + dy)
    grid.at(y).at(x) = grid.at(y).at(x).bit-or(dir)
    path.push((x2, y2, dir))
    
    if not in-grid(x2, y2, w, h) {
      break
    }

    // Not relevant
    /*
    if grid.at(y2).at(x2).bit-and(dir) != 0 {
      loops = true
      break
    }
    */

    if grid.at(y2).at(x2) == obstacle {
      dir = rotate(dir)
    } else {
      (x, y) = (x2, y2)
    }
  }
  return path
}

#let add-obstacle(rows, cols, x, y) = {
  let add-in-line(line, v) = {
    if line.len() == 0 {
      line.push(v)
      return line
    }
    for (i, v2) in line.enumerate() {
      if v < v2 {
        line.insert(i, v)
        return line
      }
    }
    line.push(v)
    return line
  }

  rows.at(y) = add-in-line(rows.at(y), x)
  cols.at(x) = add-in-line(cols.at(x), y)
  return (rows, cols)
}

#let walk-loops(rows, cols, ox, oy, dir) = {
  let (x, y) = (ox, oy)
  let w = cols.len()
  let h = rows.len()
  let visited = ()

  while true {
    let pos = (x, y, dir)
    if pos in visited {
      return true
    }
    visited.push(pos)

    let line = if dir in (up, down) {cols.at(x)} else {rows.at(y)}
    let v = if dir in (up, down) {y} else {x}

    // No obstacle
    if line.len() == 0 {
      return false
    }

    // Leave grid
    if dir in (up, left) {
      if v < line.first() {
        return false
      }
    } else if v > line.last() {
      return false
    }

    let i = line.len() - 1
    for (j, v2) in line.enumerate() {
      if v < v2 {
        i = j
        if dir in (left, up) {
          i -= 1
        }
        break
      }
    }
    let v2 = line.at(i)
    if dir == up {
      y = v2 + 1
    } else if dir == right {
      x = v2 - 1
    } else if dir == down {
      y = v2 - 1
    } else {
      x = v2 + 1
    }
    dir = rotate(dir)
  }

  return false
}

#let solve(input) = {
  let grid = input.split("\n").map(l => l.clusters())

  let w = grid.first().len()
  let h = grid.len()

  let ox = 0
  let oy = 0
  for (y, line) in grid.enumerate() {
    for (x, cell) in line.enumerate() {
      let value = values.at(cell)
      if value == up {
        (ox, oy) = (x, y)
      }
      grid.at(y).at(x) = value
    }
  }

  let cols = ()
  let rows = ()

  for y in range(h) {
    let row = ()
    for x in range(w) {
      if grid.at(y).at(x) == obstacle {
        row.push(x)
      }
    }
    rows.push(row)
  }

  for x in range(w) {
    let col = ()
    for y in range(h) {
      if grid.at(y).at(x) == obstacle {
        col.push(y)
      }
    }
    cols.push(col)
  }

  let path = puzzle1(grid, ox, oy, up)
  let count = 0

  for (x, y, _) in path.slice(1, path.len() - 1) {
    if x == ox and y == oy {
      continue
    }
    let cell = grid.at(y).at(x)
    if cell.bit-and(possible-obstacle) == 0 {
      let (rows2, cols2) = add-obstacle(rows, cols, x, y)

      if walk-loops(rows2, cols2, ox, oy, up) {
        count += 1
        grid.at(y).at(x) = cell.bit-or(possible-obstacle)
      }
    }
  }
  return count
}

#show-puzzle(
  6, 2,
  solve,
  example: 6
)
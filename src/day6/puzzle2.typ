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

#let puzzle1(grid, w, h) = {
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
  let path = ()

  let x = ox
  let y = oy
  let dir = 0
  let count = 1
  let (dx, dy) = offsets.at(dir)
  while in-grid(x, y, w, h) {
    if grid.at(y).at(x) != "v" {
      path.push((x, y, dir))
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

  return path
}

/*
#let get-next-obstacle(grid, w, h, ox, oy, dir) = {
  let (dx, dy) = offsets.at(dir)
  let (x, y) = (ox, oy)
  while in-grid(x, y, w, h) {
    if grid.at(y).at(x) == "#" {
      return (x - dx, y - dy)
    }
    x += dx
    y += dy
  }
  return none
}

#let puzzle1(grid, w, h) = {
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
  let path = ()

  let x = ox
  let y = oy
  let dir = 0
  let count = 1
  let (dx, dy) = offsets.at(dir)
  while in-grid(x, y, w, h) {
    path.push((x, y, dir))
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

  return path
}

#let solve(input) = {
  let grid = input.split("\n").map(l => l.clusters())

  let w = grid.first().len()
  let h = grid.len()
  let obstacles = ()

  for y in range(h) {
    for x in range(w) {
      if grid.at(y).at(x) == "#" {
        obstacles.push((x, y))
      }
    }
  }

  let get-next-obstacle = get-next-obstacle.with(
    grid, w, h
  )

  let path = puzzle1(grid, w, h)

  let count = 0
  for (ox, oy) in obstacles {
    for odir in range(4) {
      let dir = odir
      let (dx, dy) = offsets.at(dir)
      let (x, y) = (ox + dx, oy + dy)
      if not in-grid(x, y, w, h) {
        continue
      }
      let found = true
      let in-path = false
      let (min-x, min-y) = (w, h)
      let (max-x, max-y) = (0, 0)
      let corner-obstacles = ()
      corner-obstacles.push((ox, oy))
      for _ in range(3) {
        let next = get-next-obstacle(x, y, calc.rem(dir + 3, 4))
        dir = calc.rem(dir + 1, 4)
        if next == none {
          found = false
          break
        } else {
          (x, y) = next
          min-x = calc.min(min-x, x)
          min-y = calc.min(min-y, y)
          max-x = calc.max(max-x, x)
          max-y = calc.max(max-y, y)
          if corner-in-path(path, x, y, )
        }
      }
      if found {
        count += 1
      }
    }
  }
  return count
}*/

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
  let path = ()

  let x = ox
  let y = oy
  let dir = 0
  let count = 1
  let (dx, dy) = offsets.at(dir)
  while in-grid(x, y, w, h) {
    path.push((x, y, dir))

    if path.len() >= 3 {
      let anchor = path.at(path.len() - 3)
      if ((dx == 0 and y == anchor.last()) or
          (dy == 0 and x == anchor.first())) {
        

      }
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

  return path
}

#let has-loop(grid, w, h, ox, oy, tx, ty, dir) = {
  let grid = grid
  grid.at(ty).at(tx) = "#"

  let x = ox
  let y = oy
  let visited = ()
  let (dx, dy) = offsets.at(dir)
  while in-grid(x, y, w, h) {
    grid.at(y).at(x) = "v"
    let e = (x, y, dir)
    if e in visited {
      return true
    }
    visited.push(e)

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

  return false
}

#let solve-bruteforce(input) = {
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

  let path = puzzle1(grid, w, h)

  let count = 0
  for (x, y, dir) in path {
    let (dx, dy) = offsets.at(dir)
    let (tx, ty) = (x + dx, y + dy)
    if not in-grid(tx, ty, w, h) {
      continue
    }
    if grid.at(ty).at(tx) != "." {
      continue
    }
    if has-loop(grid, w, h, x, y, tx, ty, dir) {
      grid.at(ty).at(tx) = "O"
      count += 1
    }
  }
  
  return count
}

#let rejoins-path(
  grid, w, h, path,
  ox, oy, tx, ty, dir,
  path-grid, si
) = {
  let grid = grid
  grid.at(ty).at(tx) = "#"
  let (x, y) = (ox, oy)
  let dir = dir
  let (dx, dy) = offsets.at(dir)
  let visited = ()
  
  while in-grid(x, y, w, h) {
    let (x2, y2) = (x + dx, y + dy)

    if not in-grid(x2, y2, w, h) {
      return false
    }

    let visits = path-grid.at(y2).at(x2)
    if visits.at(str(dir), default: calc.inf) < si {
      return true
    }
    let e = (x, y, dir)
    if e in visited {
      return true
    }
    visited.push(e)

    if grid.at(y2).at(x2) == "#" {
      dir = calc.rem(dir + 1, 4)
      (dx, dy) = offsets.at(dir)
    } else {
      (x, y) = (x2, y2)
    }
  }
  return false
}

#let solve(input) = {
  let grid = input.split("\n").map(l => l.clusters())

  let w = grid.first().len()
  let h = grid.len()

  let path-grid = (
    (
      (:),
    ) * w,
  ) * h

  let path = puzzle1(grid, w, h)

  for (i, (x, y, dir)) in path.enumerate() {
    path-grid.at(y).at(x).insert(str(dir), i)
  }
  let count = 0
  let max = (h, w, h, w)
  for (i, (x, y, dir)) in path.enumerate() {
    let (dx, dy) = offsets.at(dir)
    let (tx, ty) = (x + dx, y + dy)
    if not in-grid(tx, ty, w, h) or grid.at(ty).at(tx) != "." {
      continue
    }
    let dir2 = calc.rem(dir + 1, 4)
    if rejoins-path(
      grid, w, h, path,
      x, y, tx, ty, dir2,
      path-grid, i
    ) {
      count += 1
      grid.at(ty).at(tx) = "O"
    }
  }

  //return raw(block: true, grid.map(l => l.join("")).join("\n"))
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
    let path = puzzle1(grid, w, h)
    let count = 0
    for (i, (x, y, dir)) in path.enumerate() {
      if i != 0 {
        let col = if i == 1 {green} else {blue}
        draw.line(
          (path.at(i - 1).first(), -path.at(i - 1).at(1)),
          (x, -y),
          stroke: col,
          fill: col,
          mark: (end: ">")
        )
      }

      let (dx, dy) = offsets.at(dir)
      let (tx, ty) = (x + dx, y + dy)
      if not in-grid(tx, ty, w, h) {
        continue
      }
      if grid.at(ty).at(tx) != "." {
        continue
      }
      if has-loop(grid, w, h, x, y, tx, ty, dir) {
        grid.at(ty).at(tx) = "O"
        draw.circle(
          (tx, -ty),
          radius: 0.4,
          stroke: blue
        )
      }
    }
  })
}

#show-puzzle(
  6, 2,
  solve,//solve-bruteforce,
  example: 6,
  visualize: visualize,
  only-example: true
)

//#solve(get-input(6))
#import "/src/utils.typ": *

#let WALL = "#"
#let BOX = "O"
#let BOX-L = "["
#let BOX-R = "]"
#let BOT = "@"
#let EMPTY = "."

#let offsets = (
  "^": (0, -1),
  "<": (-1, 0),
  "v": (0, 1),
  ">": (1, 0)
)

#let compute-value(grid) = {
  let total = 0
  for (y, row) in grid.enumerate() {
    for (x, type) in row.enumerate() {
      if type == BOX-L {
        total += y * 100 + x
      }
    }
  }
  return total
}

#let can-move(grid, w, h, x, y, dx, dy) = {
  let (x2, y2) = (x + dx, y + dy)
  let type = grid.at(y2).at(x2)
  if type == EMPTY {
    return true
  }
  if type == WALL {
    return false
  }

  // Horizontal move
  if dy == 0 {
    return can-move(grid, w, h, x2, y2, dx, dy)
  }
  
  let lx = if type == BOX-L {x2} else {x2 - 1}

  return (
    can-move(grid, w, h, lx, y2, dx, dy) and
    can-move(grid, w, h, lx + 1, y2, dx, dy)
  )
}

#let do-move(grid, w, h, x, y, dx, dy) = {
  let type = grid.at(y).at(x)
  let (x2, y2) = (x + dx, y + dy)
  let type2 = grid.at(y2).at(x2)
  
  if type2 in (BOX-L, BOX-R) {
    grid = do-move(grid, w, h, x2, y2, dx, dy)
    // Vertical move
    if dx == 0 {
      let x3 = if type2 == BOX-L {x2 + 1} else {x2 - 1}
      grid = do-move(grid, w, h, x3, y2, dx, dy)
    }
    type2 = EMPTY
  }
  if type2 == EMPTY {
    grid.at(y2).at(x2) = type
    grid.at(y).at(x) = EMPTY
    return grid
  }
  if type2 == WALL {
    panic()
  }
  return grid
}

#let solve(input) = {
  let (grid-data, move-data) = input.split("\n\n")
  let grid = grid-data.split("\n").map(r => r.clusters())
  
  let w = grid.first().len()
  let h = grid.len()
  let (w2, h2) = (w * 2, h)
  let bot-pos = none
  let grid2 = ((EMPTY,) * w2,) * h2

  for y in range(h) {
    for x in range(w) {
      let type = grid.at(y).at(x)
      if type == BOT {
        bot-pos = (x*2, y)
        type = EMPTY
        continue
      }
      grid2.at(y).at(x*2) = if type == BOX {BOX-L} else {type}
      grid2.at(y).at(x*2 + 1) = if type == BOX {BOX-R} else {type}
    }
  }
  let (bot-x, bot-y) = bot-pos

  let moves = move-data.replace("\n", "").clusters()
  for (move-i, move) in moves.enumerate() {
    let (dx, dy) = offsets.at(move)
    let (x2, y2) = (bot-x + dx, bot-y + dy)

    if not can-move(grid2, w2, h2, bot-x, bot-y, dx, dy) {
      continue
    }

    grid2 = do-move(grid2, w2, h2, bot-x, bot-y, dx, dy)
    (bot-x, bot-y) = (x2, y2)
  }

  return compute-value(grid2)
}

#show-puzzle(
  15, 2,
  solve,
  example: (
    "2": 9021
  )
)
#import "/src/utils.typ": *

#let WALL = "#"
#let BOX = "O"
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
      if type == BOX {
        total += y * 100 + x
      }
    }
  }
  return total
}

#let solve(input) = {
  let (grid-data, move-data) = input.split("\n\n")
  let grid = grid-data.split("\n").map(r => r.clusters())
  let rows = ()
  let cols = ()
  
  let w = grid.first().len()
  let h = grid.len()
  let bot-pos = none

  for y in range(h) {
    for x in range(w) {
      let type = grid.at(y).at(x)
      if type == BOT {
        bot-pos = (x, y)
        grid.at(y).at(x) = EMPTY
        break
      }
    }
    if bot-pos != none {
      break
    }
  }
  let (bot-x, bot-y) = bot-pos

  let moves = move-data.replace("\n", "").clusters()
  for (move-i, move) in moves.enumerate() {
    let (dx, dy) = offsets.at(move)
    let (x2, y2) = (bot-x + dx, bot-y + dy)
    let type = grid.at(y2).at(x2)
    if type == WALL {
      continue
    }
    if type == EMPTY {
      (bot-x, bot-y) = (x2, y2)
      continue
    }

    let type2 = type
    let (x3, y3) = (x2, y2)
    while type2 == BOX {
      x3 += dx
      y3 += dy
      type2 = grid.at(y3).at(x3)
    }

    if type2 == WALL {
      continue
    }
    grid.at(y3).at(x3) = BOX
    grid.at(y2).at(x2) = EMPTY
    (bot-x, bot-y) = (x2, y2)
  }

  return compute-value(grid)
}

#show-puzzle(
  15, 1,
  solve,
  example: (
    "1": 2028,
    "2": 10092
  )
)
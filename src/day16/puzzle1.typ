#import "/src/utils.typ": *

#let START = "S"
#let END = "E"
#let WALL = "#"
#let EMPTY = "."

#let offsets = (
  (1, 0),
  (0, 1),
  (-1, 0),
  (0, -1)
)

#let solve(input) = {
  let grid = input.split("\n").map(l => l.clusters())
  let w = grid.first().len()
  let h = grid.len()

  let (sx, sy) = (0, 0)
  let (ex, ey) = (0, 0)
  for y in range(h) {
    for x in range(w) {
      let c = grid.at(y).at(x)
      if c == START {
        (sx, sy) = (x, y)
      } else if c == END {
        (ex, ey) = (x, y)
      }
    }
  }

  let choices = ((sx, sy, 0, 0),)
  let (x, y, dir, score) = (0, 0, 0, 0)
  while choices.len() != 0 {
    let min-score = calc.min(..choices.map(c => c.last()))
    let i = choices.position(c => c.last() == min-score)
    (x, y, dir, score) = choices.remove(i)
    for (d, (dx, dy)) in offsets.enumerate() {
      // Ignore backflips
      if calc.abs(d - dir) == 2 {
        continue
      }
      let (x2, y2) = (x + dx, y + dy)
      let c = grid.at(y2).at(x2)
      if c == WALL {
        continue
      }
      let score2 = score + 1 + if d != dir {1000} else {0}
      if c == END {
        return score2
      }
      choices.push((x2, y2, d, score2))
    }
    break
  }
  return 0
}

#show-puzzle(
  16, 1,
  solve,
  example: (
    "1": 7036,
    "2": 11048
  )
)
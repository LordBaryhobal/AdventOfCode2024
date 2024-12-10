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

#let count-paths(grid, w, h, ox, oy) = {
  let in-grid = in-grid.with(w, h)
  let rating = 0

  let to-visit = ((ox, oy),)
  while to-visit.len() != 0 {
    let (x, y) = to-visit.remove(0)
    let v = grid.at(y).at(x)
    let branches = 0
    for (dx, dy) in offsets {
      let (x2, y2) = (x + dx, y + dy)
      if not in-grid(x2, y2) {
        continue
      }
      let v2 = grid.at(y2).at(x2)
      if v2 == v + 1 {
        let pos2 = (x2, y2)
        branches += 1
        if v2 != 9 {
          to-visit.push(pos2)
        }
      }
    }
    rating += if v == 0 {
      branches
    } else {
      branches - 1  // If no branch -> -1
    }
  }

  return rating
}

#let solve(input) = {
  let grid = input.split("\n").map(l => l.clusters().map(int))

  let w = grid.first().len()
  let h = grid.len()

  let count-paths = count-paths.with(grid, w, h)

  let ratings = ()
  let total = 0
  for y in range(h) {
    for x in range(w) {
      if grid.at(y).at(x) == 0 {
        let rating = count-paths(x, y)
        total += rating
        ratings.push(rating)
      }
    }
  }
  let a = ratings

  return total
}

#show-puzzle(
  10, 2,
  solve,
  example: 81
)
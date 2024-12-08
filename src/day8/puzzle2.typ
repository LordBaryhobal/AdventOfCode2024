#import "/src/utils.typ": *

#let in-grid(w, h, x, y) = {
  return 0 <= x and x < w and 0 <= y and y < h
}

#let get-antinodes(in-grid, x1, y1, x2, y2) = {
  let (dx, dy) = (x2 - x1, y2 - y1)
  let f = calc.gcd(dx, dy)
  dx /= f
  dy /= f

  let walk(ox, oy, dx, dy) = {
    let x = ox
    let y = oy
    let pos = ()
    while in-grid(x, y) {
      pos.push((x, y))
      x += dx
      y += dy
    }
    return pos
  }

  let antinodes = walk(x1, y1, dx, dy) + walk(x1, y1, -dx, -dy)

  return antinodes
}

#let solve(input) = {
  let by-freq = (:)
  let antinodes = ()

  let grid = input.split("\n").map(l => l.clusters())
  let w = grid.first().len()
  let h = grid.len()

  let in-grid = in-grid.with(w, h)
  let get-antinodes = get-antinodes.with(in-grid)

  for y in range(h) {
    for x in range(w) {
      let c = grid.at(y).at(x)
      if c == "." {
        continue
      }
      if c not in by-freq {
        by-freq.insert(c, ())
      }

      for (x2, y2) in by-freq.at(c) {
        antinodes += get-antinodes(x, y, x2, y2)
      }
      by-freq.at(c).push((x, y))
    }
  }

  return antinodes.dedup().len()
}

#show-puzzle(
  8, 2,
  solve,
  example: 34
)
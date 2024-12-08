#import "/src/utils.typ": *

#let in-grid(w, h, x, y) = {
  return 0 <= x and x < w and 0 <= y and y < h
}

#let solve(input) = {
  let by-freq = (:)
  let antinodes = ()

  let grid = input.split("\n").map(l => l.clusters())
  let w = grid.first().len()
  let h = grid.len()

  let in-grid = in-grid.with(w, h)

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
        let (dx, dy) = (x2 - x, y2 - y)
        let node1 = (x - dx, y - dy)
        let node2 = (x2 + dx, y2 + dy)

        if in-grid(..node1) and node1 not in antinodes {
          antinodes.push(node1)
        }

        if in-grid(..node2) and node2 not in antinodes {
          antinodes.push(node2)
        }
      }
      by-freq.at(c).push((x, y))
    }
  }

  return antinodes.len()
}

#show-puzzle(
  8, 1,
  solve,
  example: 14
)
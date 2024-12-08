#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas, draw

#let in-grid(w, h, x, y) = {
  return 0 <= x and x < w and 0 <= y and y < h
}

#let solve(input, return-data: false) = {
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

  return if return-data {
    (grid, by-freq, antinodes)
  } else {
    antinodes.len()
  }
}

#let visualize(solve, input) = {
  let (grid, by-freq, antinodes) = solve(input, return-data: true)
  let w = grid.first().len()
  let h = grid.len()

  let freqs = by-freq.keys()
  let n-freqs = freqs.len()
  let colors = gradient.linear(red, orange, yellow, green, aqua, blue, purple)
  
  canvas(length: 1.65em, {
    for y in range(h) {
      for x in range(w) {
        draw.circle(
          (x, y),
          radius: 0.1,
          fill: gray,
          stroke: none
        )

        for (i, freq) in freqs.enumerate() {
          let col = colors.sample(i * 100% / n-freqs)
          for (ax, ay) in by-freq.at(freq) {
            draw.circle(
              (ax, ay),
              radius: 0.4,
              fill: col
            )
          }
        }
      }
    }

    for (anx, any) in antinodes {
      draw.rect(
        (anx - 0.4, any - 0.4),
        (anx + 0.4, any + 0.4),
      )
    }
  })
}

#show-puzzle(
  8, 1,
  solve,
  example: 14,
  visualize: visualize.with(solve)
)
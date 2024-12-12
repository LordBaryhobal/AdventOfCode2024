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

#let solve(input) = {
  let grid = input.split("\n").map(l => l.clusters())
  let w = grid.first().len()
  let h = grid.len()
  let in-grid = in-grid.with(w, h)

  let zone-grid = ((none,) * w,) * h
  let zone-id = 0
  let zone-sides = ()
  let zone-areas = ()

  for y in range(h) {
    for x in range(w) {
      if zone-grid.at(y).at(x) != none {
        continue
      }
      let char = grid.at(y).at(x)
      let area = 0
      let borders = 0
      let next-cells = ((x, y),)

      while next-cells.len() != 0 {
        let (cx, cy) = next-cells.remove(0)
        zone-grid.at(cy).at(cx) = zone-id
        area += 1
        for (dx, dy) in offsets {
          let (x2, y2) = (cx + dx, cy + dy)
          if (x2, y2) in next-cells {
            continue
          }
          if in-grid(x2, y2) {
            if zone-grid.at(y2).at(x2) == zone-id {
              continue
            }
            let char2 = grid.at(y2).at(x2)
            if char2 == char {
              next-cells.push((x2, y2))
            }
          }
        }
      }
      zone-areas.push(area)
      zone-sides.push(0)
      zone-id += 1
    }
  }

  let first-zone0 = -1
  let last-zone0 = -1
  for y in range(h) {
    let first-zone = zone-grid.at(y).at(0)
    let last-zone = zone-grid.at(y).at(w - 1)
    if first-zone0 != first-zone {
      zone-sides.at(first-zone) += 1
    }
    if last-zone0 != last-zone {
      zone-sides.at(last-zone) += 1
    }
    first-zone0 = first-zone
    last-zone0 = last-zone
  }

  first-zone0 = -1
  last-zone0 = -1
  for x in range(w) {
    let first-zone = zone-grid.at(0).at(x)
    let last-zone = zone-grid.at(h - 1).at(x)
    if first-zone0 != first-zone {
      zone-sides.at(first-zone) += 1
    }
    if last-zone0 != last-zone {
      zone-sides.at(last-zone) += 1
    }
    first-zone0 = first-zone
    last-zone0 = last-zone
  }

  for x in range(w - 1) {
    let zone-a0 = -1
    let zone-b0 = -1
    for y in range(h) {
      let zone-a = zone-grid.at(y).at(x)
      let zone-b = zone-grid.at(y).at(x + 1)
      if zone-a != zone-b {
        if zone-a != zone-a0 {
          zone-sides.at(zone-a) += 1
        }
        if zone-b != zone-b0 {
          zone-sides.at(zone-b) += 1
        }
        zone-a0 = zone-a
        zone-b0 = zone-b
      } else {
        zone-a0 = -1
        zone-b0 = -1
      }
    }
  }

  for y in range(h - 1) {
    let zone-a0 = -1
    let zone-b0 = -1
    for x in range(w) {
      let zone-a = zone-grid.at(y).at(x)
      let zone-b = zone-grid.at(y + 1).at(x)
      if zone-a != zone-b {
        if zone-a != zone-a0 {
          zone-sides.at(zone-a) += 1
        }
        if zone-b != zone-b0 {
          zone-sides.at(zone-b) += 1
        }
        zone-a0 = zone-a
        zone-b0 = zone-b
      } else {
        zone-a0 = -1
        zone-b0 = -1
      }
    }
  }

  let total = range(zone-id).map(i => {
    zone-sides.at(i) * zone-areas.at(i)
  })
  return total.sum()
}

#show-puzzle(
  12, 2,
  solve,
  example: (
    "1": 80,
    "2": 436,
    "3": 1206,
    "4": 236,
    "5": 368
  )
)
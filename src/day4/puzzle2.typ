#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas, draw

#let solve(input) = {
  let lines = input.split("\n")
  let w = lines.first().len()
  let h = lines.len()

  let perms = (("M", "S"), ("S", "M"))
  let total = 0
  for y in range(1, h - 1) {
    for x in range(1, w - 1) {
      if lines.at(y).at(x) == "A" {
        let tl = lines.at(y - 1).at(x - 1)
        let tr = lines.at(y - 1).at(x + 1)
        let bl = lines.at(y + 1).at(x - 1)
        let br = lines.at(y + 1).at(x + 1)
        let tlbr = (tl, br)
        let bltr = (bl, tr)
        if tlbr in perms and bltr in perms {
          total += 1
        }
      }
    }
  }

  return total
}

#let visualize(input) = {
  let lines = input.split("\n")
  let w = lines.first().len()
  let h = lines.len()

  let perms = (("M", "S"), ("S", "M"))
  let positions = ()
  for y in range(1, h - 1) {
    for x in range(1, w - 1) {
      if lines.at(y).at(x) == "A" {
        let tl = lines.at(y - 1).at(x - 1)
        let tr = lines.at(y - 1).at(x + 1)
        let bl = lines.at(y + 1).at(x - 1)
        let br = lines.at(y + 1).at(x + 1)
        let tlbr = (tl, br)
        let bltr = (bl, tr)
        if tlbr in perms and bltr in perms {
          positions.push((x, y))
        }
      }
    }
  }

  canvas({
    for y in range(h) {
      for x in range(w) {
        let valid = (x, y) in positions
        if valid {
          draw.circle(
            (x, y),
            radius: 0.3,
            stroke: red,
            name: str(x) + "-" + str(y)
          )
          for dy in (-1, 1) {
            for dx in (-1, 1) {
              draw.line(
                str(x) + "-" + str(y),
                (x + dx * 0.75, y + dy * 0.75),
                stroke: red
              )
            }
          }
        }
        draw.content(
          (x, y),
          lines.at(y).at(x)
        )
      }
    }
  })
}

#show-puzzle(
  4, 2,
  solve,
  example: 9,
  visualize: visualize
)
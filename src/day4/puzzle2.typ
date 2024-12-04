#import "/src/utils.typ": *

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

#show-puzzle(
  4, 2,
  solve,
  example: 9
)
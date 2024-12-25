#import "/src/utils.typ": *

#let parse-schematic(schematic) = {
  let lines = schematic.split("\n")
  let is-key = "." in schematic.first()

  let n-cols = lines.first().len()
  let n-rows = lines.len()
  let heights = ()

  for x in range(n-cols) {
    let y = if is-key {n-rows - 2} else {1}
    let h = 0
    for i in range(n-rows) {
      if lines.at(y).at(x) == "." {
        break
      }
      h += 1
      y += if is-key {-1} else {1}
    }
    heights.push(h)
  }

  return (if is-key {"key"} else {"lock"}, heights)
}

#let fits(lock, key) = {
  let tmp = lock.zip(key).map(p => p.sum())
  return calc.max(..tmp) <= 5
}

#let solve(input) = {
  let schematics = input.split("\n\n")

  let locks = ()
  let keys = ()
  for schematic in schematics {
    let (type, heights) = parse-schematic(schematic)
    if type == "key" {
      keys.push(heights)
    } else {
      locks.push(heights)
    }
  }
  let total = 0
  for key in keys {
    for lock in locks {
      if fits(lock, key) {
        total += 1
      }
    }
  }

  return total
}

#show-puzzle(
  25, 1,
  solve,
  example: 3
)
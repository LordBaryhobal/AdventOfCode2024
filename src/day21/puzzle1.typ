#import "/src/utils.typ": *

#let nums = (
  "7": (0, 0),
  "8": (1, 0),
  "9": (2, 0),
  "4": (0, 1),
  "5": (1, 1),
  "6": (2, 1),
  "1": (0, 2),
  "2": (1, 2),
  "3": (2, 2),
  "0": (1, 3),
  "A": (2, 3),
)

#let arrows = (
  "^": (1, 0),
  "A": (2, 0),
  "<": (0, 1),
  "v": (1, 1),
  ">": (2, 1),
)

#let get-num-path(code) = {
  let path = ""
  let (x, y) = nums.at("A")
  for char in code {
    let (x2, y2) = nums.at(char)
    let dy = y2 - y
    let dx = x2 - x
    let ver = if dy == 0 {
      ""
    } else {
      (if dy < 0 {"^"} else {"v"}) * calc.abs(dy)
    }
    let hor = if dx == 0 {
      ""
    } else {
      (if dx < 0 {"<"} else {">"}) * calc.abs(dx)
    }
    path += if y == 3 and x2 == 0 {
      ver + hor
    } else {
      hor + ver
    } + "A"
    (x, y) = (x2, y2)
  }
  return path
}

#let get-dir-path(code) = {
  let path = ""
  let (x, y) = arrows.at("A")
  for char in code {
    let (x2, y2) = arrows.at(char)
    let dy = y2 - y
    let dx = x2 - x
    let ver = if dy == 0 {
      ""
    } else {
      (if dy < 0 {"^"} else {"v"}) * calc.abs(dy)
    }
    let hor = if dx == 0 {
      ""
    } else {
      (if dx < 0 {"<"} else {">"}) * calc.abs(dx)
    }
    path += if x == 0 and dy < 0 {
      hor + ver
    } else {
      ver + hor
    } + "A"
    (x, y) = (x2, y2)
  }
  return path
}

#let get-path(code) = {
  let num-path = get-num-path(code)
  let dir-path-1 = get-dir-path(num-path)
  let dir-path-2 = get-dir-path(dir-path-1)
  return dir-path-2
}

#let solve(input) = {
  let codes = input.split("\n")
  let total = 0
  for code in codes {
    let len = get-path(code).len()
    let num = int(code.slice(0, code.len() - 1))
    total += len * num
  }
  return total
}
#show-puzzle(
  21, 1,
  solve,
  example: 126384
)

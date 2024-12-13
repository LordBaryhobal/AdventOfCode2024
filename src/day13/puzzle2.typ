#import "/src/utils.typ": *

#let parse-machine(lines) = {
  let lines = lines.split("\n")
  let match-a = lines.at(0).match(regex("Button A: X\\+(\d+), Y\\+(\d+)"))
  let match-b = lines.at(1).match(regex("Button B: X\\+(\d+), Y\\+(\d+)"))
  let match-p = lines.at(2).match(regex("Prize: X=(\d+), Y=(\d+)"))

  return (
    a: (
      x: int(match-a.captures.first()),
      y: int(match-a.captures.last()),
    ),
    b: (
      x: int(match-b.captures.first()),
      y: int(match-b.captures.last()),
    ),
    prize: (
      x: int(match-p.captures.first()) + 10000000000000,
      y: int(match-p.captures.last()) + 10000000000000,
    )
  )
}

#let mat-mul-v(mat, v) = {
  return (
    mat.at(0).at(0) * v.at(0) + mat.at(0).at(1) * v.at(1),
    mat.at(1).at(0) * v.at(0) + mat.at(1).at(1) * v.at(1)
  )
}

#let det(mat) = {
  return mat.at(0).at(0) * mat.at(1).at(1) - mat.at(1).at(0) * mat.at(0).at(1)
}

#let solve(input) = {
  let machines = input.split("\n\n")
  machines = machines.map(parse-machine)

  let total = 0
  for m in machines {
    let mat = (
      (m.a.x, m.b.x),
      (m.a.y, m.b.y)
    )
    let v = (m.prize.x, m.prize.y)
    let mat2 = (
      (mat.at(1).at(1), -mat.at(0).at(1)),
      (-mat.at(1).at(0), mat.at(0).at(0)),
    )

    let (a, b) = mat-mul-v(mat2, v)

    let d = det(mat)

    // Check integer solution
    if calc.rem(a, d) != 0 or calc.rem(b, d) != 0 {
      continue
    }
    a = int(a / d)
    b = int(b / d)

    if a > 0 and b > 0 {
      total += a * 3 + b
    }
  }
  return total
}

#show-puzzle(
  13, 2,
  solve,
  example: 875318608908
)
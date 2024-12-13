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
      x: int(match-p.captures.first()),
      y: int(match-p.captures.last()),
    )
  )
}

#let in-line(v1, v2) = {
  let f1 = v2.x / v1.x
  let f2 = v2.y / v1.y
  return f1 == f2
}

#let solve(input) = {
  let machines = input.split("\n\n")
  machines = machines.map(parse-machine)

  let total = 0
  for m in machines {
    let totals = ()
    let are-inline = in-line(m.a, m.b)
    for b in range(101) {
      let bx = b * m.b.x
      let by = b * m.b.y
      let rx = m.prize.x - bx
      let ry = m.prize.y - by
      if rx < 0 or ry < 0 {
        break
      }
      let rax = calc.rem(
        rx,
        m.a.x
      )
      let ray = calc.rem(
        ry,
        m.a.y
      )
      if rax != 0 or ray != 0 {
        continue
      }

      let a1 = calc.div-euclid(
        rx,
        m.a.x
      )
      let a2 = calc.div-euclid(
        ry,
        m.a.y
      )
      if a1 != a2 or a1 > 100 {
        continue
      }
      totals.push(b + a1 * 3)
      if not are-inline {
        break
      }
    }
    if totals.len() != 0 {
      total += calc.min(..totals)
    }
  }
  return total
}

#show-puzzle(
  13, 1,
  solve,
  example: 480
)
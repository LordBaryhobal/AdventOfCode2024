#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas, draw

#let solvable(values, target) = {
  if values.len() == 1 {
    return values.last() == target
  }

  let values = values
  let v = values.pop()
  if calc.rem(target, v) == 0 {
    if solvable(values, target / v) {
      return true
    }
  }
  if v > target {
    return false
  }

  return solvable(values, target - v)
}

#let solve(input) = {
  let equations = input.split("\n")

  let total = 0
  for equation in equations {
    let (target, values) = equation.split(": ")
    target = int(target)
    values = values.split(" ").map(int)

    if solvable(values, target) {
      total += target
    }
  }
  return total
}

#let visualize(input) = {
  let get-solution(values, target) = {
    if values.len() == 1 {
      return (values.last() == target, (target,))
    }

    let values = values
    let v = values.pop()
    if calc.rem(target, v) == 0 {
      let r = get-solution(values, target / v)
      if r.first() {
        return (true, r.last() + ("*", v))
      }
    }
    if v > target {
      return (false, ())
    }

    let r = get-solution(values, target - v)
    if r.first() {
      return (true, r.last() + ("+", v))
    }
    return (false, ())
  }
  let num(v, x, y, name) = {
    draw.circle(
      (x, y),
      radius: 0.4,
      fill: gray.lighten(60%),
      name: name
    )
    draw.content((x, y), str(v))
  }
  let ope(o, x, y, name) = {
    let s = (
      "+": sym.plus,
      "*": sym.times
    ).at(o)
    draw.circle(
      (x, y),
      radius: 0.3,
      fill: orange.lighten(60%),
      name: name
    )
    draw.content((x, y), s)
  }

  let equations = input.split("\n")
  let diags = ()
  for equation in equations {
    let (target, values) = equation.split(": ")
    target = int(target)
    values = values.split(" ").map(int)

    let r = get-solution(values, target)
    if not r.first() {
      continue
    }
    let diag = canvas({
      let lvl = 0
      let steps = r.last()
      let prev = none
      let v = steps.remove(0)

      while true {
        num(v, lvl, -lvl, str(lvl) + "-0")

        if lvl != 0 {
          draw.line(
            str(lvl - 1) + "-1",
            str(lvl) + "-0"
          )
        }

        if steps.len() == 0 {
          break
        }

        let op = steps.remove(0)
        let v2 = steps.remove(0)

        ope(op, lvl + 1, -lvl, str(lvl) + "-1")
        num(v2, lvl + 2, -lvl, str(lvl) + "-2")
        draw.line(
          str(lvl) + "-0",
          str(lvl) + "-1"
        )
        draw.line(
          str(lvl) + "-2",
          str(lvl) + "-1"
        )
        if op == "+" {
          v += v2
        } else if op == "*" {
          v *= v2
        }

        lvl += 1
      }
    })
    diags.push(diag)
  }

  if calc.rem(diags.len(), 2) == 1 {
    diags.last() = grid.cell(colspan: 2, diags.last())
  }

  grid(
    columns: 2,
    stroke: (paint: black, dash: "dashed"),
    align: center + horizon,
    inset: 0.4em,
    ..diags
  )
}

#show-puzzle(
  7, 1,
  solve,
  example: 3749,
  visualize: visualize
)
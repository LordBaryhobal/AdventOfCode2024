#import "/src/utils.typ": *
#import "@preview/cetz:0.3.1": canvas, draw

#let make-rules-dict(rules) = {
  let dict = (:)

  for rule in rules {
    let (a, b) = rule

    if a not in dict {
      dict.insert(a, ())
    }
    dict.at(a).push(b)
  }

  return dict
}

#let is-update-valid(dict, update) = {
  for i in range(update.len() - 1) {
    let a = str(update.at(i))
    for j in range(i + 1, update.len()) {
      let b = str(update.at(j))
      if a in dict.at(b, default: ()) {
        return false
      }
    }
  }
  return true
}

#let solve(input) = {
  let (rules, updates) = input.split("\n\n")
  rules = rules.split("\n").map(l => l.split("|"))
  updates = updates.split("\n").map(l => l.split(",").map(int))

  let total = 0
  let rules-dict = make-rules-dict(rules)

  for update in updates {
    if is-update-valid(rules-dict, update) {
      total += update.at(calc.div-euclid(update.len(), 2))
    }
  }

  return total
}

#let visualize(input) = {
  let (rules, updates) = input.split("\n\n")
  rules = rules.split("\n").map(l => l.split("|").map(int))
  updates = updates.split("\n").map(l => l.split(",").map(int))

  let total = 0
  //let rules-dict = make-rules-dict(rules)

  let diags = ()
  for update in updates {
    let diag = canvas(length: 3em, {
      for (x, n) in update.enumerate() {
        draw.circle(
          (x, 0),
          radius: 0.4,
          name: str(x)
        )
        draw.content(
          (x, 0),
          str(n)
        )
      }

      let flip = false
      let c = 1
      for (a, b) in rules {
        let i = update.position(n => n == a)
        let j = update.position(n => n == b)
        if i == none or j == none {
          continue
        }
        let anchor = if flip {".south"} else {".north"}
        let pt-i = str(i) + anchor
        let pt-j = str(j) + anchor
        let col = if j < i {red} else {green}

        draw.arc-through(
          pt-i,
          (
            rel: (0, if flip {-c / 10} else {c / 10}),
            to: (pt-i, 50%, pt-j)
          ),
          pt-j,
          mark: (end: ">", fill: col),
          stroke: col
        )

        flip = not flip
        c += 1
      }
    })

    diags.push(diag)

    /*if is-update-valid(rules-dict, update) {
      total += update.at(calc.div-euclid(update.len(), 2))
    }*/
  }

  diags.last() = grid.cell(
    colspan: 2 - calc.rem(diags.len() - 1, 2),
    diags.last()
  )

  grid(
    columns: 2,
    stroke: (paint: black, dash: "dashed"),
    align: center + horizon,
    inset: 0.4em,
    ..diags
  )
}

#show-puzzle(
  5, 1,
  solve,
  example: 143,
  visualize: visualize
)
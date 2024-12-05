#import "/src/utils.typ": *

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

#show-puzzle(
  5, 1,
  solve,
  example: 143
)
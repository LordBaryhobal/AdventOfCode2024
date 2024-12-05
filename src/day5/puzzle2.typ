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

/// Bubble sort
#let fix-update(dict, update) = {
  let update = update

  let has-changed = false
  let changed = true
  while changed {
    changed = false
    for i in range(update.len() - 1) {
      let a = str(update.at(i))
      let b = str(update.at(i + 1))
      
      if a in dict.at(b, default: ()) {
        update.at(i) = int(b)
        update.at(i + 1) = int(a)
        changed = true
        has-changed = true
      }
    }
  }
  return (has-changed, update)
}

#let solve(input) = {
  let (rules, updates) = input.split("\n\n")
  rules = rules.split("\n").map(l => l.split("|"))
  updates = updates.split("\n").map(l => l.split(",").map(int))

  let total = 0
  let rules-dict = make-rules-dict(rules)

  for update in updates {
    let (has-changed, update) = fix-update(rules-dict, update)
    if has-changed {
      total += update.at(calc.div-euclid(update.len(), 2))
    }
  }

  return total
}

#show-puzzle(
  5, 2,
  solve,
  example: 123
)
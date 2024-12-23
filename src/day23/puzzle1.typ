#import "/src/utils.typ": *

#let solve(input) = {
  let links = input.split("\n")

  let links-dict = (:)

  let to-test = ()
  for link in links {
    let (a, b) = link.split("-")
    if a not in links-dict {
      links-dict.insert(a, ())
    }
    if b not in links-dict {
      links-dict.insert(b, ())
    }
    links-dict.at(a).push(b)
    links-dict.at(b).push(a)
    if a.starts-with("t") {
      to-test.push(a)
    }
    if b.starts-with("t") {
      to-test.push(b)
    }
  }

  let total = 0
  let groups = ()
  for comp1 in to-test.dedup() {
    for comp2 in links-dict.at(comp1) {
      for comp3 in links-dict.at(comp2) {
        if comp1 in links-dict.at(comp3) {
          let group = (comp1, comp2, comp3).sorted()
          if group not in groups {
            total += 1
            groups.push(group)
          }
        }
      }
    }
  }

  return total
}

#show-puzzle(
  23, 1,
  solve,
  example: 7
)
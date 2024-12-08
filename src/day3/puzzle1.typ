#import "/src/utils.typ": *

#let reg = regex("mul\((\d{1,3}),(\d{1,3})\)")
#let solve(input) = {
  let matches = input.matches(reg)
  let total = matches.map(m => {
    m.captures.map(int)
              .product()
  }).sum()
  return total
}

#let visualize(input) = {
  [
    #set text(size: 1.2em)
    #show reg: it => {
      let m = it.text.match(reg)
      let v = m.captures.map(int).product()
      math.underbrace(
        highlight(fill: red, raw(it.text)),
        text(size: 1.5em, str(v))
      )
    }
    #raw(input)
  ]
}

#show-puzzle(
  3, 1,
  solve,
  example: ("1": 161),
  visualize: visualize
)
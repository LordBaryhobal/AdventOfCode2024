#let star-state = state("stars", (:))

#let star = text(font: "Twitter Color Emoji", emoji.star)

#let get-input-path(day) = {
  return "/res/inputs/day" + str(day) + ".txt"
}

#let get-example-path(day, suffix: none) = {
  let suffix = if suffix != none {"_" + str(suffix)} else {""}
  return "/res/examples/day" + str(day) + str(suffix) + ".txt"
}

#let get-input(day) = {
  return read(get-input-path(day))
}

#let check-example(
  day,
  func,
  target-result,
  suffix: none,
  visualize: none
) = {
  let input = read(get-example-path(day, suffix: suffix))
  let result = (func)(input)
  let passes = (result == target-result)
  let name = if suffix == none [Example] else [Example '#suffix']
  let badge = box(
    inset: (x: 1.2em, y: 0.6em),
    radius: 1.2em,
    baseline: 35%,
    fill: if passes {green.lighten(20%)} else {red.lighten(20%)},
    if passes [#name passes] else [#name fails]
  )
  if not passes {
    badge = box(
      baseline: 35%,
      grid(
        columns: 2,
        align: horizon,
      )[
        #badge
        Expected '#repr(target-result)' got '#repr(result)'
      ]
    )
  }

  [#badge #h(0.6em)]

  if visualize != none {
    linebreak()
    figure(
      visualize(input),
      caption: [#name (visualization)]
    )
  }
}

#let show-result(result) = {
  box(
    inset: (x: 1.2em, y: 0.6em),
    radius: 1.2em,
    baseline: 35%,
    fill: blue.lighten(20%),
    text(fill: white)[Result: #raw(repr(result))]
  )
}

#let show-puzzle(
  day,
  puzzle,
  func,
  example: none,
  visualize: none,
  only-example: false
) = {
  let check-example = check-example.with(visualize: visualize)
  if example != none {
    if type(example) == dictionary {
      for (suffix, result) in example.pairs() {
        check-example(day, func, result, suffix: suffix)
      }
    } else {
      check-example(day, func, example)
    }
    linebreak()
  }

  if not only-example {
    let input = get-input(day)
    let result = (func)(input)
    show-result(result)
  }
}

#let day-template(day, puzzle1, puzzle2, stars: 0) = {
  pagebreak(weak: true)
  let title = [Day #day] + box(
    baseline: -1pt,
    ((star,)*stars).join()
  )
  
  [
    = #title
    #label("day-" + str(day))
  ] // Newline required to avoid attaching the label to the text
  heading(level: 2)[Puzzle 1]
  puzzle1

  heading(level: 2)[Puzzle 2]
  puzzle2
}

#let make-day(day, stars: 0) = {
  star-state.update(s => s + (str(day): stars))
  day-template(
    stars: stars,
    day,
    include("/src/day" + str(day) + "/puzzle1.typ"),
    include("/src/day" + str(day) + "/puzzle2.typ"),
  )
}

#let make-badge(name, img) = {
  let img = scale(3em, img, reflow: true)
  box(
    grid(
      columns: 2,
      align: center + horizon,
      column-gutter: 0.4em,
      [*#name*],
      box(
        img,
        radius: 1.5em,
        clip: true
      )
    ),
    fill: green.lighten(50%),
    inset: (left: 0.8em),
    radius: 1.5em
  )
}

#let make-progress(
  links: true,
  badge: none
) = context {
  let stars = star-state.final()
  let star-cnt = stars.values().sum(default: 0)
  let first-weekday = datetime(
    year: 2024,
    month: 12,
    day: 1
  ).weekday()
  let cells = ([],) * (first-weekday - 1)

  for i in range(1, 26) {
    let cell = [#i]
    if str(i) in stars.keys() {
      cell = stack(
        dir: ttb,
        spacing: 0.2em,
        cell,
        ((star,)* stars.at(str(i))).join()
      )
      if links {
        cell = link(label("day-" + str(i)), cell)
      }
    }

    cells.push(cell)
  }

  let badge = if badge != none {
    make-badge(badge.name, badge.img)
  }

  [*Stars: #star-cnt / 50*#h(1fr)#badge]
  table(
    columns: (1fr,)*7,
    inset: 0.8em,
    align: center + horizon,
    fill: (_, y) => if y > 0 and calc.rem(y, 2) == 0 {gray.lighten(70%)},
    table.header([*Mon*], [*Tue*], [*Wed*], [*Thu*], [*Fri*], [*Sat*], [*Sun*]),
    ..cells
  )
}

#let template(body) = {
  set text(font: "Source Sans 3")
  set page(
    footer: context {
      align(center, counter(page).display("1 / 1", both: true))
    }
  )
  body
}
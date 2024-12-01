#let star-state = state("stars", (:))

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

#let check-example(day, func, target-result, suffix: none) = {
  let result = (func)(read(get-example-path(day, suffix: suffix)))
  /*assert(
    result == target-result,
    message: "Expected '" + repr(target-result) + "' got '" + repr(result) + "'"
  )*/
  let passes = (result == target-result)
  let name = if suffix == none [Example] else [Example '#suffix']
  box(
    inset: (x: 1.2em, y: 0.6em),
    radius: 1.2em,
    fill: if passes {green.lighten(20%)} else {red.lighten(20%)},
    if passes [#name passes] else [#name fails]
  )
  h(0.6em)
}

#let show-result(result) = {
  box(
    inset: (x: 1.2em, y: 0.6em),
    radius: 1.2em,
    fill: blue.lighten(20%),
    text(fill: white)[Result: #result]
  )
}

#let show-puzzle(puzzle, func, example: none) = {
  if example != none {
    if type(example) == dictionary {
      for (suffix, result) in example.pairs() {
        check-example(puzzle, func, result, suffix: suffix)
      }
    } else {
      check-example(puzzle, func, example)
    }
    linebreak()
  }

  let input = get-input(1)
  let result = (func)(input)
  show-result(result)
}

#let day-template(day, puzzle1, puzzle2, stars: 0) = {
  pagebreak(weak: true)
  let title = [Day #day] + ((emoji.star,)*stars).join()
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

#let make-progress(links: true) = context {
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
        h(3pt) + ((emoji.star,)* stars.at(str(i))).join()
      )
      if links {
        cell = link(label("day-" + str(i)), cell)
      }
    }

    cells.push(cell)
  }

  [*Stars: #star-cnt / 50*]
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
  body
}
#import "@preview/cetz:0.3.1": canvas, draw
#import "/src/utils.typ": *

#set document(
  title: "Advent of Code 2024",
  author: "Lord Baryhobal",
  date: datetime.today()
)
#show: template

#align(center, text(size: 2em)[*Advent of Code*])
#align(center, text(size: 1.5em)[*--- 2024 ---*])

#v(1cm)

#align(center, text(size: 1.2em)[_by Lord Baryhobal_])

#v(2cm)

/*
#align(center, canvas({
  draw.merge-path(
    {
      draw.line((-0.5, 0), (0.5, 0), (0.5, 1))
      draw.arc-through((), (1.3, 0.9), (2, 1.2))
      draw.arc-through((), (1.3, 1.4), (0.5, 2))
      draw.arc-through((), (1.35, 1.8), (1.9, 1.9))
      draw.arc-through((), (1.3, 2.1), (0.4, 3))
      draw.arc-through((), (0.9, 2.7), (1.5, 2.8))
      draw.arc-through((), (0.5, 3.5), (0, 4.5))
      
      draw.arc-through((), (-0.5, 3.5), (-1.5, 2.8))
      draw.arc-through((), (-0.9, 2.7), (-0.4, 3))
      draw.arc-through((), (-1.3, 2.1), (-1.9, 1.9))
      draw.arc-through((), (-1.35, 1.8), (-0.5, 2))
      draw.arc-through((), (-1.3, 1.4), (-2, 1.2))
      draw.arc-through((), (-1.3, 0.9), (-0.5, 1))
    },
    close: true,
    fill: gradient.linear(
      angle: 90deg,
      rgb("#35AA48"),
      rgb("#2C883A")
    ),
    stroke: none
  )
  draw.rect(
    (-0.5, 0),
    (0.5, 0.9),
    fill: rgb("#63584B"),
    stroke: none
  )
}))*/


#v(1fr)

#context {
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
      cell = link(label("day-" + str(i)), cell)
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

#pagebreak()

#box(
  inset: 1em,
  stroke: black,
  width: 100%,
  columns(
    2,
    outline(
      indent: 1em
    )
  )
)

#make-day(1, stars: 1)
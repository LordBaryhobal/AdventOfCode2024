#import "/src/utils.typ": *

#let parse-input(input) = {
  let blocks = ()
  let holes = ()

  let block-i = 0
  let is-block = true
  let pos = 0
  for c in input {
    let block = (pos, int(c))
    if is-block {
      block.push(block-i)
      block-i += 1
      blocks.push(block)
    } else {
      holes.push(block)
    }
    pos += int(c)
    is-block = not is-block
  }
  
  return (blocks, holes)
}

#let compute-checksum(blocks) = {
  let total = 0
  for (i0, l, id) in blocks {
    total += id * range(i0, i0 + l).sum()
  }
  return total
}

#let insert(list, elmt) = {
  for (i, elmt2) in list.enumerate() {
    if elmt.first() < elmt2.first() {
      list.insert(i, elmt)
      return list
    }
  }
  list.push(elmt)
  return list
}

#let solve(input) = {
  let (blocks, holes) = parse-input(input)

  for (hi, hl) in holes {
    while hl > 0 {
      if blocks.last().first() < hi + hl {
        break
      }

      let (bi, bl, bid) = blocks.pop()

      let len = calc.min(hl, bl)

      blocks.insert(0, (hi, len, bid))

      if len < bl {
        blocks = insert(blocks, (bi, bl - len, bid))
      }

      hl -= len
      hi += len
    }
    if hl > 0 {
      break
    }
  }
  
  return compute-checksum(blocks)
}

#let visualize(input) = {
  let (blocks, holes) = parse-input(input)
  let max-id = blocks.last().last()

  let col-gradient = gradient.linear(red, orange, yellow, green, aqua, blue, purple)

  let show-fs(size, blocks) = {
    let cells = ()
    for (bi, bl, bid) in blocks {
      cells.push(
        grid.cell(
          x: bi,
          colspan: bl,
          fill: col-gradient.sample(bid * 100% / max-id),
          str(bid)
        )
      )
    }
    grid(
      columns: (1fr,) * size,
      align: center + horizon,
      stroke: black,
      inset: 0.3em,
      ..cells
    )
  }

  let last-block = blocks.last()
  let last-holes = holes.last()
  let show-fs = show-fs.with(
    calc.max(
      last-block.first() + last-block.at(1),
      last-holes.first() + last-holes.last()
    )
  )
  let steps = ()
  steps.push(show-fs(blocks))

  for (hi, hl) in holes {
    while hl > 0 {
      if blocks.last().first() < hi + hl {
        break
      }
      let (bi, bl, bid) = blocks.pop()
      let len = calc.min(hl, bl)
      blocks.insert(0, (hi, len, bid))
      if len < bl {
        blocks = insert(blocks, (bi, bl - len, bid))
      }
      hl -= len
      hi += len
    }
    if hl > 0 {
      break
    }
    steps.push(show-fs(blocks))
  }

  stack(
    spacing: 0.5em,
    ..steps
  )
}

#show-puzzle(
  9, 1,
  solve,
  example: (
    "1": 60,
    "2": 1928
  ),
  only-example: true,
  visualize: visualize
)

// Too long to recompile everytime
#show-result(6390180901651)
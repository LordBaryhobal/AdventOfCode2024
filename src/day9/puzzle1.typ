#import "/src/utils.typ": *

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

#show-puzzle(
  9, 1,
  solve,
  example: (
    "1": 60,
    "2": 1928
  ),
  only-example: true
)

// Too long to recompile everytime
#show-result(6390180901651)
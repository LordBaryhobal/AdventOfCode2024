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
    let size = int(c)
    if is-block {
      blocks.push((pos, size, block-i))
      block-i += 1
    } else {
      holes.push((pos, size))
    }
    pos += int(c)
    is-block = not is-block
  }

  let blocks2 = ()
  for (bi, bl, bid) in blocks.rev() {
    for (i, (hi, hl)) in holes.enumerate() {
      if hi < bi and bl <= hl {
        bi = hi
        holes.at(i).first() += bl
        holes.at(i).last() -= bl
        if bl == hl {
          holes.remove(i)
        }
        break
      }
    }
    blocks2.push((bi, bl, bid))
  }
  
  return compute-checksum(blocks2)
}

#show-puzzle(
  9, 2,
  solve,
  example: (
    "1": 132,
    "2": 2858
  ),
  only-example: true
)

// Too long to recompile everytime
#show-result(6412390114238)
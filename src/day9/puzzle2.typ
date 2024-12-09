#import "/src/utils.typ": *
#import "puzzle1.typ": parse-input, compute-checksum, insert, show-fs

#let solve(input) = {
  let (blocks, holes) = parse-input(input)
  
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

#let visualize(input) = {
  let (blocks, holes) = parse-input(input)
  let max-id = blocks.last().last()

  let last-block = blocks.last()
  let last-holes = holes.last()
  let show-fs = show-fs.with(
    calc.max(
      last-block.first() + last-block.at(1),
      last-holes.first() + last-holes.last()
    ),
    max-id
  )
  let steps = ()
  steps.push(show-fs(blocks))

  let ids = ()
  let blocks2 = ()
  for (bi, bl, bid) in blocks.rev() {
    let moved = false
    for (i, (hi, hl)) in holes.enumerate() {
      if hi < bi and bl <= hl {
        bi = hi
        holes.at(i).first() += bl
        holes.at(i).last() -= bl
        if bl == hl {
          _ = holes.remove(i)
        }
        moved = true
        break
      }
    }
    ids.push(bid)
    blocks2.push((bi, bl, bid))
    if moved {
      steps.push(show-fs(
        blocks.filter(b => b.last() not in ids) +
        blocks2
      ))
    }
  }

  stack(
    spacing: 0.5em,
    ..steps
  )
}

#show-puzzle(
  9, 2,
  solve,
  example: (
    "1": 132,
    "2": 2858
  ),
  only-example: true,
  visualize: visualize
)

// Too long to recompile everytime
#show-result(6412390114238)
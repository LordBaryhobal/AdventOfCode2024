#import "/src/utils.typ": *

#let random(prev) = {
  let step(a, shift) = {
    let s = if shift < 0 {
      a.bit-rshift(-shift)
    } else {
      a.bit-lshift(shift)
    }
    return s.bit-xor(a).bit-and(0xffffff)
  }
  let b = step(prev, 6)
  let c = step(b, -5)
  let d = step(c, 11)
  return d
}

#let solve(input, steps: 1) = {
  let values = input.split("\n").map(int)
  let total = 0
  for value in values {
    for _ in range(steps) {
      value = random(value)
    }
    total += value
  }
  return total
}

#let examples = ()
#let results = (
  15887950,
  16495136,
  527345,
  704524,
  1553684,
  12683156,
  11100544,
  12249484,
  7753432,
  5908254
)
#for (i, res) in results.enumerate() {
  examples.push((
    result: res,
    args: (steps: i + 1)
  ))
}

#show-puzzle(
  22, 1,
  solve.with(steps: 2000),
  example: examples,
  only-example: true
)

#show-result(18261820068)

//B = ((A << 6) ^ A) & 0xffffff\
//C = ((B >> 5) ^ B) & 0xffffff\
//D = ((C << 11) ^ C) & 0xffffff
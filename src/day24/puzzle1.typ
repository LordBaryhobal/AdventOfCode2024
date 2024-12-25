#import "/src/utils.typ": *

#let solve(input) = {
  let (inputs, gates) = input.split("\n\n")
  let ids = ()
  inputs = inputs.split("\n").map(i => {
    let (id, value) = i.split(": ")
    return (id: id, value: value == "1")
  })
  ids += inputs.map(i => i.id)
  gates = gates.split("\n").map(g => {
    let (gate, output) = g.split(" -> ")
    let (i1, op, i2) = gate.split(" ")
    return (
      in1: i1,
      in2: i2,
      op: op,
      out: output
    )
  })
  let gates-by-id = (:)
  for gate in gates {
    gates-by-id.insert(gate.out, gate)
  }

  ids += gates.map(g => g.out)
  ids = ids.dedup()
  let dbg = (inputs, gates)

  let values = (:)
  for input in inputs {
    values.insert(input.id, input.value)
  }

  let stack = ids.filter(id => id.starts-with("z"))
  let output = (0,) * stack.len()
  while stack.len() != 0 {
    let v = stack.pop()
    if v in values {
      if v.starts-with("z") {
        let i = int(v.slice(1))
        output.at(i) = int(values.at(v))
      }
    } else {
      stack.push(v)
      let gate = gates-by-id.at(v)
      if gate.in1 in values and gate.in2 in values {
        let v1 = values.at(gate.in1)
        let v2 = values.at(gate.in2)
        let value = if gate.op == "AND" {
          v1 and v2
        } else if gate.op == "OR" {
          v1 or v2
        } else if gate.op == "XOR" {
          (v1 or v2) and not (v1 and v2)
        }
        values.insert(v, value)
      } else {
        stack.push(gate.in1)
        stack.push(gate.in2)
      }
    }
  }

  let result = output.rev()
                     .fold(0, (a, b) => a.bit-lshift(1).bit-or(b))

  return result
}

#show-puzzle(
  24, 1,
  solve,
  example: (
    "1": 4,
    "2": 2024
  )
)
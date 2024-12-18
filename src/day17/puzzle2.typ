#import "/src/utils.typ": *

#let ADV = 0
#let BXL = 1
#let BST = 2
#let JNZ = 3
#let BXC = 4
#let OUT = 5
#let BDV = 6
#let CDV = 7

#let ops = ("ADV", "BXL", "BST", "JNZ", "BXC", "OUT", "BDV", "CDV")

#let get-combo(regs, value) = {
  if value >= 7 {
    panic()
  }
  if value <= 3 {
    return value
  }
  return regs.at(value - 4)
}

#let describe-combo(value) = {
  if value == 7 {
    return "<invalid>"
  }
  if value <= 3 {
    return str(value)
  }
  return "ABC".at(value - 4)
}

#let describe(program) = {
  let res = ""
  res += program.map(str).join(",")

  for i in range(0, program.len(), step: 2) {
    res += "\n"
    let op = program.at(i)
    let val = program.at(i + 1)
    let combo = describe-combo(val)

    res += ops.at(op) + ": "
    if op == ADV {
      res += "A >>= " + combo
    } else if op == BXL {
      res += "B ^= " + str(val)
    } else if op == BST {
      res += "B = " + combo + " & 0b111"
    } else if op == JNZ {
      res += "IF A != 0 {PC = " + str(val) + "}"
    } else if op == BXC {
      res += "B ^= C"
    } else if op == OUT {
      res += "OUT(" + combo + " & 0b111)"
    } else if op == BDV {
      res += "B = A >> " + combo
    } else if op == CDV {
      res += "C = A >> " + combo
    }
  }
  return res
}

#let solve(input) = {
  let (registers, program) = input.split("\n\n")

  let regs = ()
  for line in registers.split("\n") {
    regs.push(
      int(
        line.split(": ")
            .last()
      )
    )
  }
  program = program.split(": ")
                   .last()
                   .split(",")
                   .map(int)

  let out = ()
  let pc = 0

  regs.first() = 0

  for n in program {
    let b = n
  }
  
  return raw(block: true, describe(program))
}

Example:
#solve(read(get-example-path(17, suffix: "2")))

Input:
#solve(get-input(17))

/*
#show-puzzle(
  17, 2,
  solve,
  example: (
    "2": 117440
  )
)*/
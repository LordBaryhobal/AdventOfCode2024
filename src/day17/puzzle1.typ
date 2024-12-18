#import "/src/utils.typ": *

#let ADV = 0
#let BXL = 1
#let BST = 2
#let JNZ = 3
#let BXC = 4
#let OUT = 5
#let BDV = 6
#let CDV = 7

#let get-combo(regs, value) = {
  if value >= 7 {
    panic()
  }
  if value <= 3 {
    return value
  }
  return regs.at(value - 4)
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
  while pc < program.len() {
    let op = program.at(pc)
    let val = program.at(pc + 1)
    if op == ADV {
      let num = regs.at(0)
      let den = get-combo(regs, val)
      let res = num.bit-rshift(den)
      regs.at(0) = res
    } else if op == BXL {
      regs.at(1) = regs.at(1).bit-xor(val)
    } else if op == BST {
      regs.at(1) = get-combo(regs, val).bit-and(0b111)
    } else if op == JNZ {
      if regs.at(0) != 0 {
        pc = val
        continue
      }
    } else if op == BXC {
      regs.at(1) = regs.at(1).bit-xor(regs.at(2))
    } else if op == OUT {
      out.push(get-combo(regs, val).bit-and(0b111))
    } else if op == BDV {
      let num = regs.at(0)
      let den = get-combo(regs, val)
      let res = num.bit-rshift(den)
      regs.at(1) = res
    } else if op == CDV {
      let num = regs.at(0)
      let den = get-combo(regs, val)
      let res = num.bit-rshift(den)
      regs.at(2) = res
    } else {
      panic("Unknown instruction " + str(op))
    }
    pc += 2
  }

  return out.map(str).join(",")
}

#show-puzzle(
  17, 1,
  solve,
  example: (
    "1": "4,6,3,5,6,3,5,2,1,0"
  )
)
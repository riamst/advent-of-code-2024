import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import simplifile

pub fn main() {
  let assert Ok(input) = simplifile.read("inputs/3.txt")
  let ins = parse(input)
  part1(ins)
  part2(ins)
}

fn part1(ins) {
  let res =
    ins
    |> list.fold(0, fn(acc, elem) {
      case elem {
        Mul(e) -> acc + e
        _ -> acc
      }
    })
  res |> io.debug
}

fn part2(ins) {
  let res =
    ins
    |> list.fold(#(0, Doing), fn(acc, elem) {
      let #(sum, state) = acc
      case elem, state {
        Do, _ -> #(sum, Doing)
        Dont, _ -> #(sum, NotDoing)
        Mul(e), Doing -> #(sum + e, Doing)
        Mul(_), NotDoing -> #(sum, state)
      }
    })
  res.0 |> io.debug
}

type State {
  Doing
  NotDoing
}

type Instruction {
  Mul(Int)
  Do
  Dont
}

fn parse(input) {
  let assert Ok(reg) = regexp.from_string("(mul|don't|do)\\((\\d*),*(\\d*)\\)")
  regexp.scan(reg, input)
  |> list.filter_map(fn(m) {
    let regexp.Match(_content, submatches) = m
    case submatches {
      [option.Some("mul"), option.Some(a), option.Some(b)] -> {
        let assert Ok(a) = int.parse(a)
        let assert Ok(b) = int.parse(b)
        Ok(Mul(a * b))
      }
      [option.Some("do"), ..] -> Ok(Do)
      [option.Some("don't"), ..] -> Ok(Dont)
      _ -> Error(Nil)
    }
  })
}

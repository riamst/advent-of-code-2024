import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(input) = simplifile.read("inputs/11.txt")
  let a = parse(input)
  list.range(1, 75)
  |> list.fold(a, fn(acc, _) {
    dict.to_list(acc)
    |> list.fold(dict.new(), fn(acc2, e2) {
      blink1(e2.0, e2.1) |> dict.combine(acc2, fn(a, b) { a + b })
    })
  })
  |> dict.values
  |> list.fold(0, int.add)
  |> io.debug
}

fn parse(input) {
  input
  |> string.trim
  |> string.split(" ")
  |> list.fold(dict.new(), fn(acc, e) {
    let assert Ok(num) = int.parse(e)
    dict.insert(acc, num, 1)
  })
}

fn blink1(num, freq) {
  let str_num = int.to_string(num)
  let digits = string.length(str_num)
  case num, digits % 2 {
    0, _ -> dict.from_list([#(1, freq)])
    _, 0 -> {
      let assert Ok(left) = string.slice(str_num, 0, digits / 2) |> int.parse
      let assert Ok(right) =
        string.slice(str_num, digits / 2, digits / 2) |> int.parse
      case left == right {
        True -> dict.from_list([#(left, 2 * freq)])
        False -> dict.from_list([#(left, freq), #(right, freq)])
      }
    }
    _, _ -> dict.from_list([#(num * 2024, freq)])
  }
}

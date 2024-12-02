import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(input) = simplifile.read("inputs/2.txt")
  let lines = parse(input)
  part1(lines)
  part2(lines)
}

fn parse(input) {
  let lines =
    string.split(input, "\n") |> list.filter(fn(a) { !string.is_empty(a) })
  lines
  |> list.map(fn(line) {
    string.split(line, " ")
    |> list.map(fn(a) {
      let assert Ok(num) = int.parse(a)
      num
    })
  })
}

fn is_safe(level) {
  let diffs =
    level
    |> list.window_by_2
    |> list.map(fn(a) { a.1 - a.0 })
  let increasing = list.all(diffs, fn(a) { a > 0 && a < 4 })
  let decreasing = list.all(diffs, fn(a) { a < 0 && a > -4 })
  increasing || decreasing
}

fn part1(levels) {
  levels |> list.filter(is_safe) |> list.length |> int.to_string |> io.println
}

fn part2(levels) {
  levels
  |> list.map(fn(level) { pop1s(level) |> list.filter(is_safe) |> list.length })
  |> list.filter(fn(a) { a > 0 })
  |> list.length
  |> int.to_string
  |> io.println
}

fn pop1s(level) -> List(List(Int)) {
  let indexed_level = level |> list.index_map(fn(a, i) { #(a, i) })
  let length = list.length(level)
  let popped_lists =
    list.range(0, length)
    |> list.fold([], fn(acc, i) {
      let popped_list =
        indexed_level
        |> list.filter_map(fn(a) {
          case a.1 != i {
            True -> Ok(a.0)
            False -> Error(Nil)
          }
        })
      [popped_list, ..acc]
    })
  [level, ..popped_lists]
}

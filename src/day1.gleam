import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(input) = simplifile.read("inputs/1.txt")
  let assert Ok(#(left, right)) = parse(input)

  part1(left, right)
  part2(left, right)
}

fn parse(input) {
  let lines =
    string.split(input, "\n") |> list.filter(fn(a) { !string.is_empty(a) })

  let processed_lines = {
    use line <- list.try_map(lines)
    use #(a, b) <- result.try(string.split_once(line, "   "))
    use a <- result.try(int.parse(a))
    use b <- result.try(int.parse(b))
    Ok(#(a, b))
  }

  result.map(processed_lines, list.unzip)
}

fn part2(left, right) {
  let left_dict = left |> list.map(fn(a) { #(a, 0) }) |> dict.from_list()

  let ans =
    right
    |> list.fold(left_dict, fn(acc, elem) {
      case dict.get(acc, elem) {
        Error(_) -> acc
        Ok(count) -> dict.insert(acc, elem, count + 1)
      }
    })
    |> dict.fold(0, fn(acc, k, v) { acc + k * v })
    |> int.to_string

  io.println("Day 2: " <> ans)
}

fn part1(left, right) {
  let left = list.sort(left, int.compare)
  let right = list.sort(right, int.compare)

  let ans =
    list.zip(left, right)
    |> list.map(fn(a) { int.absolute_value(a.0 - a.1) })
    |> list.fold(0, int.add)
    |> int.to_string

  io.println("Day 1: " <> ans)
}

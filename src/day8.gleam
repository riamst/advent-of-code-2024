import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(input) = simplifile.read("inputs/8.txt")
  let #(dishes, width, height) = parse(input)
  part1(dishes, width, height) |> io.debug
  Nil
}

fn part1(dishes, width, height) {
  dishes
  |> dict.fold(set.new(), fn(acc, _, positions) {
    let anodes = get_antinodes(positions)
    acc |> set.union(anodes)
  })
  |> set.to_list
  |> list.filter(fn(a) {
    let Position(x, y) = a
    x >= 0 && x <= width && y >= 0 && y <= height
  })
  |> list.length
}

type Position {
  Position(Int, Int)
}

fn parse(input) -> #(Dict(String, List(Position)), Int, Int) {
  let lines =
    input
    |> string.split("\n")
  let height = list.length(lines) - 2
  let tiles =
    lines
    |> list.index_map(fn(a, y) {
      a
      |> string.to_graphemes
      |> list.index_map(fn(char, x) { #(char, x, y) })
    })
    |> list.flatten
  let width = list.length(tiles) / height - 2

  #(
    tiles
      |> list.fold(dict.new(), fn(acc, e) {
        let #(char, x, y) = e
        case char, dict.get(acc, char) {
          ".", _ -> acc
          _, Error(_) -> dict.insert(acc, char, [Position(x, y)])
          _, Ok(positions) ->
            dict.insert(acc, char, [Position(x, y), ..positions])
        }
      }),
    width,
    height,
  )
}

fn get_antinodes(a: List(Position)) -> Set(Position) {
  a
  |> list.combination_pairs
  |> list.fold(set.new(), fn(acc, e) {
    let #(Position(x1, y1), Position(x2, y2)) = e
    let dx = x2 - x1
    let dy = y2 - y1
    let ax1 = x1 - dx
    let ay1 = y1 - dy
    let ax2 = x2 + dx
    let ay2 = y2 + dy
    set.insert(acc, Position(ax1, ay1))
    |> set.insert(Position(ax2, ay2))
  })
}

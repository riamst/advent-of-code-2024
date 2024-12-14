import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(input) = simplifile.read("inputs/14.txt")
  let bots = parse(input)
  part1(bots, 101, 103, 100) |> io.debug
}

fn part1(bots: List(Bot), width: Int, height: Int, turns: Int) -> Int {
  case turns {
    0 -> get_safety_factor(bots, width, height)
    t -> {
      let new_bots = list.map(bots, move(_, width, height))
      part1(new_bots, width, height, t - 1)
    }
  }
}

fn get_safety_factor(bots: List(Bot), width: Int, height: Int) -> Int {
  let mid_x = { width - 1 } / 2
  let mid_y = { height - 1 } / 2
  let #(a, b, c, d) =
    list.fold(bots, #(0, 0, 0, 0), fn(acc, e) {
      case e {
        Bot(x, y, _, _) if x < mid_x && y < mid_y -> #(
          acc.0 + 1,
          acc.1,
          acc.2,
          acc.3,
        )
        Bot(x, y, _, _) if x > mid_x && y < mid_y -> #(
          acc.0,
          acc.1 + 1,
          acc.2,
          acc.3,
        )
        Bot(x, y, _, _) if x < mid_x && y > mid_y -> #(
          acc.0,
          acc.1,
          acc.2 + 1,
          acc.3,
        )
        Bot(x, y, _, _) if x > mid_x && y > mid_y -> #(
          acc.0,
          acc.1,
          acc.2,
          acc.3 + 1,
        )
        _ -> acc
      }
    })
  a * b * c * d
}

fn move(bot: Bot, width: Int, height: Int) -> Bot {
  let assert Ok(new_x) = int.modulo(bot.x + bot.dx, width)
  let assert Ok(new_y) = int.modulo(bot.y + bot.dy, height)
  Bot(..bot, x: new_x, y: new_y)
}

type Bot {
  Bot(x: Int, y: Int, dx: Int, dy: Int)
}

fn parse(input) -> List(Bot) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(a) {
    let assert ["p=" <> left, "v=" <> right] = string.split(a, " ")
    let assert [x, y] = string.split(left, ",")
    let assert [dx, dy] = string.split(right, ",")
    let assert Ok(x) = int.parse(x)
    let assert Ok(y) = int.parse(y)
    let assert Ok(dx) = int.parse(dx)
    let assert Ok(dy) = int.parse(dy)
    Bot(x, y, dx, dy)
  })
}

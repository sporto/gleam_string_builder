import string_builder as sb
import gleam/should
import gleam/int
import gleam/string

pub fn using_compose_test() {
  let formatter =
    sb.string("My name ")
    |> sb.compose(sb.string("is "))
    |> sb.compose(sb.string_arg)
    |> sb.compose(sb.string(" and I have "))
    |> sb.compose(sb.int_arg)
    |> sb.compose(sb.string(" "))
    // dogs
    |> sb.compose(sb.string_arg)
    |> sb.compose(sb.string(", "))
    |> sb.compose(sb.int_arg)
    |> sb.compose(sb.string(" "))
    // cats
    |> sb.compose(sb.string_arg)
    |> sb.compose(sb.string(" and "))
    |> sb.compose(sb.int(1))
    |> sb.compose(sb.string(" snake!"))

  formatter(sb.caller)("Sally")(3)("dogs")(2)("cats")
  |> should.equal("My name is Sally and I have 3 dogs, 2 cats and 1 snake!")
}

pub fn using_and_test() {
  let formatter =
    sb.string("My name ")
    |> sb.and_string("is ")
    |> sb.and_string_arg
    |> sb.and_string(" and I have ")
    |> sb.and_int_arg
    |> sb.and_string(" ")
    // dogs
    |> sb.and_string_arg
    |> sb.and_string(", ")
    |> sb.and_int_arg
    |> sb.and_string(" ")
    // cats
    |> sb.and_string_arg
    |> sb.and_string(" and ")
    |> sb.and_int(1)
    |> sb.and_string(" snake!")

  formatter(sb.caller)("Sally")(3)("dogs")(2)("cats")
  |> should.equal("My name is Sally and I have 3 dogs, 2 cats and 1 snake!")
}

pub fn caller_test() {
  let formatter =
    sb.string("Hello ")
    |> sb.and_string_arg

  formatter(sb.caller)("Sally")
  |> should.equal("Hello Sally")
}

type State {
  Pending
  Done
}

fn state_to_string(state: State) -> String {
  case state {
    Pending -> "pending"
    Done -> "done"
  }
}

pub fn custom_formatter_test() {
  let custom_state_formatter = fn(callback) {
    fn(input: State) {
      input
      |> state_to_string
      |> callback
    }
  }

  let formatter =
    sb.string("The current state is ")
    |> sb.compose(custom_state_formatter)
    |> sb.and_string("!")

  formatter(sb.caller)(Done)
  |> should.equal("The current state is done!")
}

pub fn uncurry_test() {
  let f1 = fn(a: Int) { fn(b: Int) { fn(c: Int) { a + b + c } } }

  let f2 = sb.uncurry3(f1)

  f2(1, 2, 3)
  |> should.equal(6)
}

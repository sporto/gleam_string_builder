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

  formatter(sb.identity)("Sally")(3)("dogs")(2)("cats")
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

  formatter(sb.identity)("Sally")(3)("dogs")(2)("cats")
  |> should.equal("My name is Sally and I have 3 dogs, 2 cats and 1 snake!")
}

pub fn call0_test() {
  let formatter =
    sb.string("My name is ")
    |> sb.and_string("Sally.")
    |> sb.call0

  formatter()
  |> should.equal("My name is Sally.")
}

pub fn call1_test() {
  let formatter =
    sb.string("My name is ")
    |> sb.and_string_arg
    |> sb.and_string(".")
    |> sb.call1

  formatter("Sally")
  |> should.equal("My name is Sally.")
}

pub fn call2_test() {
  let formatter =
    sb.string("My name is ")
    |> sb.and_string_arg
    |> sb.and_string(" and I'm ")
    |> sb.and_int_arg
    |> sb.and_string(" years old.")
    |> sb.call2

  formatter("Sally", 20)
  |> should.equal("My name is Sally and I'm 20 years old.")
}

pub fn call3_test() {
  let formatter =
    sb.string_arg
    |> sb.and_string(" has ")
    |> sb.and_int_arg
    |> sb.and_string(" dogs and ")
    |> sb.and_int_arg
    |> sb.and_string(" cats.")
    |> sb.call3

  formatter("Sam", 2, 3)
  |> should.equal("Sam has 2 dogs and 3 cats.")
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

  formatter(sb.identity)(Done)
  |> should.equal("The current state is done!")
}

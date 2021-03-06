import string_builder as sb
import gleam/should
import gleam/int
import gleam/string

pub fn using_compose_test() {
  let formatter =
    sb.string_formatter("My name ")
    |> sb.compose(sb.string_formatter("is "))
    |> sb.compose(sb.arg_string_formatter)
    |> sb.compose(sb.string_formatter(" and I have "))
    |> sb.compose(sb.arg_int_formatter)
    |> sb.compose(sb.string_formatter(" "))
    // dogs
    |> sb.compose(sb.arg_string_formatter)
    |> sb.compose(sb.string_formatter(", "))
    |> sb.compose(sb.arg_int_formatter)
    |> sb.compose(sb.string_formatter(" "))
    // cats
    |> sb.compose(sb.arg_string_formatter)
    |> sb.compose(sb.string_formatter(" and "))
    |> sb.compose(sb.int_formatter(1))
    |> sb.compose(sb.string_formatter(" snake!"))

  formatter(sb.identity)("Sally")(3)("dogs")(2)("cats")
  |> should.equal("My name is Sally and I have 3 dogs, 2 cats and 1 snake!")
}

pub fn shortform_test() {
  let formatter =
    sb.new
    |> sb.string("My name ")
    |> sb.string("is ")
    |> sb.arg_string
    |> sb.string(" and I have ")
    |> sb.arg_int
    |> sb.string(" ")
    // dogs
    |> sb.arg_string
    |> sb.string(", ")
    |> sb.arg_int
    |> sb.string(" ")
    // cats
    |> sb.arg_string
    |> sb.string(" and ")
    |> sb.int(1)
    |> sb.string(" snake!")

  formatter(sb.identity)("Sally")(3)("dogs")(2)("cats")
  |> should.equal("My name is Sally and I have 3 dogs, 2 cats and 1 snake!")
}

pub fn end0_test() {
  let formatter =
    sb.new
    |> sb.string("My name is ")
    |> sb.string("Sally.")
    |> sb.end0

  formatter()
  |> should.equal("My name is Sally.")
}

pub fn end1_test() {
  let formatter =
    sb.new
    |> sb.string("My name is ")
    |> sb.arg_string
    |> sb.string(".")
    |> sb.end1

  formatter("Sally")
  |> should.equal("My name is Sally.")
}

pub fn end2_test() {
  let formatter =
    sb.new
    |> sb.string("My name is ")
    |> sb.arg_string
    |> sb.string(" and I'm ")
    |> sb.arg_int
    |> sb.string(" years old.")
    |> sb.end2

  formatter("Sally", 20)
  |> should.equal("My name is Sally and I'm 20 years old.")
}

pub fn end3_test() {
  let formatter =
    sb.new
    |> sb.arg_string
    |> sb.string(" has ")
    |> sb.arg_int
    |> sb.string(" dogs and ")
    |> sb.arg_int
    |> sb.string(" cats.")
    |> sb.end3

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
    sb.new
    |> sb.string("The current state is ")
    |> sb.compose(custom_state_formatter)
    |> sb.string("!")
    |> sb.end1

  formatter(Done)
  |> should.equal("The current state is done!")
}

pub fn int_list_test() {
  let formatter =
    sb.new
    |> sb.string("The winners are ")
    |> sb.int_list([1, 2, 3])
    |> sb.end0

  formatter()
  |> should.equal("The winners are 1, 2, 3")
}

pub fn arg_int_list_test() {
  let formatter =
    sb.new
    |> sb.string("The winners are ")
    |> sb.arg_int_list
    |> sb.end1

  formatter([1, 2, 3])
  |> should.equal("The winners are 1, 2, 3")
}

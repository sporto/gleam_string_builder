import string_builder as sb
import gleam/should
import gleam/int
import gleam/string

pub fn buid_test() {
  let formatter = sb.string("Hello ")
    // |> sb.compose(sb.string("Hola "))
    |> sb.and_string("Hola ")
    // |> sb.compose(sb.string_arg())
    |> sb.and_string_arg()
    |> sb.compose(sb.string(" "))
    // |> sb.and_string(" ")
    // |> sb.compose(sb.int_arg())
    |> sb.and_int_arg()
    |> sb.compose(sb.string("!"))
    |> sb.compose(sb.string_arg())
    |> sb.compose(sb.int_arg())

  formatter(sb.caller)("Sam")(1)(" and ")(2)
  |> should.equal("Hello Hola Sam 1! and 2")
}

pub fn uncurry_test()  {
  sb.dummy_formmater()("Hello")(1)
  |> should.equal("Ok")
}
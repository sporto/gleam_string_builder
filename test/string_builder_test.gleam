import string_builder as sb
import gleam/should
import gleam/int
import gleam/string

pub fn buid_test() {
  let formatter = sb.string("Hello ")
    |> sb.compose(sb.string("Hola "))
    |> sb.compose(sb.string_arg())
    |> sb.compose(sb.int_arg())
    |> sb.compose(sb.string("!"))
    |> sb.compose(sb.string_arg())

  formatter(sb.caller)("Sam")(1)(" and ")
  |> should.equal("Hello Hola Sam1! and ")
}

pub fn uncurry_test()  {
  sb.dummy_formmater()("Hello")(1)
  |> should.equal("Ok")
}
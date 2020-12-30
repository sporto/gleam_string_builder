import string_builder as sb
import gleam/should
import gleam/int
import gleam/string

pub fn hello_world_test() {
  sb.hello_world()
  |> should.equal("Hello, from gleam_string_builder!")
}

pub fn print_test() {
  let format = fn(str) {
    fn(int) {
      [str, int.to_string(int)] |> sb.concat()
    }
  }

  format("Hola")(1)
  |> should.equal("Hola1")
}

pub fn buid_test() {
  let formatter = sb.s("Hello ")
    |> sb.bs(sb.string())
    |> sb.bs(sb.int())

  sb.print(formatter)("Sam")(1)
  |> should.equal("Hello Sam1")
}
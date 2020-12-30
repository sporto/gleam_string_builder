import gleam/int as gleam_int
import gleam/string
import gleam/function

type Format(r, a) = fn(fn(String) -> r) -> a

pub fn hello_world() -> String {
  "Hello, from gleam_string_builder!"
}

pub fn init() {
  hardcoded_string("")
}

pub fn string(formatter, str) {
  compose(formatter, hardcoded_string(str))
}

pub fn string_arg(formatter) {
  compose(formatter, placeholder_string())
}

pub fn int_arg(formatter) {
  compose(formatter, placeholder_int())
}

// A hardcoded string
pub fn hardcoded_string(str: String) -> Format(r, r) {
  fn(callback) {
    callback(str)
  }
}

// Placeholder for a string argument
pub fn placeholder_string() -> Format(r, fn(String) -> r){
  fn(s) { s }
}

pub fn placeholder_int() -> Format(r, fn(Int) -> r) {
  to_formatter(gleam_int.to_string)
}

// toFormatter : (a -> String) -> Format r (a -> r)
fn to_formatter(f) {
  fn(callback) {
    fn(value) {
      f(value) |> callback
    }
  }
}

pub fn concat(l: List(String)) -> String {
  l |> string.join("")
}

// {-| Compose two formatters together.
// -}
pub fn compose(f2: Format(a,c), f1: Format(b,a)) -> Format(b,c) {
  fn(callback) {
    f2(
      fn(str_from_f2) {
        f1(
          fn(str_from_f1) {
            callback(
              string.append(str_from_f2, str_from_f1)
            )
          }
        )
      }
    )
  }
}

pub fn print(format: Format(String, a)) -> a {
  format(function.identity)
}
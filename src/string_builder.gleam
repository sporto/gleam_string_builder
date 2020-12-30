import gleam/int as gleam_int
import gleam/string
import gleam/function

type Format(r, a) = fn(fn(String) -> r) -> a

pub fn hello_world() -> String {
  "Hello, from gleam_string_builder!"
}

// A hardcoded string
pub fn s(str: String) -> Format(r, r) {
  fn(callback) {
    callback(str)
  }
}

// Placeholder for a string argument
pub fn string() -> Format(r, fn(String) -> r){
  fn(s) { s }
}

pub fn int() -> Format(r, fn(Int) -> r) {
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
pub fn bs(f1: Format(b, a), f2: Format(a,c)) -> Format(b,c) {
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
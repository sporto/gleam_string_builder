import gleam/int as gleam_int
import gleam/string
import gleam/function

type Callback(next_formatter) =
  fn(String) -> next_formatter

type Fn(next_formatter, formatter) =
  fn(Callback(next_formatter)) -> formatter

pub fn string(str: String) -> Fn(formatter, formatter) {
  fn(callback: Callback(formatter)) -> formatter { callback(str) }
}

pub fn and_string(previous: Fn(f1, f2), str: String) -> Fn(f1, f2) {
  compose(previous, string(str))
}

pub fn int(n: Int) -> Fn(formatter, formatter) {
  fn(callback: Callback(formatter)) -> formatter {
    callback(gleam_int.to_string(n))
  }
}

pub fn and_int(previous: Fn(f1, f2), n: Int) -> Fn(f1, f2) {
  compose(previous, int(n))
}

// A placeholder for a string
pub fn string_arg(callback: Callback(formatter)) {
  fn(str: String) { callback(str) }
}

pub fn and_string_arg(previous) -> Fn(a, b) {
  previous
  |> compose(string_arg)
}

pub fn int_arg(callback: Callback(formatter)) {
  fn(int: Int) { callback(gleam_int.to_string(int)) }
}

pub fn and_int_arg(previous) -> Fn(a, b) {
  compose(previous, int_arg)
}

pub fn caller(s) {
  s
}

pub fn compose(previous: Fn(f2, f1), next: Fn(f3, f2)) -> Fn(f3, f1) {
  // Get the result of the previous and pass to the next
  fn(callback: Callback(f3)) {
    previous(fn(previous_str: String) {
      next(fn(next_str: String) {
        callback(string.append(previous_str, next_str))
      })
    })
  }
}

pub fn uncurry3(fun) {
  fn(a, b, c) { fun(a)(b)(c) }
}

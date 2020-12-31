import gleam/int as gleam_int
import gleam/string
import gleam/function

type Callback(formatter) = fn(String) -> formatter

type Fn(next_formatter, formatter) = fn(Callback(next_formatter)) -> formatter

pub fn dummy_formmater() {
  fn(str: String) {
    fn(int: Int) {
      "Ok"
    }
  }
}

pub fn string(
    str: String
  )
    -> Fn(formatter, formatter)
  {

  fn(callback: Callback(formatter)) {
    callback(str)
  }
}

pub fn and_string(previous, str: String) {
  compose(previous, string(str))
}

pub fn string_arg()
    -> Fn(formatter, fn(String) -> formatter)
  {

  fn(callback: Callback(formatter)) {
    fn(str: String) {
      callback(str)
    }
  }
}

pub fn and_string_arg(previous) -> Fn(a, b) {
  previous |> compose(string_arg())
}

pub fn int_arg()
    -> Fn(formatter, fn(Int) -> formatter)
  {

  fn(callback: Callback(formatter)) {
    fn(int: Int) {
      callback(gleam_int.to_string(int))
    }
  }
}

pub fn and_int_arg(previous) {
  compose(previous, int_arg())
}

pub fn caller(s) {
  s
}

pub fn compose(previous: Fn(f2, f1), next: Fn(f3, f2)) -> Fn(f3, f1) {
  // Get the result of the previous and pass to the next
  fn(callback: Callback(f3)) {
    previous(
      fn(previous_str: String) {
        next(
          fn(next_str: String) {
            callback(string.append(previous_str, next_str))
          }
        )
      }
    )
  }
}

import gleam/int as gleam_int
import gleam/string
import gleam/function

type Callback(formatter) = fn(String) -> formatter

// type Formatter() = fn(Callback(a)) -> (fn(b) -> String)

pub fn dummy_formmater() {
  fn(str: String) {
    fn(int: Int) {
      "Ok"
    }
  }
}

pub fn string(
    str: String
  ) -> fn(Callback(formatter)) -> formatter {

  fn(callback: Callback(formatter)) {
    callback(str)
  }
}

// pub fn and_string(previous, str: String) {
//   compose(previous, string(str))
// }

pub fn string_arg()
    -> fn(Callback(formatter)) -> fn(String) -> formatter
  {

  fn(callback: Callback(formatter)) {
    fn(str: String) {
      callback(str)
    }
  }
}

pub fn int_arg()
    -> fn(Callback(formatter)) -> fn(Int) -> formatter
  {

  fn(callback: Callback(formatter)) {
    fn(int: Int) {
      callback(gleam_int.to_string(int))
    }
  }
}

pub fn caller(s) {
  s
}

pub fn compose(previous, next) {
  // Get the result of the previous as pass to the next
  fn(callback: Callback(formatter)) {
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

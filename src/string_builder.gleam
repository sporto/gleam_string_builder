import gleam/int as gleam_int
import gleam/string
import gleam/function

pub fn dummy_formmater() {
  fn(str: String) {
    fn(int: Int) {
      "Ok"
    }
  }
}

pub fn string(str) {
  fn(callback) {
    callback(str)
  }
}

pub fn string_arg() {
  fn(callback) {
    fn(str: String) {
      callback(str)
    }
  }
}

pub fn int_arg() {
  fn(callback) {
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
  fn(callback) {
    previous(
      fn(previous_str) {
        next(
          fn(next_str) {
            callback(string.append(previous_str, next_str))
          }
        )
      }
    )
  }
}

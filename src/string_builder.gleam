import gleam/int as gleam_int
import gleam/string
import gleam/function

type Callback(next_formatter) =
  fn(String) -> next_formatter

type Fn(next_formatter, formatter) =
  fn(Callback(next_formatter)) -> formatter

pub fn new(callback: Callback(formatter)) -> formatter {
  callback("")
}

pub fn string_formatter(str: String) -> Fn(formatter, formatter) {
  fn(callback: Callback(formatter)) -> formatter { callback(str) }
}

pub fn string(previous: Fn(f1, f2), str: String) -> Fn(f1, f2) {
  compose(previous, string_formatter(str))
}

pub fn int_formatter(n: Int) -> Fn(formatter, formatter) {
  fn(callback: Callback(formatter)) -> formatter {
    callback(gleam_int.to_string(n))
  }
}

pub fn int(previous: Fn(f1, f2), n: Int) -> Fn(f1, f2) {
  compose(previous, int_formatter(n))
}

// A placeholder for a string
pub fn arg_string_formatter(callback: Callback(formatter)) {
  fn(str: String) { callback(str) }
}

pub fn arg_string(previous) -> Fn(a, b) {
  previous
  |> compose(arg_string_formatter)
}

pub fn arg_int_formatter(callback: Callback(formatter)) {
  fn(int: Int) { callback(gleam_int.to_string(int)) }
}

pub fn arg_int(previous) -> Fn(a, b) {
  compose(previous, arg_int_formatter)
}

// identity
pub fn identity(s) {
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

fn uncurry2(fun) {
  fn(a, b) { fun(a)(b) }
}

fn uncurry3(fun) {
  fn(a, b, c) { fun(a)(b)(c) }
}

fn uncurry4(fun) {
  fn(a, b, c, d) { fun(a)(b)(c)(d) }
}

fn uncurry5(fun) {
  fn(a, b, c, d, e) { fun(a)(b)(c)(d)(e) }
}

pub fn call0(formatter) {
  fn() { formatter(identity) }
}

pub fn call1(formatter) {
  formatter(identity)
}

pub fn call2(formatter) {
  formatter(identity)
  |> uncurry2
}

pub fn call3(formatter) {
  formatter(identity)
  |> uncurry3
}

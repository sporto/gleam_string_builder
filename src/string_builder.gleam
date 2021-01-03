import gleam/int as gleam_int
import gleam/string
import gleam/function
import gleam/list

type Callback(next_formatter) =
  fn(String) -> next_formatter

type Fn(next_formatter, formatter) =
  fn(Callback(next_formatter)) -> formatter

/// Start a new formatter
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   ...
/// ```
///
pub fn new(callback: Callback(formatter)) -> formatter {
  callback("")
}

/// Format a String
/// To be used in conjunction with compose
pub fn string_formatter(str: String) -> Fn(formatter, formatter) {
  fn(callback: Callback(formatter)) -> formatter { callback(str) }
}

/// Add a string
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.string("Hello ")
/// ```
///
pub fn string(previous: Fn(f1, f2), str: String) -> Fn(f1, f2) {
  compose(previous, string_formatter(str))
}

/// A placeholder for a string
/// To be used in conjunction with compose
pub fn arg_string_formatter(callback: Callback(formatter)) {
  fn(str: String) { callback(str) }
}

/// Add a placeholder for a string
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.arg_string
///   |> ...
/// ```
///
pub fn arg_string(previous) -> Fn(a, b) {
  previous
  |> compose(arg_string_formatter)
}

/// Format an Int
/// To be used in conjunction with compose
pub fn int_formatter(n: Int) -> Fn(formatter, formatter) {
  fn(callback: Callback(formatter)) -> formatter {
    callback(gleam_int.to_string(n))
  }
}

/// Add an Int
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.int(12)
///   |> ...
/// ```
///
pub fn int(previous: Fn(f1, f2), n: Int) -> Fn(f1, f2) {
  compose(previous, int_formatter(n))
}

/// A placeholder for an Int
/// To be used in conjunction with compose
pub fn arg_int_formatter(callback: Callback(formatter)) {
  fn(int: Int) { callback(gleam_int.to_string(int)) }
}

/// Add a placeholder for an Int
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.arg_int
///   |> ...
/// ```
///
pub fn arg_int(previous) -> Fn(a, b) {
  compose(previous, arg_int_formatter)
}

// List of Int
fn format_int_list(l: List(Int)) -> String {
  l
  |> list.map(gleam_int.to_string)
  |> string.join(", ")
}

/// Format a List(Int)
/// To be used in conjunction with compose
pub fn int_list_formatter(l: List(Int)) -> Fn(formatter, formatter) {
  fn(callback: Callback(formatter)) -> formatter {
    l
    |> format_int_list
    |> callback
  }
}

/// Add a List(Int)
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.int_list([1,2,3])
///   |> ...
/// ```
///
pub fn int_list(previous: Fn(f1, f2), l: List(Int)) -> Fn(f1, f2) {
  compose(previous, int_list_formatter(l))
}

/// A placeholder for a List(Int)
/// To be used in conjunction with compose
pub fn arg_int_list_formatter(callback: Callback(formatter)) {
  fn(l: List(Int)) {
    l
    |> format_int_list
    |> callback
  }
}

/// Add a placeholder for a List(Int)
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.arg_int_list
///   |> ...
/// ```
///
pub fn arg_int_list(previous) -> Fn(a, b) {
  compose(previous, arg_int_list_formatter)
}

/// The identity function
/// This is used when calling a formatter using the curried form
pub fn identity(s) {
  s
}

/// Compose formatters
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.string("The current state is ")
///   |> sb.compose(custom_state_formatter)
/// ```
///
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

/// End a formatter with 0 arguments
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.string("Hello")
///   |> sb.end0
/// ```
///
pub fn end0(formatter) {
  fn() { formatter(identity) }
}

/// End a formatter with 1 argument
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.string("Hello ")
///   |> sb.arg_string
///   |> sb.end1
/// ```
///
pub fn end1(formatter) {
  formatter(identity)
}

/// End a formatter with 2 arguments
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.string("Hello ")
///   |> sb.arg_string
///   |> sb.arg_int
///   |> sb.end2
/// ```
///
pub fn end2(formatter) {
  formatter(identity)
  |> uncurry2
}

/// End a formatter with 3 arguments
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.string("Hello ")
///   |> sb.arg_string
///   ...
///   |> sb.end3
/// ```
///
pub fn end3(formatter) {
  formatter(identity)
  |> uncurry3
}

/// End a formatter with 4 arguments
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.string("Hello ")
///   |> sb.arg_string
///   ...
///   |> sb.end4
/// ```
///
pub fn end4(formatter) {
  formatter(identity)
  |> uncurry4
}

/// End a formatter with 5 arguments
///
/// ## Example
///
/// ```
/// let formatter =
///   sb.new
///   |> sb.string("Hello ")
///   |> sb.arg_string
///   ...
///   |> sb.end5
/// ```
///
pub fn end5(formatter) {
  formatter(identity)
  |> uncurry5
}

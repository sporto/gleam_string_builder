# gleam_string_builder

![test](https://github.com/sporto/gleam_string_builder/workflows/test/badge.svg)

A Gleam library for building strings

```rust
let formatter =
  sb.new
  |> sb.string("The winner is ")
  |> sb.arg_string
  |> sb.string(" with ")
  |> sb.arg_int
  |> sb.string(" points!!")
  |> sb.end2

formatter("Sam", 12)
==
"The winner is Sam with 12 points!!"
```

## Custom formatter

A custom formatter is a function that takes a callback and then returns another function that calls that callback with a string.

```rust
fn custom_formatter(callback) {
  fn(state: State) {
    let str = state_to_string(state)
    callback(str)
  }
}
```

Then you can add this custom formatter to a pipeline using `compose`.

```rust
import string_builder as sb

let formatter =
  sb.new
  |> sb.string("The current state is ")
  |> sb.compose(custom_formatter)
  |> sb.string("!")
  |> sb.end1

formatter(Done)
```

## Installation

This package can be installed by adding `gleam_string_builder` to your `rebar.config` dependencies:

```erlang
{deps, [
    gleam_string_builder
]}.
```

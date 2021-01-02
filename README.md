# gleam_string_builder

A Gleam library for building strings

```
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

## Installation

If [available in Hex](https://www.rebar3.org/docs/dependencies#section-declaring-dependencies)
this package can be installed by adding `gleam_string_builder` to your `rebar.config` dependencies:

```erlang
{deps, [
    gleam_string_builder
]}.
```

import gleam_string_builder
import gleam/should

pub fn hello_world_test() {
  gleam_string_builder.hello_world()
  |> should.equal("Hello, from gleam_string_builder!")
}

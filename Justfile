test:
	rebar3 eunit

docs:
	gleam docs build

publish:
	rebar3 hex publish

docs-publish:
	gleam docs publish --version 0.1.0 .
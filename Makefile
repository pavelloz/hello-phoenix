.PHONY: setup build run lint fmt test test.watch db.setup db.create db.migrate db.seed db.drop db.reset repl repl.run repl.test

# Project-wide

setup:
	make build && make db.setup

build:
	mix deps.get && mix compile

run:
	mix phx.server

# Code quality

lint:
	mix credo && mix format --check-formatted

fmt:
	mix format

test:
	mix test

test.watch:
	mix test.watch

# Database

db.setup:
	make db.create && make db.migrate && make db.seed

db.create:
	mix ecto.create

db.migrate:
	mix ecto.migrate

db.seed:
	mix run priv/repo/seeds.exs

db.drop:
	mix ecto.drop

db.reset:
	make db.drop && make db.setup

# REPL

repl:
	iex -S mix

repl.run:
	iex -S mix phx.server

repl.test:
	iex -S mix test.watch
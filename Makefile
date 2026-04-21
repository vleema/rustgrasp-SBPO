# This enables unstables features in the stable compiler.
export RUSTC_BOOTSTRAP=1

all: build

run: build ## Runs a given algorithm with a given instance and params, e.g. `make run-instance INSTANCE=1 ALGO=transgenetic PARAMS="100 50 42"`
	cargo br --bin $(ALGO)
	cargo rr --bin $(ALGO) -- $(PARAMS)

build: ## Builds a given algorithm with release mode and a given instance, e.g. `make build ALGO=genetic INSTANCE=001`
	sed -i "s|\(graph_from_csv!(\"\)[^\"]*\(\")\)|\1data/$(INSTANCE)/data.csv\2|" src/bin/$(ALGO).rs
	cargo br --bin $(ALGO)

build-test: ## Builds the cargo project
	cargo br

check: ## Performs a cargo check with release mode
	cargo cr

clean: ## Cleans the generated artifact
	rm -r bins/* && cargo clean

clippy: ## Runs clippy
	unset RUSTC_BOOTSTRAP && cargo clippy --workspace -- -D warnings
	unset RUSTC_BOOTSTRAP && cargo clippy --tests --workspace -- -D warnings

test: ## Runs all tests
	unset RUSTC_BOOTSTRAP && cargo tr --all

fmt: ## Formats the code
	cargo fmt

fmt_check: ## Check if the code is formatted
	cargo fmt -- --check

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'


.PHONY: all build check example clean clippy test run fmt fmt_check help

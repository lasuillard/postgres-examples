#!/usr/bin/env -S make -f

MAKEFLAGS += --warn-undefined-variable
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help

help: Makefile  ## Show help
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


# =============================================================================
# Common
# =============================================================================
install:  ## Install deps
	uv python install
	uv sync --frozen --all-packages --all-extras
	pre-commit install --install-hooks
	cp -n .vscode/mcp.json.example .vscode/mcp.json
.PHONY: install

update:  ## Update deps and tools
	uv sync --upgrade --all-extras
	pre-commit autoupdate
.PHONY: update


# =============================================================================
# CI
# =============================================================================
ci: lint  ## Run CI tasks
.PHONY: ci

format:  ## Run autoformatters
	uv run --frozen ruff check --fix .
	uv run --frozen ruff format .
.PHONY: format

lint:  ## Run all linters
	uv run --frozen ruff check .
	uv run --frozen mypy --show-error-codes --pretty .
.PHONY: lint


# =============================================================================
# Handy Scripts
# =============================================================================
clean:  ## Remove temporary files
	rm -rf .mypy_cache/ .pytest_cache/ .ruff-cache/ htmlcov/ .coverage coverage.xml report.xml
	find . -path '*/__pycache__*' -delete
	find . -path "*.log*" -delete
.PHONY: clean

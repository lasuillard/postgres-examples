#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y \
    postgresql-client

# Dev tools
pipx install pre-commit shfmt-py

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

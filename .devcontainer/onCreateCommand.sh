#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y \
    postgresql-client

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

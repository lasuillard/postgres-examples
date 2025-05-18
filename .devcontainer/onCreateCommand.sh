#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y \
    postgresql-client

# Dev tools
pipx install pre-commit shfmt-py

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Postgres LSP (postgrestools VS Code extension)
ARCH="$(uname -m)"
case "$ARCH" in
x86_64)
    ARCH="x86_64"
    ;;
arm64)
    ARCH="aarch64"
    ;;
*)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac
POSTGRESTOOLS_VERSION='0.6.1'

sudo curl -fsSL --output /usr/bin/postgrestools "https://github.com/supabase-community/postgres-language-server/releases/download/${POSTGRESTOOLS_VERSION}/postgrestools_${ARCH}-unknown-linux-gnu" &&
    sudo chmod +x /usr/bin/postgrestools

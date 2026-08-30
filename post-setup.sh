#!/usr/bin/env bash
set -euo pipefail

VENV="${HOME}/DGY"

if [[ ! -x "${VENV}/bin/python" ]]; then
  echo "Creating ${VENV} with Python 3.12..."
  uv venv "${VENV}" --python python3.12
else
  echo "${VENV} already exists; keeping it."
fi

echo "Installing Python packages into ${VENV}..."
uv pip install --python "${VENV}/bin/python" \
  pynvim \
  pre-commit \
  mypy \
  types-setuptools \
  pyupgrade \
  docformatter \
  darglint \
  typos==1.19.0 \
  types-dataclasses==0.1.7

if ! uv tool list | grep -q '^ty\b'; then
  echo "Installing ty as a uv tool..."
  uv tool install ty
  uv tool install ruff
  uv tool install --upgrade 'cocoindex-code[full]'
else
  echo "ty is already installed; keeping it."
fi

echo "Installing Midnight Captain..."
curl -fsSL https://raw.githubusercontent.com/duguyue100/midnight-captain/main/install.sh | bash

echo "Post-setup complete."

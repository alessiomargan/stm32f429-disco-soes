#!/bin/bash
set -e

echo "===== Setting up git submodules ====="

# Initialize and update submodules
git submodule update --init --recursive

# Checkout tracking branches
cd external/soes
git checkout main_advr
echo "SOES: $(git branch --show-current) at $(git rev-parse --short HEAD)"

cd ../uc_test
git checkout soes_main
echo "uc_test: $(git branch --show-current) at $(git rev-parse --short HEAD)"

cd ../..

# Configure git safe directories
git config --global --add safe.directory /workspace/stm32f429-disco-soes
git config --global --add safe.directory /workspace/stm32f429-disco-soes/external/soes
git config --global --add safe.directory /workspace/stm32f429-disco-soes/external/uc_test

echo "===== Submodules setup complete ====="

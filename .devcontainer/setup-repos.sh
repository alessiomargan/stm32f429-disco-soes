#!/bin/bash
set -e

echo "===== Setting up workspace repositories ====="

# Clone or update SOES
if [ ! -d "/workspace/SOES" ]; then
    echo "Cloning SOES repository..."
    git clone --branch main_advr https://github.com/Advanced-Robotics-Facility/SOES.git /workspace/SOES
else
    echo "SOES already exists, pulling latest..."
    cd /workspace/SOES
    git pull
fi

# Clone or update uc_test (adjust URL if different)
if [ ! -d "/workspace/uc_test" ]; then
    echo "Cloning uc_test repository..."
    git clone --branch soes_main https://github.com/alessiomargan/uc-test.git /workspace/uc_test
else
    echo "uc_test already exists, pulling latest..."
    cd /workspace/uc_test
    git pull
fi

# Clone or update main project
if [ ! -d "/workspace/stm32f429-disco-soes" ]; then
    echo "Cloning stm32f429-disco-soes repository..."
    git clone https://github.com/alessiomargan/stm32f429-disco-soes.git /workspace/stm32f429-disco-soes
else
    echo "stm32f429-disco-soes already exists"
fi

# Configure git safe directories
git config --global --add safe.directory /workspace/stm32f429-disco-soes
git config --global --add safe.directory /workspace/SOES
git config --global --add safe.directory /workspace/uc_test

echo "===== Workspace setup complete ====="

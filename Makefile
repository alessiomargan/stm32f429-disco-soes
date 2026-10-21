# Simple Makefile for building and flashing STM32F429 project

# Configuration
BUILD_DIR := build/Debug
ELF := $(BUILD_DIR)/stm32f429-disco-soes.elf
BIN := $(BUILD_DIR)/stm32f429-disco-soes.bin
DEPLOY_HOST ?= embedded@rpi4
REMOTE_FIRMWARE_DIR ?= /home/embedded/.ecat_master/firmware

# Default target
.PHONY: all
all: build

# Configure + Build (Debug preset)
.PHONY: configure build
configure:
	cmake --preset Debug

build: configure
	cmake --build $(BUILD_DIR) --clean-first -- -v

# CMake's post-build step generates the .bin from the ELF.
.PHONY: bin
bin: build
	@test -f "$(BIN)"

# Copy the application to the Raspberry Pi using SSH/SCP.
.PHONY: deploy_ssh
deploy_ssh: bin
	ssh "$(DEPLOY_HOST)" 'mkdir -p "$(REMOTE_FIRMWARE_DIR)"'
	scp "$(BIN)" "$(DEPLOY_HOST):$(REMOTE_FIRMWARE_DIR)/st_et1100.bin"
	ssh "$(DEPLOY_HOST)" 'sha256sum "$(REMOTE_FIRMWARE_DIR)/st_et1100.bin"'

# Flash via stlink-tools (st-flash)
.PHONY: flash
flash: bin
	# st-flash write $(BIN) 0x08000000
	st-flash write $(BIN) 0x08020000

# Flash via OpenOCD (uses ELF; requires openocd in PATH)
.PHONY: flash-openocd
flash-openocd: build
	openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
		-c "program $(ELF) verify reset exit"

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf build

# Size report
.PHONY: size
size: build
	arm-none-eabi-size $(ELF)

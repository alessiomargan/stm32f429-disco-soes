# Simple Makefile for building and flashing STM32F429 project

# Configuration
BUILD_DIR := build/Debug
ELF := $(BUILD_DIR)/stm32f429-disco-soes.elf
BIN := $(BUILD_DIR)/stm32f429-disco-soes.bin

# Default target
.PHONY: all
all: build

# Configure + Build (Debug preset)
.PHONY: configure build
configure:
	cmake --preset Debug

build: configure
	cmake --build $(BUILD_DIR)

# Generate .bin from ELF (optional; objcopy already runs post-build, but kept for convenience)
.PHONY: bin
bin: $(BIN)

$(BIN): $(ELF)
	arm-none-eabi-objcopy -O binary $(ELF) $(BIN)

# Flash via stlink-tools (st-flash)
.PHONY: flash
flash: $(BIN)
	st-flash write $(BIN) 0x08000000

# Flash via OpenOCD (uses ELF; requires openocd in PATH)
.PHONY: flash-openocd
flash-openocd: $(ELF)
	openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
		-c "program $(ELF) verify reset exit"

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf build

# Size report
.PHONY: size
size: $(ELF)
	arm-none-eabi-size $(ELF)

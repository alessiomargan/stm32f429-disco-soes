# STM32F429 SOES Development Container

This devcontainer provides a complete, reproducible development environment for the STM32F429-disco-soes project.

## What's Included

- Ubuntu 24.04 LTS base
- ARM GNU Toolchain 13.3.rel1 (arm-none-eabi-gcc)
- CMake & Ninja build system
- Git
- Clangd language server
- All required VS Code extensions (STM32, C/C++, CMake Tools, clangd)

## Usage

### First Time Setup

1. Install Docker Desktop (or Docker Engine + Docker Compose)
2. Install VS Code extension: "Dev Containers" (ms-vscode-remote.remote-containers)
3. Open this project folder in VS Code
4. When prompted, click "Reopen in Container" (or use Command Palette: `Dev Containers: Reopen in Container`)

### Building the Project

Inside the container:

```bash
# Configure the build
cmake --preset Debug

# Build
cmake --build build/Debug

# Or use the VS Code CMake Tools extension
```

### Multi-Root Workspace

The devcontainer automatically mounts all required workspace folders:
- `/workspace/stm32f429-disco-soes` (main project)
- `/workspace/uc_test` (test sources)
- `/workspace/SOES` (SOES library)

### Environment Variables

- `GIT_SOES=/workspace/SOES`
- `GIT_UC_TEST=/workspace/uc_test`

These are automatically set and match the paths expected by cmake/soes.cmake

## Troubleshooting

### Permission Issues

If you encounter permission issues with git, the postCreateCommand should fix them automatically. If not, run:

```bash
git config --global --add safe.directory /workspace/stm32f429-disco-soes
```

### Rebuild Container

If you modify the Dockerfile, rebuild the container:
- Command Palette: `Dev Containers: Rebuild Container`

### ARM Toolchain Not Found

The ARM toolchain is installed at: `/opt/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi/bin`

Verify with:
```bash
arm-none-eabi-gcc --version
```

## Benefits

✅ Consistent build environment across all developers
✅ No local toolchain installation required
✅ Reproducible builds
✅ CI/CD ready (same Docker image can be used in pipelines)
✅ Full IntelliSense support with clangd

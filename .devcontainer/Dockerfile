FROM ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    wget \
    xz-utils \
    curl \
    ca-certificates \
    bash \
    python3 \
    python3-pip \
    sudo \
    clangd \
    && rm -rf /var/lib/apt/lists/*

# Install ARM GNU Toolchain (matching your version as close as possible)
RUN wget -q https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/binrel/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz \
    && tar xf arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz -C /opt \
    && rm arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi.tar.xz

# Add ARM toolchain to PATH
ENV PATH="/opt/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi/bin:${PATH}"

# Create a non-root user (vscode is the standard name for devcontainers). Allow reuse of an existing GID.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN if id -u $USERNAME >/dev/null 2>&1; then \
        echo "User $USERNAME already exists"; \
    else \
        EXISTING_USER=$(getent passwd $USER_UID | cut -d: -f1 || true); \
        EXISTING_GROUP=$(getent group $USER_GID | cut -d: -f1 || true); \
        if [ -z "$EXISTING_GROUP" ]; then \
            groupadd --gid $USER_GID $USERNAME; \
        fi; \
        if [ -n "$EXISTING_USER" ]; then \
            usermod -l $USERNAME -d /home/$USERNAME -m $EXISTING_USER; \
            usermod -g $USER_GID $USERNAME; \
        else \
            useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; \
        fi; \
    fi \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user
USER $USERNAME

# Set working directory
WORKDIR /workspace

# stm32f429-disco-soes
vscode project for  stm32f429-disco board

## SSH deployment

```sh
make deploy_ssh
```

`make deploy_ssh` copies the binary to the Raspberry Pi:

```text
embedded@rpi4:/home/embedded/.ecat_master/firmware/st_et1100.bin
```

The remote directory must be writable by `embedded`. The target creates it if
needed, copies the binary using SCP, and prints the remote file's SHA-256
checksum. SSH authentication must be configured; sudo is not required.
Override the SSH host or remote directory with:

```sh
make deploy_ssh DEPLOY_HOST=embedded@rpi4 \
    REMOTE_FIRMWARE_DIR=/home/embedded/.ecat_master/firmware
```

The target builds the Debug binary before copying it. It does not initiate
a FoE transfer or flash the microcontroller.

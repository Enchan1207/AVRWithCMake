# AVRWithCMake

## Overview

CMakeでAVR開発したい

## Initial set up

The following methods are available:

 - [local environment](#local-environment)
 - [docker-compose](#docker-compose)

### local environment

1. Install arduino-cli ([official instruction](https://arduino.github.io/arduino-cli/0.29/installation/))
2. `arduino-cli core install arduino:avr` to install AVR microcontroller components
3. `mkdir -p app/build; cd app/build`

### docker-compose

1. `docker-compose build`
2. `docker-compose up -d`
3. `docker-compose exec cmake_avr zsh`

## Build

### only build

```shell
$ cmake .. -GNinja
$ ninja
```

### build & flash

```shell
$ cmake .. -GNinja -DAVRDUDE_PORT=/dev/path/to/serial_port
$ ninja flash-main
```

## License

This repository is published under [MIT License](LICENSE).

# AVRWithCMake

## Overview

CMakeでAVR開発したい

## Usage

The following methods are available:

 - [local environment](#local-environment)
 - [docker-compose](#docker-compose)

### local environment

1. Install arduino-cli ([official instruction](https://arduino.github.io/arduino-cli/0.29/installation/))
2. `arduino-cli core install arduino:avr` to install AVR microcontroller components
3. `mkdir -p app/build; cd app/build; cmake .. && make`

### docker-compose

1. `docker-compose build`
2. `docker-compose up -d`
3. `docker-compose exec cmake_avr zsh`
4. `cmake .. && make`


## License

This repository is published under [MIT License](LICENSE).

#
# CMakeを用いたAVRマイコンの開発環境をdocker上で構築する
#
FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

##
## ベース構成
##

ENV PATH /usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# パッケージマネージャの更新
RUN apt-get update && apt-get -y upgrade

# ロケール設定
ARG lang="ja_JP.UTF8"
RUN apt-get -y install tzdata
RUN update-locale LANG=${lang}; dpkg-reconfigure tzdata
ENV LANG ${lang}

# 必要なパッケージ・プログラムのインストール
RUN apt-get -y install build-essential zsh curl sudo wget
RUN apt-get -y install cmake-curses-gui ninja-build
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/usr/local/bin sh

# ユーザ追加
ARG username="avr"
ARG password="password"
RUN useradd ${username} -m -s `which zsh`; usermod -aG sudo ${username}
RUN echo "${username}:${password}" | chpasswd

# 以下ユーザ空間で実行
USER ${username}

# シェル設定
ENV PS1 "%n@%m %1~ %# "
ENV CMAKE_GENERATOR "Ninja"
ENV CMAKE_MAKE_PROGRAM "`which ninja`"
RUN touch ~/.zshrc ~/.zshenv

##
## Arduino-cli
##
RUN arduino-cli core install arduino:avr

WORKDIR /app/build
CMD zsh

#!/usr/bin/env bash

case $option in
    mac_install)
        # Check if the platform is macOS
        if [[ $(uname) != "Darwin" ]]; then
            echo "🧚 This script is only available on macOS."
            exit 1
        fi

        # If homebrew is not install, exit
        if ! command -v brew &> /dev/null; then
            echo "🧚 Homebrew is not installed. Please run the install script."
            exit 1
        fi

        brew install \
            automake bison cmake ffmpeg gcc git libuv neovim pdf2htmlex tmux wget \
            zeromq ripgrep lazygit htop midnight-commander clang-format ruby lsd \
            zoxide shellcheck node cairo pango fd bottom\
            texlive latexit

        npm install --global yarn
        ;;

    esac

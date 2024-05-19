#!/usr/bin/env bash

case $option in
    homebrew)
        # Check if homebrew is installed
        if command -v brew &> /dev/null; then
            echo "🧚 Homebrew is already installed."
            exit 0
        fi

        # Check if the platform is macOS
        if [[ $(uname) != "Darwin" ]]; then
            echo "🧚 Homebrew is only available on macOS."
            exit 1
        fi

        echo "🧚 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ;;

    mac_essentials)
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
            automake bison cmake ffmpeg gcc git libuv neovim tmux wget \
            zeromq ripgrep lazygit midnight-commander clang-format ruby lsd \
            zoxide shellcheck node cairo pango fd bottom md5sha1sum jless fzf

        npm install --global yarn

        # Install my macman
        git clone https://github.com/duguyue100/macman "${HOME}"/macman
        ;;

    mactex)
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

        brew instal texlive latexit

    esac

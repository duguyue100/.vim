#!/usr/bin/env bash

case $option in
    install_homebrew)
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

    esac

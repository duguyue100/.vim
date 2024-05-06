#!/usr/bin/env bash

case $option in
    ubuntu_essentials)
        # Check if the platform is ubuntu
        if [[ $(uname) != "Linux" ]]; then
            echo "🧚 This script is only available on Ubuntu."
            exit 1
        fi

        # Update and upgrade
        sudo apt update
        sudo apt upgrade -y
        sudo apt-add-repository -y ppa:git-core/ppa
        sudo apt update

        # Install essential packages
        sudo apt install -y \
            build-essential binutils cmake curl tmux unzip openssh-server xclip zsh \
            ripgrep mc terminator clang-format ruby-full curl zoxide git
        ;;

        # if conda is installed, install lazygit
        if command -v conda &> /dev/null; then
            conda install -c conda-forge lazygit
        fi

    nvidia_driver)
        # Check if the platform is ubuntu
        if [[ $(uname) != "Linux" ]]; then
            echo "🧚 This script is only available on Ubuntu."
            exit 1
        fi

        sudo add-apt-repository -y ppa:graphics-drivers/ppa
        sudo apt update

        echo "🧚 Run the following command to install available driver:"
        echo "🧚 sudo apt install nvidia-driver-<version>"
        echo "🧚 sudo apt install nvidia-modprobe"
        ;;
    esac

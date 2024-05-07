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

        # if conda is installed, install lazygit
        if command -v conda &> /dev/null; then
            conda install -c conda-forge lazygit
        fi

        # Install my linuxman
        git clone https://github.com/duguyue100/linuxman "${HOME}"/linuxman

        # Install bottom
        curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
        sudo dpkg -i bottom_0.9.6_amd64.deb

        # Install lsd
        curl -LO https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd_1.1.2_amd64.deb
        sudo dpkg -i lsd_1.1.2_amd64.deb

        # Install jless for JSON and YAML files
        wget https://github.com/PaulJuliusMartinez/jless/releases/download/v0.9.0/jless-v0.9.0-x86_64-unknown-linux-gnu.zip -O jless.zip
        # Unzip the file
        unzip jless.zip
        mv jless "${HOME}"/bin
        rm jless.zip
        ;;

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

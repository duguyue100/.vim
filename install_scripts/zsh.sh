#!/usr/bin/env bash

case $option in
    switch_to_zsh)
        # Check if the shell is already zsh
        if [[ $SHELL == "/bin/zsh" ]]; then
            echo "🧚 Zsh is already the default shell."
            exit 0
        fi

        # Check if zsh is installed
        if ! command -v zsh &> /dev/null; then
            echo "🧚 Zsh is not installed. Please install zsh."
            exit 1
        fi

        # Change the default shell to zsh
        chsh -s "$(which zsh)"
        ;;

    omz)
        # Check if oh-my-zsh is installed
        if [[ -d "$HOME/.oh-my-zsh" ]]; then
            echo "🧚 Oh-my-zsh is already installed."
            exit 0
        fi

        # Install oh-my-zsh
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

        # If it's linux, use zshrc_linux, otherwise use zshrc_mac
        if [[ $(uname) != "Darwin" ]]; then
            ln -s ~/.vim/zshrc_linux ~/.zshrc
            ln -s ~/.vim/p10k_linux ~/.p10k.zsh
        else
            ln -s ~/.vim/zshrc_mac ~/.zshrc
            ln -s ~/.vim/p10k_mac ~/.p10k.zsh
        fi

        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
        git clone https://github.com/jeffreytse/zsh-vi-mode \
            "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-vi-mode
        git clone https://github.com/zsh-users/zsh-history-substring-search \
            "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-history-substring-search
        ;;
    esac

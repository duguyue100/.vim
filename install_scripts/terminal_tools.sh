#!/usr/bin/env bash

case $option in
    install_neovim)
        # Check if neovim is installed
        if command -v nvim &> /dev/null; then
            echo "🧚 Neovim is already installed."
            exit 0
        fi

        # Check if the platform is macOS
        if [[ $(uname) == "Darwin" ]]; then
            brew install neovim
        elif [[ $(uname) == "Linux" ]]; then
            mkdir -p "${HOME}"/bin
            cd "${HOME}"/bin || exit
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
            chmod u+x nvim.appimage
            mv nvim.appimage nvim
            ln -s ~/.vim ~/.config/nvim
        fi
        ;;

    terminal_config)
        # Darglint docstring linter support:
        ln -s ~/.vim/.darglint ~/.darglint

        # tmux config
        ln -s ~/.vim/tmux.conf ~/.tmux.conf
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

        # Install Powerline
        pip install powerline-status
        git clone https://github.com/powerline/fonts.git --depth=1
        cd fonts || exit
        ./install.sh
        cd ..
        rm -rf fonts

        # Install tmux plugins
        ~/.tmux/plugins/tpm/bin/install_plugins
        ;;
    esac

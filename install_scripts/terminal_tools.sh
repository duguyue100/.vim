#!/usr/bin/env bash

case $option in
    neovim)
        # Check if neovim is installed
        if command -v nvim &> /dev/null; then
            echo "🧚 Neovim is already installed."
            exit 0
        fi

        # Check if the platform is macOS
        if [[ $(uname) == "Darwin" ]]; then
            brew install neovim
        else
            mkdir -p "${HOME}"/bin
            cd "${HOME}"/bin || exit
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
            chmod u+x nvim.appimage
            mv nvim.appimage nvim
            ln -s "${HOME}"/.vim "${HOME}"/.config/nvim
        fi
        ;;

    terminal_config)
        # Darglint docstring linter support:
        ln -s "${HOME}"/.vim/.darglint "${HOME}"/.darglint

        # tmux config
        ln -s "${HOME}"/.vim/tmux.conf "${HOME}"/.tmux.conf
        git clone https://github.com/tmux-plugins/tpm "${HOME}"/.tmux/plugins/tpm

        # Install Powerline
        pip install powerline-status
        git clone https://github.com/powerline/fonts.git --depth=1
        cd fonts || exit
        ./install.sh
        cd ..
        rm -rf fonts

        # Install tmux plugins
        "${HOME}"/.tmux/plugins/tpm/bin/install_plugins
        ;;
    esac

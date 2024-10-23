# Ubuntu

# macOS

1. Setup Git config and go to the home directory
    ```bash
    git config --global user.name ""
    git config --global user.email ""
    cd
    ```

2. Clone the following repos
    ```bash
    git clone https://github.com/duguyue100/.vim.git
    git clone https://github.com/duguyue100/macman "${HOME}"/macman
    ```

3. Setup ZSH

    - Install Oh-my-zsh
        ```bash
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        ```

    - Link profile
        ```bash
        # Remove the default .zshrc if there is any
        rm "${HOME}"/.zshrc

        # Setup symlink
        ln -s "${HOME}"/.vim/zshrc_mac "${HOME}"/.zshrc
        ln -s "${HOME}"/.vim/p10k_mac "${HOME}"/.p10k.zsh
        ```

    - Install plugins
        ```bash
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
        git clone https://github.com/jeffreytse/zsh-vi-mode \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-vi-mode
        git clone https://github.com/zsh-users/zsh-history-substring-search \
            "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-history-substring-search
        ```

    - Restart the terminal, you will notice that the font and `conda` are not there yet.

4. Install miniconda
    ```bash
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -O "${HOME}"/miniconda.sh
    bash "${HOME}"/miniconda.sh -b -p "${HOME}"/miniconda3
    rm "${HOME}"/miniconda.sh
    ```

    Create an environment right after (choose your environment's name)
    ```bash
    conda create -n latticeflow python=3.10
    ```

    Restart the terminal.

5. Configure the fonts
    ```bash
    pip install powerline-status

    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
    ```

3. Run the following command sequentially
    ```bash
    # Darglint docstring linter support
    ln -s "${HOME}"/.vim/.darglint "${HOME}"/.darglint

    # tmux config
    ln -s "${HOME}"/.vim/tmux.conf "${HOME}"/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm "${HOME}"/.tmux/plugins/tpm
    ```

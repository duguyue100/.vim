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

4. Install Python

3. Run the following command sequentially
    ```bash
    # Darglint docstring linter support
    ln -s "${HOME}"/.vim/.darglint "${HOME}"/.darglint

    # tmux config
    ln -s "${HOME}"/.vim/tmux.conf "${HOME}"/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm "${HOME}"/.tmux/plugins/tpm
    ```

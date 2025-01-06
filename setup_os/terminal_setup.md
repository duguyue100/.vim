# Ubuntu Terminal Setup

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

    - Switch to ZSH
        ```bash
        chsh -s $(which zsh)
        ```
        Restart the terminal. When ZSH setup guide is prompted, choose 0 to quit.

    - Install Oh-my-zsh
        ```bash
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        ```

    - Link profile
        ```bash
        # Remove the default .zshrc if there is any
        rm "${HOME}"/.zshrc

        # Setup symlink
        ln -s "${HOME}"/.vim/zshrc_linux "${HOME}"/.zshrc
        ln -s "${HOME}"/.vim/p10k_linux "${HOME}"/.p10k.zsh
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
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "${HOME}"/miniconda.sh
    bash "${HOME}"/miniconda.sh -b -p "${HOME}"/miniconda3
    rm "${HOME}"/miniconda.sh
    ```

    Create an environment right after (choose your environment's name)
    ```bash
    conda create -n lf-work python=3.10
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

6. Configure Terminator
    - Follow the instructions in
        [`terminator-themes`](https://github.com/EliverLara/terminator-themes),
        you will need to close and restart the terminal to see `TerminatorThemes`
        option under `plugins`.
    - Right-click on the terminal and choose `Themes` -> `tokyonight (dark)` -> `Install`.
    - Go to `Preferences` -> `Layouts` -> choose `tokyonight` as the default layout.
    - Additionally, go to `Preferences` -> `Global` -> check "Re-use profiles for new terminals".
    - Go to `Preferences` -> `Profiles` -> `tokyonight` -> `General` -> uncheck `Show titlebar`.
    - Keybindings
        - Disable `cycle_next` and `cycle_prev`
        - Change `new_tab` to `Ctrl+T`
        - Change `next_tab` to `Ctrl+Tab`
        - Change `prev_tab` to `Ctrl+Shift+Tab`

7. Run the following command sequentially
    ```bash
    # Darglint docstring linter support
    ln -s "${HOME}"/.vim/.darglint "${HOME}"/.darglint

    # tmux config
    ln -s "${HOME}"/.vim/tmux.conf "${HOME}"/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm "${HOME}"/.tmux/plugins/tpm

    # install tmux plugins
    "${HOME}"/.tmux/plugins/tpm/bin/install_plugins

    # For NPM
    nvm install 20
    nvm use 20
    npm install --global yarn
    ```

Restart the terminal, at this point, you should have a beautiful terminal setup.
Now, you can proceed to install the [Python packages](./python.md).

# macOS Terminal Setup

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

3. Apply Ghostty config
    ```bash
    mkdir -p "${HOME}"/.config/ghostty
    ln -s "${HOME}"/.vim/ghostty-config "${HOME}"/.config/ghostty/config
    ```

4. Setup ZSH

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

5. Install miniconda
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

6. Configure the fonts (Do I still need this if I have Ghostty?)
    ```bash
    pip install powerline-status

    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
    ```

7. Run the following command sequentially
    ```bash
    # Darglint docstring linter support
    ln -s "${HOME}"/.vim/.darglint "${HOME}"/.darglint

    # tmux config
    ln -s "${HOME}"/.vim/tmux.conf "${HOME}"/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm "${HOME}"/.tmux/plugins/tpm

    # install tmux plugins
    "${HOME}"/.tmux/plugins/tpm/bin/install_plugins

    # For NPM
    npm install --global yarn
    ```

Restart the terminal, at this point, you should have a beautiful terminal setup.
Now, you can proceed to install the [Python packages](./python.md).

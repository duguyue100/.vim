# Ubuntu Terminal Setup

1. Setup Git config and go to the home directory
    ```bash
    git config --global user.name ""
    git config --global user.email ""
    cd
    ```

2. Clone the following repo
    ```bash
    git clone https://github.com/duguyue100/.vim.git
    ```

3. Apply Ghostty config
    ```bash
    mkdir -p "${HOME}"/.config/ghostty
    ln -s "${HOME}"/.vim/ghostty-config "${HOME}"/.config/ghostty/config
    ```

4. Install miniconda
    ```bash
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "${HOME}"/miniconda.sh
    bash "${HOME}"/miniconda.sh -b -p "${HOME}"/miniconda3
    rm "${HOME}"/miniconda.sh
    ```

    Create an environment right after (choose your environment's name)
    ```bash
    conda create -n env_name python=3.10
    ```

5. Setup Fish
    - Configure Fish
      ```bash
      mkdir -p "${HOME}"/.config/fish
      rm "${HOME}"/.config/fish/config.fish  # remove fish config if it exists
      ln -s "${HOME}"/.vim/config.fish "${HOME}"/.config/fish/config.fish
      ln -s "${HOME}"/.vim/starship.toml "${HOME}"/.config/starship.toml
      cd "${HOME}"/.vim
      cp conda.fish.template conda.fish
      ```
      Modify `conda.fish` to your environment name, e.g., `env_name`.

    - Switch to Fish
        ```bash
        chsh -s $(which fish)
        ```
        You might need to log out and log back in for this to take effect.

6. Run the following command sequentially
    ```bash
    # Darglint docstring linter support
    ln -s "${HOME}"/.vim/.darglint "${HOME}"/.darglint

    # tmux config
    ln -s "${HOME}"/.vim/tmux.conf "${HOME}"/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm "${HOME}"/.tmux/plugins/tpm

    # install tmux plugins
    "${HOME}"/.tmux/plugins/tpm/bin/install_plugins

    # For midnight commander
    mkdir -p "${HOME}"/.config/mc
    rm "${HOME}"/.config/mc/mc.keymap  # remove mc keymap if it exists
    ln -s "${HOME}"/.vim/mc.keymap "${HOME}"/.config/mc/mc.keymap

    # For NPM
    fnm install 20
    fnm use 20
    fnm install --global yarn
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
    ```

3. Apply Ghostty config
    ```bash
    mkdir -p "${HOME}"/.config/ghostty
    ln -s "${HOME}"/.vim/ghostty-config "${HOME}"/.config/ghostty/config
    ```

4. Install miniconda
    ```bash
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "${HOME}"/miniconda.sh
    bash "${HOME}"/miniconda.sh -b -p "${HOME}"/miniconda3
    rm "${HOME}"/miniconda.sh
    ```

    Create an environment right after (choose your environment's name)
    ```bash
    conda create -n env_name python=3.10
    ```

5. Setup Fish
    - Configure Fish
      ```bash
      mkdir -p "${HOME}"/.config/fish
      rm "${HOME}"/.config/fish/config.fish  # remove fish config if it exists
      ln -s "${HOME}"/.vim/config.fish "${HOME}"/.config/fish/config.fish
      ln -s "${HOME}"/.vim/starship.toml "${HOME}"/.config/starship.toml
      cd "${HOME}"/.vim
      cp conda.fish.template conda.fish
      ```
      Modify `conda.fish` to your environment name, e.g., `env_name`.

    - Switch to Fish
        ```bash
        chsh -s $(which fish)
        ```
        You might need to log out and log back in for this to take effect.

7. Run the following command sequentially
    ```bash
    # Darglint docstring linter support
    ln -s "${HOME}"/.vim/.darglint "${HOME}"/.darglint

    # tmux config
    ln -s "${HOME}"/.vim/tmux.conf "${HOME}"/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm "${HOME}"/.tmux/plugins/tpm

    # install tmux plugins
    "${HOME}"/.tmux/plugins/tpm/bin/install_plugins

    # For midnight commander
    mkdir -p "${HOME}"/.config/mc
    rm "${HOME}"/.config/mc/mc.keymap  # remove mc keymap if it exists
    ln -s "${HOME}"/.vim/mc.keymap "${HOME}"/.config/mc/mc.keymap

    # For NPM
    npm install --global yarn
    ```

Restart the terminal, at this point, you should have a beautiful terminal setup.
Now, you can proceed to install the [Python packages](./python.md).

# Ubuntu

1. Update and upgrade
    ```bash
    sudo apt-add-repository -y ppa:git-core/ppa
    sudo apt update && sudo apt upgrade -y
    ```
    If you have NVIDIA GPUs, also add this
    ```bash
    sudo apt-add-repository -y ppa:git-core/ppa
    sudo apt update
    ```

2. Install essential packages
    ```bash
    sudo apt install -y \
        build-essential binutils cmake curl tmux unzip openssh-server xclip zsh \
        ripgrep mc terminator clang-format ruby-full curl zoxide git
    ```

3. Install `bottom`. If you want, please check the latest version
   [here](https://github.com/ClementTsang/bottom/releases/latest).
    ```bash
    curl -LO https://github.com/ClementTsang/bottom/releases/download/0.10.2/bottom_0.10.2-1_amd64.deb
    sudo dpkg -i bottom_0.10.2-1_amd64.deb
    rm bottom_0.10.2-1_amd64.deb
    ```

4. Install `lsd`. If you want, please check the latest version [here](https://github.com/lsd-rs/lsd/releases/latest).
    ```bash
    curl -LO https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd_1.1.5_amd64.deb
    sudo dpkg -i lsd_1.1.5_amd64.deb
    rm lsd_1.1.5_amd64.deb
    ```

5. NVIDIA Driver. Tips: you can hit `Tab` to see the available versions, install a more recent version.
    ```bash
    sudo apt install nvidia-driver-<version>
    sudo apt install nvidia-modprobe
    ```

# macOS

1. (Optional) Download Chrome using Safari and install it. Set chrome as the default
    browser, and sign in to your Google account.

2. Install iTerm2 from [here](https://iterm2.com/downloads.html). Decompress the ZIP
    file and move the app to the Applications folder. From now on, use iTerm2 instead of
    the default Terminal app.


3. Install Homebrew
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

4. Install essential packages
    ```bash
    brew install \
        automake bison cmake ffmpeg gcc git libuv neovim tmux wget \
        zeromq ripgrep lazygit midnight-commander clang-format ruby lsd \
        zoxide shellcheck node cairo pango fd bottom md5sha1sum jless fzf
    ```

    ```bash
    npm install --global yarn
    ```

5. If you need LaTeX.
    ```bash
    brew install texlive latexit
    ```


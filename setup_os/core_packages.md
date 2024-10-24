# Ubuntu

1. (Optional) Download Chrome using Firefox and install it. Set chrome as the default
    browser, and sign in to your Google account. After downloading the installer:
    ```bash
    cd Downloads
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    ```

2. Update and upgrade
    ```bash
    sudo apt-add-repository -y ppa:git-core/ppa
    sudo apt update && sudo apt upgrade -y
    # Restart the machine
    sudo reboot
    ```
    If you have NVIDIA GPUs, also add this
    ```bash
    sudo apt-add-repository -y ppa:git-core/ppa
    sudo apt update
    ```

3. Install essential packages
    ```bash
    sudo apt install -y \
        build-essential binutils cmake curl tmux unzip openssh-server xclip zsh \
        ripgrep mc terminator clang-format ruby-full curl zoxide git vlc libfuse2 \
        plocate
    ```

3. Install `bottom`. If you want, please check the latest version
   [here](https://github.com/ClementTsang/bottom/releases/latest).
    ```bash
    wget https://github.com/ClementTsang/bottom/releases/download/0.10.2/bottom_0.10.2-1_amd64.deb
    sudo dpkg -i bottom_0.10.2-1_amd64.deb
    rm bottom_0.10.2-1_amd64.deb
    ```

4. Install `lsd`. If you want, please check the latest version [here](https://github.com/lsd-rs/lsd/releases/latest).
    ```bash
    wget https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd_1.1.5_amd64.deb
    sudo dpkg -i lsd_1.1.5_amd64.deb
    rm lsd_1.1.5_amd64.deb
    ```

5. Install `fd`
    ```bash
    wget https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-musl_10.2.0_amd64.deb
    sudo dpkg -i fd-musl_10.2.0_amd64.deb
    rm fd-musl_10.2.0_amd64.deb
    ```

5. Install `nvm`
    ```bash
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    ```

5. NVIDIA Driver. Tips: you can hit `Tab` to see the available versions, install a more recent version.
    ```bash
    sudo apt install nvidia-driver-<version>
    sudo apt install nvidia-modprobe
    ```

6. Reboot the machine after installing all the packages.
    ```bash
    sudo reboot
    ```

---
At this point, you've installed all necessary packages, and you can proceed to the
[Terminal Setup](./terminal_setup.md#ubuntu).

# macOS

**If there is any OS updates, please install them first before proceeding.**

1. (Optional) Download Chrome using Safari and install it. Set chrome as the default
    browser, and sign in to your Google account.

2. Install iTerm2 from [here](https://iterm2.com/downloads.html). Decompress the ZIP
    file and move the app to the Applications folder. From now on, use iTerm2 instead of
    the default Terminal app.


3. Install Homebrew
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
    During the installation, you will be asked to install the Command Line Tools. Click
    `Install` and wait for the download.
    You will be asked to supply your password in the middle as well, do so and wait
    for the installation to finish.

    At this moment, you haven't cloned this repo yet, meaning you are not configuring
    `zsh` and the rest of the dotfiles. So right after the installation, `brew` will
    not work out of the box yet. Temporarily, run the following command to make it work.
    ```bash
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ```
    And verify that the shell can find `brew` by `which brew`.

4. Install essential packages
    ```bash
    brew install \
        automake bison cmake ffmpeg gcc git libuv neovim tmux wget findutils \
        zeromq ripgrep lazygit midnight-commander clang-format ruby lsd \
        zoxide shellcheck node cairo pango fd bottom md5sha1sum jless fzf \
        stats MonitorControl bob
    ```

---
At this point, you've installed all necessary packages, and you can proceed to the
[Terminal Setup](./terminal_setup.md#macos).

# .vim
My VIM config --- actually my dotfiles

## System Configuration

<details>
  <summary>macOS</summary>

  ### iTerm2

  Install iTerm2 from [here](https://iterm2.com/downloads.html)

  You may want to install the __test release__ for the curly underline feature.

  #### iTerm2 color schemes

  + Color schemes are in `iterm-colors` folder.
  + Type `cmd+i`.
  + Navigate to Colors tab.
  + Click on Load Presets.
  + Click on Import.
  + Set the color scheme in Settings (`cmd+,`) -> Profiles -> Colors.

  ### Install [homebrew](https://brew.sh/)
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

  ### Install software

  ```bash
  brew install automake bison cmake ffmpeg gcc git libuv neovim pdf2htmlex tmux wget zeromq ripgrep lazygit htop midnight-commander clang-format ruby lsd zoxide shellcheck node cairo pango fd bottom
  # SQLite
  brew install sqlite 
  brew install --cask db-browser-for-sqlite
  # TeX
  brew install texlive
  brew install latexit
  # node
  npm install --global yarn
  ```

  ### Common App to install

  + [Slack](https://slack.com/downloads/mac)
  + [InkScape](https://inkscape.org/release/)
  + [VLC](https://www.videolan.org/vlc/download-macosx.html): Download based on your chipset.
  + Gifski: from AppStore
  + Color Picker: from AppStore
  + [Skim](https://skim-app.sourceforge.io/)
  + KataGo
    + Install `katago` through `brew`
      ```bash
      brew install katago
      ```
    + Install KaTrain from [here](https://github.com/sanderland/katrain/releases) 
  
</details>

<details>
  <summary>Ubuntu</summary>

  ## Install Software

  ```bash
  # general software install
  sudo apt-get update
  sudo apt-get upgrade
  sudo apt-get install build-essential binutils cmake curl tmux unzip openssh-server xclip zsh ripgrep htop mc terminator clang-format ruby-full curl zoxide
  # latest git
  sudo apt-add-repository ppa:git-core/ppa
  sudo apt-get update
  sudo apt-get install git
  # nvidia driver
  sudo add-apt-repository ppa:graphics-drivers/ppa
  sudo apt-get update
  sudo apt-get install nvidia-driver-xxx  # select your version
  sudo apt-get install nvidia-modprobe  # for nvidia-docker
  # SQLite
  sudo apt-get update
  sudo apt install sqlite3
  sudo apt-get install sqlitebrowser
  ```

  ### Set terminator color schemes

  Follow the instructions in [`terminator-themes`](https://github.com/EliverLara/terminator-themes).

  ### Install neovim

  #### If there is deb package
  + Download the latest release [here](https://github.com/neovim/neovim/releases).
  + Install package using `sudo dpkg -i installer.deb`.

  ### AppImage
  + Download AppImage and make it executable
    ```bash
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage nvim
    ```

  + Move it into `$HOME/bin` folder which is reserved for AppImage. If you don't have this folder, create one.

  ### LazyGit
  ```bash
  # install this after conda
  conda install -c conda-forge lazygit
  ```

  ### lsd - Make your terminal list prettier.

  [Installation instruction](https://github.com/Peltoche/lsd#installation).

  ### bottom - System monitor

  [Installation](https://github.com/ClementTsang/bottom#debianubuntu).
  
</details>

### Post Configuration

Do you have dot folders and `pip.conf` to set?

## zsh

1. Change default bash to zsh:
    ```bash
    chsh -s $(which zsh)
    ```

2. Install [`oh-my-zsh`](https://ohmyz.sh/#install):
    ```bash
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

3. Make symbolic link for zshrc:
    ```bash
    # For mac
    ln -s ~/.vim/zshrc_mac ~/.zshrc
    # For linux
    ln -s ~/.vim/zshrc_linux ~/.zshrc
    ```
4. Install p10k
    ```bash
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ```
5. Install plugins
    ```bash
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
    ```

## Python + Common Dependencies

Download and install miniconda from [here](https://docs.conda.io/en/latest/miniconda.html).

### Install PyTorch

Install PyTorch from [here](https://pytorch.org/get-started/locally/)

Preferably from Conda build because this can avoid also installing CUDA from scratch.
For CPU version, use `pip`.

### Install Scientific Computing Packages

Some of these maybe installed previously with PyTorch.

```bash
pip install matplotlib seaborn
pip install numpy scipy scikit-learn scikit-image opencv-python
pip install pandas h5py tqdm
```

To install TensorFlow in Apple M1, follow the instructions [here](https://developer.apple.com/metal/tensorflow-plugin/).

### Python Dependencies for Coding

__Version might be sensitive between projects, make sure you install the correct version.__

```bash
pip install pynvim -U
pip install neovim - U
pip install jedi-language-server -U
pip install pre-commit -U
pip install mypy==0.961 types-setuptools -U
pip install flake8 -U
pip install black==22.3.0 -U
pip install reorder-python-imports -U
pip install pyupgrade -U
pip install docformatter -U
pip install darglint -U
# if use a higher version of black, this might not be a problem
pip install click==8.0.4
pip install cpplint - U
# python profiler
pip install pyinstrument -U
# Jupyter
pip install jupyter-nbextensions-configurator
```

Darglint docstring linter support:

```bash
ln -s ~/.vim/.darglint ~/.darglint
```

## vim-tmux binding

1. Make symbolic link
    ```bash
    ln -s ~/.vim/tmux.conf ~/.tmux.conf
    ```

2. Get tmux plugin manage
    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

3. Install Powerline
    ```bash
    pip install powerline-status
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
    ```

4. Install tmux Plugins
    ```bash
    ~/.tmux/plugins/tpm/bin/install_plugins
    ```

## Terminal

+ [Ubuntu] Showing unicode character correctly, try
    ```bash
    sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en.UTF-8
    # Then reboot
    sudo reboot
    ```

## neovim

+ If you are using `neovim` then you need to add two symlinks to get this configuration works:

```bash
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vim/vimrc ~/.vim/init.vim
```

+ Install Vim Plugged, run the following:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### neovim tree-sitter

Install python tree-sitter via

```
:TSInstall python
```

### WakaTime

Will promote for WakaTime key, get it from the website.

## [InkScape](https://inkscape.org/)

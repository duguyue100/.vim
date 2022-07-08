# .vim
My VIM config --- actually my dotfiles

## System Configuration

<details>
  <summary>macOS</summary>

  ### iTerm2

  Install iTerm2 from [here](https://iterm2.com/downloads.html)

  ### Install homebrew
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

  ### Install software

  ```bash
  brew install automake bison cmake ffmpeg gcc git libuv neovim pdf2htmlex tmux wget zeromq ripgrep lazygit htop midnight-commander clang-format code-minimap ruby
  ```
  
</details>

<details>
  <summary>Ubuntu</summary>

  ```bash
  # general software install
  sudo apt-get update
  sudo apt-get upgrade
  sudo apt-get install build-essential binutils cmake curl tmux unzip openssh-server xclip zsh ripgrep htop mc terminator clang-format ruby-full curl
  # latest git
  sudo apt-add-repository ppa:git-core/ppa
  sudo apt-get update
  sudo apt-get install git
  # nvidia driver
  sudo add-apt-repository ppa:graphics-drivers/ppa
  sudo apt-get update
  sudo apt-get install nvidia-driver-xxx  # select your version
  sudo apt-get install nvidia-modprobe  # for nvidia-docker
  ```

  ```bash
  # install this after conda
  conda install -c conda-forge lazygit
  ```

  For `code-minimap`, install from [release](https://github.com/wfxr/code-minimap/releases)
  
  
</details>

## zsh

1. Install `oh-my-zsh`:
    ```bash
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

2. Make symbolic link for zshrc:
    ```bash
    # For mac
    ln -s ~/.vim/zshrc_mac ~/.zshrc
    # For linux
    ln -s ~/.vim/zshrc_linux ~/.zshrc
    ```
3. Install p10k
    ```bash
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ```
4. Install plugins
    ```bash
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
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
### Python Dependencies for Coding

__Version might be sensitive between projects, make sure you install the correct version.__

```bash
pip install pynvim -U
pip install jedi-language-server -U
pip install pre-commit -U
pip install mypy==0.942 -U
pip install flake8 -U
pip install black==19.10b0 -U
pip install reorder-python-imports -U
pip install pyupgrade -U
pip install docformatter -U
pip install draglint -U
# if use a higher version of black, this might not be a problem
pip install click==8.0.4
pip install cpplint - U
# python profiler
pip install pyinstrument -U
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

+ Showing unicode character correctly, try
    ```bash
    sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en.UTF-8
    # Then reboot
    sudo reboot
    ```
## colorls

Make your terminal list prettier.

[Installation instruction](https://github.com/athityakumar/colorls#installation).

## neovim tree-sitter

Install python tree-sitter via

```
:TSInstall python
```

## WakaTime

Will promote for WakaTime key, get it from the website

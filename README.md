# .vim
My VIM config --- actually my dotfiles

## Makefile

I use Makefile to manage command line software installations.

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
  make install_homebrew
  ```

  ### Install software

  ```bash
  make mac_install
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
  make ubuntu_install
  make NV_DRIVER_VERSION=xxx nvidia_driver
  ```

  ### Set terminator color schemes

  Follow the instructions in [`terminator-themes`](https://github.com/EliverLara/terminator-themes).

  ### Install neovim

  #### If there is deb package
  + Download the latest release [here](https://github.com/neovim/neovim/releases).
  + Install package using `sudo dpkg -i installer.deb`.

  ### AppImage

  ```bash
  make neovim_linux
  ```

  ### LazyGit
  ```bash
  # install this after conda
  conda install -c conda-forge lazygit
  ```

  ### lsd - Make your terminal list prettier.

  [Installation instruction](https://github.com/Peltoche/lsd#installation).

  ### bottom - System monitor

  [Installation](https://github.com/ClementTsang/bottom#debianubuntu).

  ### A prettier `nvidia-smi`

  For a better NVIDIA GPU monitoring, use [`nvitop`](https://github.com/XuehaiPan/nvitop)

  Install by

  ```
  make py_nvitop
  ```
  
</details>

### Post Configuration

Do you have dot folders and `pip.conf` to set?

## zsh

1. Change default bash to zsh:
    ```bash
    make switch_to_zsh
    ```

2. Install [`oh-my-zsh`](https://ohmyz.sh/#install):
    ```bash
    make omz_install
    ```

3. Install plugins
    ```bash
    make omz_plugins
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
make py_commons
```

To install TensorFlow in Apple M1, follow the instructions [here](https://developer.apple.com/metal/tensorflow-plugin/).

### Python Dependencies for Coding

__Version might be sensitive between projects, make sure you install the correct version.__

```bash
make py_coding
```

## Terminal Configuration

```bash
make terminal_config
```

## Terminal

+ [Ubuntu] Showing unicode character correctly, try
    ```bash
    sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en.UTF-8
    # Then reboot
    sudo reboot
    ```

## neovim

This repo use `lazy.nvim` for package management, after linking the `nvim` 
configuration directory, running `nvim` in terminal will trigger the automatic 
installation and configuration.


+ (Legacy) Install Vim Plugged, run the following:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### neovim tree-sitter

Install python tree-sitter via

```
:TSInstall python lua typescript javascript
```

### WakaTime

Will promote for WakaTime key, get it from the website.

## [InkScape](https://inkscape.org/)

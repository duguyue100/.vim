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

  ### Install [homebrew](https://brew.sh/) and software
  ```bash
  ./install homebrew
  ./install mac_essentials
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
  ./install ubuntu_essentials
  ./install nvidia_driver
  ```

  ### Set terminator color schemes

  Follow the instructions in [`terminator-themes`](https://github.com/EliverLara/terminator-themes).

  ### Install neovim

  ```bash
  ./install neovim
  ```

  ### lsd - Make your terminal list prettier.

  [Installation instruction](https://github.com/Peltoche/lsd#installation).

  ### bottom - System monitor

  [Installation](https://github.com/ClementTsang/bottom#debianubuntu).

  ```

</details>

### Post Configuration

Do you have dot folders and `pip.conf` to set?

## zsh

1. Change default bash to zsh:
    ```bash
    ./install switch_to_zsh
    ```

2. Install [`oh-my-zsh`](https://ohmyz.sh/#install):
    ```bash
    ./install omz
    ```

## Python + Common Dependencies

```
./install conda
./install python_commons
./install pytorch
./install python_dev
```

To install TensorFlow in Apple M1, follow the instructions [here](https://developer.apple.com/metal/tensorflow-plugin/).

## Terminal Configuration

```bash
./install terminal_config
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

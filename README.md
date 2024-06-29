# .vim
My VIM config --- actually my dotfiles

## OS Configuration

<details>
    <summary>macOS</summary>

    ### iTerm2

    Install iTerm2 from [here](https://iterm2.com/downloads.html). You may want to
    install the __test release__ for the curly underline feature.

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

    ### Install MacTex

    ```bash
    ./install mactex
    ```

    ### Common Apps to install

    + [Slack](https://slack.com/downloads/mac)
    + [InkScape](https://inkscape.org/release/)
    + [VLC](https://www.videolan.org/vlc/download-macosx.html): Download based on your chipset.
    + Gifski: from AppStore
    + Color Picker: from AppStore
    + [Stats](https://github.com/exelban/stats)
    + [Scroll Reverser](https://github.com/pilotmoon/Scroll-Reverser)
    + [Rectangle](https://rectangleapp.com/)
        + In settings, repeated commands, set cycle 1/2, 2/3 and 1/3 on half actions
    + [MonitorControl](https://github.com/MonitorControl/MonitorControl)
    + [Skim](https://skim-app.sourceforge.io/)
    + [Typora](https://typora.io/)
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
</details>

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

### neovim tree-sitter

Install python tree-sitter via

```
:TSInstall python lua typescript javascript
```

### WakaTime

Will promote for WakaTime key, get it from the website.

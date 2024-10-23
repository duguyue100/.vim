# .vim
My VIM config --- actually my dotfiles

## OS Configuration

Go to [setup_os](./setup_os) directory and follow the instructions for your OS.


## Leftover (to be removed after completing Ubuntu's setup)

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

To install TensorFlow in Apple M1, follow the instructions [here](https://developer.apple.com/metal/tensorflow-plugin/).

+ [Ubuntu] Showing unicode character correctly, try
    ```bash
    sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en.UTF-8
    # Then reboot
    sudo reboot
    ```

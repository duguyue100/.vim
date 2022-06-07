# .vim
My VIM config --- very naive..

## System Configuration

<details>
  <summary>macOS</summary>

  ### Install homebrew
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

  ### Install software

  ```bash
  brew install automake bison cmake ffmpeg gcc git libuv neovim pdf2htmlex tmux wget zeromq
  ```
  
</details>

<details>
  <summary>Ubuntu</summary>
</details>

## zshrc

Make symbolic link:
```bash
ln -s ~/.vim/zshrc_mac ~/.zshrc
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
pip install matpliblib, seaborn
pip install numpy, scipy, scikit-learn, scikit-image
pip install pandas, h5py
```
### Python Dependencies for Coding

__Version might be sensitive between projects, make sure you install the correct version.__

```bash
pip install pynvim -U
pip install jedi-language-server -U
pip install mypy -U
pip install flake8 -U
pip install black -U
```

## For Linux

```
sudo apt-get install xclip
```

## For `neovim`

```shell
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vim/vimrc ~/.vim/init.vim
```

## For vim-tmux binding

1. Make symbolic link
    ```
    ln -s ~/.vim/tmux.conf ~/.tmux.conf
    ```

2. Get tmux plugin manage
    ```
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

3. Install Powerline
    ```
    pip install powerline-status
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
    ```

4. Install tmux Plugins
    ```
    ~/.tmux/plugins/tpm/bin/install_plugins
    ```

## WakaTime

Will promote for WakaTime key, get it from the website

## TODO: zshrc

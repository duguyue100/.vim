# .vim
My VIM config --- very naive..

## Python Related Dependencies

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

# .vim
My VIM config --- very naive..


## Before Installation

You will need a `vim` that is compiled with `python` flag.

## Installation

Clone this project recursively to home directory so that you can get all the plugins:

```bash
git clone --recursively https://github.com/duguyue100/.vim.git
```

However, if you did not clone with bundle, run following commands in `vim`:

```viml
:PluginInstall
```

And if needed, run following commands to update all repository:

```
:PluginUpdate
```

## Post Installation

There are few plugins that need some post compilation.

### YouCompleteMe

Compile project through instruction found [here](http://valloric.github.io/YouCompleteMe/)

You can add flags so that there are more language supports.

### webapi-vim

This plugin is at `bundle/webapi-vim`, just run

```bash
make
```

to compile it.

### gist-vim

In order to publish Gist, you need to setup it by following the instructions [here](https://github.com/mattn/gist-vim)

## For `neovim`

If you are using `neovim` then you need to add two symlinks to get this configuration works:

```shell
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vim/vimrc ~/.vim/init.vim
```

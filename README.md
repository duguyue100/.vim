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

## For vim-tmux binding

Add following lines in `~/.tmux.config`:

```
# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
bind-key -n C-\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
```

## For completor

The completor is [here](https://github.com/maralla/completor.vim)

Use the following for python support:

```vim
let g:completor_python_binary = '/path/to/python/with/jedi/installed'
```

Use the following for tab selection:

```vim
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
```

if status is-interactive
    # Commands to run in interactive sessions can go here
end

if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
end

if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

set -U fish_color_command green
set -g fish_key_bindings fish_vi_key_bindings
set -U fish_greeting ""
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --preview 'cat {}'"

export PATH="/opt/nvim-linux64/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

alias m=$HOME/.vim/macman/macman
alias n=nvim
alias towork="cd $HOME/workspace"
alias todown="cd $HOME/Downloads"
alias tocore="cd $HOME/workspace/latticeflow-core"
alias togo="cd $HOME/workspace/latticeflow-core/assessment"
alias lg="lazygit"
alias slg="SKIP=pytest,pytest_docs,mypy,nbqa-mypy,nbqa-flake8,mypy_nbqa_runner,shellcheck,actionlint lazygit -ucf $HOME/.vim/lazygit-config.yaml"
alias reload="source $HOME/.config/fish/config.fish"
# shortcut to activate venv faster
alias uvact="source .venv/bin/activate.fish; starship init fish | source"
function ocweb
    bash -c 'exec -a ocweb opencode web --mdns --mdns-domain yuhuangoc.local'
end

alias ls='lsd -X --group-directories-first -A'
# alias tmux="TERM=xterm-256color tmux"
alias btm="btm --dot_marker --enable_gpu"
alias mc="mc -u"

switch (uname)
    case Darwin
    case Linux
        alias open="xdg-open"
        alias nvidia-smi="nvitop --colorful"
        set FNM_PATH "$HOME/.local/share/fnm"
        if [ -d "$FNM_PATH" ]
            set PATH "$FNM_PATH" $PATH
            fnm env | source
        end
end

source $HOME/DGY/bin/activate.fish

starship init fish | source
zoxide init fish | source
fzf --fish | source

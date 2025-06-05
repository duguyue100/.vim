if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_color_command green
set -g fish_key_bindings fish_vi_key_bindings
set -U fish_greeting ""
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --preview 'cat {}'"

export PATH="/opt/nvim-linux64/bin:$PATH"

alias m=$HOME/.vim/macman/macman
alias n=nvim

alias towork="cd $HOME/workspace"
alias todown="cd $HOME/Downloads"
alias tocore="cd $HOME/workspace/latticeflow-core"
alias tozoo="cd $HOME/workspace/models_zoo"
alias open="xdg-open"
alias lg="lazygit"
alias slg="SKIP=pytest,pytest_docs,mypy,nbqa-mypy,mypy_cloud,mypy_dto,mypy_sdk,nbqa-flake8,mypy_nbqa_runner,shellcheck lazygit"

alias ls='lsd -X --group-directories-first -A'
# alias tmux="TERM=xterm-256color tmux"
alias btm="btm --dot_marker --enable_gpu"
alias nvidia-smi="nvitop --colorful"

source $HOME/.vim/conda.fish

starship init fish | source
zoxide init fish | source
fzf --fish | source

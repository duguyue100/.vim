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

export PATH="$HOME/.cargo/bin:$PATH"

source $HOME/.vim/macman/macman.fish
alias n=nvim
alias towork="cd $HOME/workspace"
alias todown="cd $HOME/Downloads"
alias tocore="cd $HOME/workspace/latticeflow-core"
alias togo="cd $HOME/workspace/latticeflow-core/assessment"
alias lfd="$HOME/workspace/latticeflow-core/assessment/tools/docker.py"
alias lg="lazygit"
alias slg="SKIP=pytest,pytest_docs,mypy,nbqa-mypy,nbqa-flake8,mypy_nbqa_runner,shellcheck,actionlint lazygit -ucf $HOME/.vim/lazygit-config.yaml"
alias ldocker="lazydocker"
alias reload="source $HOME/.config/fish/config.fish"
# shortcut to activate venv faster
alias uvact="source .venv/bin/activate.fish; starship init fish | source"
alias ls='lsd -X --group-directories-first -A'
# alias tmux="TERM=xterm-256color tmux"
alias btm="btm --dot_marker --enable_gpu"
export EDITOR="nvim"

switch (uname)
    case Darwin
        export PATH="$HOME/.local/bin:$PATH"
    case Linux
        export PATH="$HOME/.local/bin:$PATH"
        alias open="xdg-open"
        alias nvidia-smi="nvitop --colorful"
        set FNM_PATH "$HOME/.local/share/fnm"
        if [ -d "$FNM_PATH" ]
            set PATH "$FNM_PATH" $PATH
            fnm env | source
        end
end

# Only activate DGY if no virtual environment is already active
if test -z "$VIRTUAL_ENV"
    source $HOME/DGY/bin/activate.fish
end

starship init fish | source
zoxide init fish | source
fzf --fish | source

function fgf
    fzf --disabled --ansi --cycle --layout reverse \
      --border --input-border --list-border \
      --bind "change:reload:rg --column --line-number --no-heading --color=always --smart-case {q} || true" \
      --bind "enter:execute(nvim {1} +{2}; tput rmcup; clear)+abort" \
      --delimiter : \
      --preview 'bat --color=always --highlight-line={2} {1} 2>/dev/null | awk -v str="{q}" "BEGIN {IGNORECASE=1} str != \"\" {gsub(str, \"\033[30;43m&\033[0m\")} 1"' \
      --preview-window 'right,60%,+{2}-/2'
end

function fff
    fd --type f --hidden --exclude .git --color=always | fzf \
      --exact --ansi --cycle --layout reverse \
      --border --input-border --list-border \
      --bind "enter:execute(nvim {1}; tput rmcup; clear)+abort" \
      --preview 'test -n "{1}" && bat --color=always {1}' \
      --preview-window 'right,60%'
end

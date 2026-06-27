# macman: command dispatcher. Source this file, then `m <command> [args...]`.
# Add a command: define `__m_<name> --description '...'` with your logic.

function m --description 'macman command dispatcher'
    if test (count $argv) -eq 0
        __m_help
        return
    end
    set -l cmd $argv[1]
    set -e argv[1]
    set -l fn __m_(string replace -a '.' '_' -- $cmd)
    if functions -q $fn
        $fn $argv
    else
        echo "Command '$cmd' not found. Try: m help"
    end
end

function __m_cap --description 'capitalize first letter'
    echo (string upper -- (string sub -l 1 -- $argv[1]))(string sub -s 2 -- $argv[1])
end

function __m_help --description 'show available commands'
    set -l arg $argv[1]
    if test -n "$arg"; and not contains $arg general git multiplexer functions
        echo "'$arg' not found as a command group or command."
        return
    end
    set -l groups general git multiplexer functions
    if test -n "$arg"
        set groups $arg
    end
    echo "Available commands:"
    for g in $groups
        echo
        echo (__m_cap $g):
        __m_render_group $g
    end
end

function __m_render_group --description 'render one group table'
    set -l g $argv[1]
    set -l names
    switch $g
        case general
            set names info lock ports uptime weather waka fd.size disk
        case git
            set names g.stat g.clone g.pull g.th.bh g.migrate g.switch gs g.co.bh g.add g.add.all g.commit g.conf go
        case multiplexer
            set names t.div.h t.div.v t.de t.at t t.re t.ls t.rm tpx t.new twx t.rename
        case functions
            set names jpy2html jupyter
    end
    set -l maxw 4
    for n in $names
        set -l fn __m_(string replace -a '.' '_' -- $n)
        if functions -q $fn
            set -l l (string length -- $n)
            if test $l -gt $maxw
                set maxw $l
            end
        end
    end
    for n in $names
        set -l fn __m_(string replace -a '.' '_' -- $n)
        if functions -q $fn
            set -l desc (functions --details --verbose $fn)[5]
            printf "  %-*s  %s\n" $maxw $n $desc
        end
    end
end


# General
function __m_info --description 'Get OS info'
    sw_vers
end

function __m_lock --description 'Lock screen'
    osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
end

function __m_ports --description 'Get list of used ports'
    sudo lsof -iTCP -sTCP:LISTEN -P
end

function __m_uptime --description 'Get uptime'
    uptime
end

function __m_weather --description 'Get weather'
    curl wttr.in
end

function __m_waka --description 'Open wakatime dashboard'
    open https://wakatime.com/dashboard
end

function __m_fd_size --description 'Get folder size'
    du -sch $argv
end

function __m_disk --description 'Print disk usage'
    if command -q duf
        CLICOLOR_FORCE=1 duf -width 180
    else
        df -h
    end
end


# Functions
function __m_jpy2html --description 'Render jupyter notebook as html'
    set -l file $argv[1]
    set -l outfile (string replace '.ipynb' '.html' -- $file)
    echo "The rendered file is saved as $outfile."
    jupyter nbconvert --to html $file
end

function __m_jupyter --description 'Start jupyter server'
    set -l port 9000
    if test (count $argv) -gt 0
        set port $argv[1]
    end
    jupyter notebook --port=$port --NotebookApp.token='lfyuhuang'
end


# Git
function __m_g_stat --description 'Get git status'
    git status
end

function __m_g_clone --description 'Clone git repository into <name>/main'
    set -l url $argv[1]
    set -l name (string split '/' -- $url)[-1]
    if string match -q '*.git' -- $name
        set name (string replace -r '\.git$' '' -- $name)
    end
    set -e argv[1]
    mkdir -p $name
    git clone $url $argv $name/main
end

function __m_g_pull --description 'Pull git repository'
    git pull
end

function __m_g_th_bh --description 'Create branch in a new worktree and switch to it'
    set -l branch $argv[1]
    set -l name (string replace -r -a '[^A-Za-z0-9._-]' '-' -- $branch)
    git worktree add ../$name -b $branch
    cd ../$name
end

function __m_g_migrate --description 'Restructure a manually cloned repo into <name>/main worktree layout'
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$root"
        echo "Not inside a git repository."
        return 1
    end
    cd $root
    if test (basename $root) = main
        echo "Already inside a 'main' directory; nothing to migrate."
        return 1
    end
    set -l name (basename $root)
    cd ..
    mv $name $name.__migrate_tmp
    mkdir $name
    mv $name.__migrate_tmp $name/main
    cd $name/main
    echo "Migrated $name → $name/main"
end

function __m_g_switch --description 'List worktrees and jump to selected (j/k Enter)'
    set -l wt_lines
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set wt_lines (git worktree list)
    else if test -d ./main/.git
        set wt_lines (git -C ./main worktree list)
    else
        echo "No worktrees here. Run from a worktree or the <name>/ folder."
        return 1
    end
    if test (count $wt_lines) -eq 0
        echo "No worktrees."
        return 1
    end
    set -l paths
    set -l display
    for line in $wt_lines
        set -l p (string match -r '^[^ ]+' -- $line)
        set -a paths $p
        set -l branch (string match -r '\[[^]]*\]' -- $line)
        set -l short (string split / -- $p)[-2..-1]
        set -a display (string join / -- $short)"  $branch"
    end
    set -l choice (printf '%s\n' $display | fzf --reverse --bind j:down,k:up --header='j/k navigate, Enter jump')
    if test -n "$choice"
        set -l i (contains --index -- $choice $display)
        cd $paths[$i]
    end
end

function __m_gs --description 'Alias for g.switch'
    __m_g_switch $argv
end

function __m_g_co_bh --description 'Checkout git branch'
    git checkout $argv[1]
end

function __m_g_add --description 'Add files'
    git add $argv
end

function __m_g_add_all --description 'Add all files'
    git add -A
end

function __m_g_commit --description 'Commit changes'
    git commit -m $argv[1] -q
end

function __m_g_conf --description 'Show git config'
    git config --list
end

function __m_go --description 'Open git repository in browser'
    set -l url (git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#http://#' -e 's@com:@com/@' | head -n1)
    open $url
end


# Multiplexer (tmux)
function __m_t_div_h --description 'Split tmux pane horizontally'
    tmux split-window -h
end

function __m_t_div_v --description 'Split tmux pane vertically'
    tmux split-window -v
end

function __m_t_de --description 'Detach tmux session'
    tmux detach-client
end

function __m_t_at --description 'Create new tmux session'
    tmux new -s $argv[1] \; split-window -v -l 20% \; select-pane -t 0
end

function __m_t --description 'Create new main tmux setup'
    set -l session main
    if test (count $argv) -gt 0
        set session $argv[1]
    end
    tmux new -s $session -n 🧠 \; split-window -v -l 20% \; select-pane -t 0 \; \
        new-window -n 🧾 \; split-window -v -l 20% \; select-pane -t 0 \; \
        new-window -n 🌐 \; split-window -v -l 20% \; select-pane -t 0 \; \
        new-window -n 🎮 \; split-window -v -l 20% \; select-pane -t 0 \; \
        select-window -t 🧠
end

function __m_t_re --description 'Re-attach tmux session'
    tmux attach -t $argv[1]
end

function __m_t_ls --description 'List tmux sessions'
    tmux list-sessions
end

function __m_t_rm --description 'Remove tmux session'
    tmux kill-session -t $argv[1]
end

function __m_tpx --description 'Remove tmux pane'
    tmux kill-pane
end

function __m_t_new --description 'Create new tmux window'
    if test (count $argv) -eq 0
        tmux new-window \; split-window -v -l 20% \; select-pane -t 0
    else
        tmux new-window -n $argv[1] \; split-window -v -l 20% \; select-pane -t 0
    end
end

function __m_twx --description 'Remove a tmux window'
    if test (count $argv) -eq 0
        tmux kill-window
    else
        tmux kill-window -t $argv[1]
    end
end

function __m_t_rename --description 'Rename a tmux window'
    tmux rename-window $argv[1]
end

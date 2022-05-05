"Author - Yuhuang Hu
"Email  - duguyue100@gmail.com

" === Vundle ===

set nocompatible
filetype off

call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'christoomey/vim-tmux-navigator'

Plug 'lervag/vimtex'
Plug 'junegunn/goyo.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'cljoly/telescope-repo.nvim'

Plug 'wakatime/vim-wakatime'

" assuming you're using vim-plug: https://github.com/junegunn/vim-plug
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-ultisnips'

Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'scrooloose/nerdcommenter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

" === General ===
let mapleader = ","

"" file indent
filetype plugin on
filetype indent on

"" Turn on omni completion
set omnifunc=syntaxcomplete

"" autoread if modified elsewehre
set autoread
set autoread

"" fast saving
nmap <leader>w :w!<cr>
nmap <leader>q :qall<cr>

" === User Interface ===

"" Set 12 lines to the cursor - when moving vertically using j/k
set so=12

"" Wild menu
set wildmenu

"" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"" Always show current position
set ruler

"" Use enter to create new lines w/o entering insert mode
nnoremap <CR> o<Esc>

"" Height of the command bar
set cmdheight=2

"" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

"" Ignore case when searching
set ignorecase

"" When searching try to be smart about cases 
set smartcase

"" Highlight search results
set hlsearch

"" Makes search act like search in modern browsers
set incsearch 

"" Don't redraw while executing macros (good performance config)
set lazyredraw 
set ttyfast

" For regular expressions turn magic on
set magic

"" Show matching brackets when text indicator is over them
set showmatch

"" How many tenths of a second to blink when matching brackets
set mat=2

"" tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set textwidth=79
set expandtab
set smarttab
set lbr
set tw=500
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

"" Add a bit extra margin to the left
set foldcolumn=1
set colorcolumn=88

"" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" === Colors and Fonts ===

"" Set line numbers
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter   * if &nu | set nornu | endif
augroup END
set showcmd

"" set colors
syntax enable
colorscheme despacio 
set background=dark

"" set color scheme when quit Goyo
function! GoyoAfter()
  colorscheme despacio
  set background=dark
endfunction

let g:goyo_callbacks = [function('GoyoAfter')]

if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
    set guifont=Ubuntu\ Mono:h18
endif

"" set encoding
set encoding=utf8

"" use Unix as file type
set ffs=unix,dos,mac

"" use vertical diff
if &diff
    set diffopt-=internal
    set diffopt+=vertical
endif

"" save using ctrl+w

noremap <silent> <C-W>          :update<CR>
vnoremap <silent> <C-W>         <C-C>:update<CR>
inoremap <silent> <C-W>         <C-O>:update<CR>

"" resize pane
nnoremap <silent> <Leader>= :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>


"" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

"" update dir to current file
autocmd BufEnter * silent! cd %:p:h

"" Timeout
set timeoutlen=500 ttimeoutlen=0

"" clipboard sharing
" set clipboard=unnamed
" if it doesn't work by default, try install xclip by sudo apt-get install xclip
set clipboard+=unnamedplus

" === Files, backup and undo ===
set nobackup
set nowb
set noswapfile

" === Moving around, tabs, window and buffers ===
map <space> /
" map <c-space> ?
inoremap <C-Space> <C-x><C-o>

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0

if has('nvim')
    nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
    tnoremap <Esc> <C-\><C-n>
    set termguicolors
endif

map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

map <F2> u
map! <F2> <C-O>u

" imap vv <Esc>
inoremap é <Esc>
inoremap � <Esc>
imap <F3> <Esc>[s1z=`]a
imap <F4> <Esc>[sz=
map ; :!

nmap <leader>bn :bn<cr>
nmap <leader>bp :bp<cr>
nmap <leader>bd :bd<cr>

" real delete
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>p "_dP

" === Status line ===
set laststatus=2

" === Spell checking ===
hi SpellBad ctermfg=128 ctermbg=000 cterm=none guifg=#FF0000 guibg=#0000FF gui=none
setlocal spell spelllang=en_us

" === Configure Airline ===
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" === Python ===
let g:python3_host_prog = '/home/yuhuang/miniconda3/bin/python'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

let g:ale_lint_on_enter = 1
let g:ale_python_flake8_options = '--max-line-length=88 --ignore=E203,E501,W503'
let g:ale_warn_about_trailing_whitespace = 0
" let g:ale_cpp_cc_executable = "/usr/local/bin/g++-10"
let g:ale_fixers = {'python': ['black']}
let g:ale_linters = {'python': ['mypy', "jedils"]}
let g:ale_fix_on_save = 1
nnoremap <leader>gd <cmd>ALEGoToDefinition<cr>


" === LaTeX ===
nmap <leader>tt :VimtexCompile<cr>
nmap <leader>vv :VimtexView<cr>
" let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_view_general_options_latexmk = '-r 1'
let g:tex_flavor = "latex"

" === Telescope ===

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fp <cmd>Telescope git_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" === NERD Commenting ===
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDDefaultAlign = 'left'

" === Git Gutter ===
" set updatetime=250
let g:signify_vcs_list = [ 'git' ]

" === Vim Session ===
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'

" === Markdown ===

let g:goyo_width = 120
let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1

" === Easy Align ===
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" === snippet ===
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')
" let g:UltiSnipsExpandTrigger="<c-t>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

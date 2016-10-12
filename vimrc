"Author - Yuhuang Hu
"Email  - duguyue100@gmail.com

" === Vundle ===

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'lervag/vimtex'
Plugin 'Shougo/vimproc.vim', {'do' : 'make'}
Plugin 'shougo/vimshell.vim'
Plugin 'Shougo/unite.vim'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
Plugin 'scrooloose/nerdcommenter'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'airblade/vim-gitgutter'
call vundle#end()

" === General ===
let mapleader = ","

"" file indent
filetype plugin on
filetype indent on

"" autoread if modified elsewehre
set autoread

"" fast saving
nmap <leader>w :w!<cr>
nmap <leader>q :qall<cr>

" === User Interface ===

"" Set 7 lines to the cursor - when moving vertically using j/k
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
set colorcolumn=80

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
set number
set showcmd

"" set colors
syntax enable
colorscheme badwolf

if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
    set guifont=Ubuntu\ Mono:h20
endif

"" set encoding
set encoding=utf8

"" use Unix as file type
set ffs=unix,dos,mac

" === Files, backup and undo ===
set nobackup
set nowb
set noswapfile

" === Moving around, tabs, window and buffers ===
map <space> /
map <c-space> ?

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0
map <F2> u
map! <F2> <C-O>u

" === Status line ===
set laststatus=2

" === Spell checking ===
hi SpellBad ctermfg=128 ctermbg=000 cterm=none guifg=#FF0000 guibg=#000000 gui=none
setlocal spell spelllang=en_us

" === Configure Airline ===
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" === Python ===
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
let g:syntastic_check_on_open = 1

" === LaTeX ===
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_view_general_options_latexmk = '-r 1'

" === Markdown ===

let g:vim_markdown_folding_disabled = 1

" === NERD Commenting ===

let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDDefaultAlign = 'left'

" === Gist ===
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1

" === Git Gutter ===
set updatetime=250

" === Vim Session ===
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'

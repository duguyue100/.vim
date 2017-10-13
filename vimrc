"Author - Yuhuang Hu
"Email  - duguyue100@gmail.com

" === Vundle ===

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
" Plugin 'valloric/youcompleteme'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'christoomey/vim-tmux-navigator'
" Plugin 'godlygeek/tabular'
" Plugin 'gabrielelana/vim-markdown'
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
Plugin 'junegunn/goyo.vim'
Plugin 'mattn/emmet-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'junegunn/vim-easy-align' 
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'Chiel92/vim-autoformat'
Plugin 'JuliaEditorSupport/julia-vim'
Plugin 'wakatime/vim-wakatime'
Plugin 'maralla/completor.vim'
call vundle#end()

" === General ===
let mapleader = ","

"" file indent
filetype plugin on
filetype indent on

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
set diffopt+=vertical

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
set clipboard=unnamedplus

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
inoremap <M-i> <Esc>
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
" let g:ycm_autoclose_preview_window_after_completion=1
" let g:ycm_goto_buffer_command='vertical-split'
" map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:completor_python_binary = '/home/dgywork/anaconda2/bin/python'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
let g:syntastic_check_on_open = 1
let g:syntastic_python_checkers = ['flake8']

" === LaTeX ===
nmap <leader>tc :VimtexCompile<cr>
nmap <leader>tv :VimtexView<cr>
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_view_general_options_latexmk = '-r 1'

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

" === JS ===
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1

" === Markdown ===

let g:goyo_width = 120

" === Easy Align ===
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" === snippet ===
"
let g:UltiSnipsExpandTrigger="<c-t>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-x>"
let g:UltiSnipsEditSplit="vertical"

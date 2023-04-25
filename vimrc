"Author - Yuhuang Hu
"Email  - duguyue100@gmail.com

" === Vim Plug ===

set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

" === UI ===

" Status line and Bufferline
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
Plug 'famiu/bufdelete.nvim'

" Color theme
Plug 'projekt0n/github-nvim-theme'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'EdenEast/nightfox.nvim'

" Icons
Plug 'nvim-tree/nvim-web-devicons' " Recommended (for coloured icons)

" Indent Blankline
Plug 'lukas-reineke/indent-blankline.nvim'

" Dashboard
" Plug 'mhinz/vim-startify'
Plug 'duguyue100/alpha-nvim'

" File Explorer
Plug 'kyazdani42/nvim-tree.lua'
Plug 'airblade/vim-rooter'

" Smooth scroll
Plug 'karb94/neoscroll.nvim'

" Stablize
Plug 'luukvbaal/stabilize.nvim'

" Floating command line
Plug 'MunifTanjim/nui.nvim'
Plug 'VonHeikemen/fine-cmdline.nvim'

" == Utility == 
Plug 'christoomey/vim-tmux-navigator'

" Vimtex
Plug 'lervag/vimtex'

" Goyo for focused writing.
Plug 'junegunn/goyo.vim'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'cljoly/telescope-repo.nvim'

" Wakatime support
Plug 'wakatime/vim-wakatime'

" == Coding Assistance ==

" LSP Related
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
" Plug 'glepnir/lspsaga.nvim'

" Static Analysis, Fixers, etc.
Plug 'dense-analysis/ale'
" formatter for docformatter
Plug 'sbdchd/neoformat'

" Code Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Code Pilot
Plug 'github/copilot.vim'

" Code Snippets
" Plug 'SirVer/ultisnips'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'
" Plug 'honza/vim-snippets'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

" Git Related
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'mhinz/vim-signify'
Plug 'f-person/git-blame.nvim'
Plug 'scrooloose/nerdcommenter'
Plug 'sindrets/diffview.nvim'

" Support Testing
Plug 'vim-test/vim-test'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python'
Plug 'nvim-neotest/neotest-plenary'
Plug 'nvim-neotest/neotest-vim-test'

" Code Runner
Plug 'is0n/jaq-nvim'

" Code bar
Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }

" Code skimming
Plug 'simrat39/symbols-outline.nvim'

" Todos
Plug 'folke/todo-comments.nvim'

" Code Find and Replace
Plug 'gabrielpoca/replacer.nvim'

" Code context
Plug 'nvim-treesitter/nvim-treesitter-context'

" Code scratchpad
Plug 'Shougo/junkfile.vim'

" Floating terminal
Plug 'voldikss/vim-floaterm'

call plug#end()

set completeopt=menu,menuone,noselect

" === General ===
let mapleader = ","

" Spell languages
set spelllang=en_us
" Turn on spell checker
set spell

"" Terminal colors
set termguicolors
lua << EOF
local present, bufferline = pcall(require, "bufferline")

if not present then
   return
end

vim.cmd [[
 function! Toggle_theme(a,b,c,d)
   lua require('base46').toggle_theme()
 endfunction
 function! Quit_vim(a,b,c,d)
     qa
 endfunction
]]

local buf_options = {
   options = {
      offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
      close_command = "Bdelete! %d",
      right_mouse_command = "Bdelete! %d",
      buffer_close_icon = "",
      modified_icon = "",
      close_icon = "",
      show_close_icon = false,
      left_trunc_marker = " ",
      right_trunc_marker = " ",
      max_name_length = 50,
      max_prefix_length = 13,
      tab_size = 20,
      show_tab_indicators = true,
      enforce_regular_tabs = false,
      view = "multiwindow",
      show_buffer_close_icons = true,
      separator_style = "thin",
      always_show_bufferline = true,
      diagnostics = false,
      themable = true,

      custom_areas = {
         right = function()
            return {
               { text = "%@Toggle_theme@" .. vim.g.toggle_theme_icon .. "%X" },
               { text = "%@Quit_vim@ %X" },
            }
         end,
      },

      custom_filter = function(buf_number)
         -- Func to filter out our managed/persistent split terms
         local present_type, type = pcall(function()
            return vim.api.nvim_buf_get_var(buf_number, "term_type")
         end)

         if present_type then
            if type == "vert" then
               return false
            elseif type == "hori" then
               return false
            end
            return true
         end

         return true
      end,
   },
}

-- check for any override
bufferline.setup(buf_options)

-- NVIMTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require'nvim-tree'.setup { -- BEGIN_DEFAULT_OPTS
  auto_reload_on_write = true,
  create_in_closed_folder = false,
  disable_netrw = false,
  hijack_cursor = true,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = true,
  reload_on_bufenter = false,
  respect_buf_cwd = true,
  view = {
    adaptive_size = false,
    centralize_selection = false,
    width = 30,
    hide_root_folder = false,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
        -- user mappings go here
      },
    },
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = false,
    full_name = false,
    highlight_opened_files = "all",
    root_folder_modifier = ":~",
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        item = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = "",
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    expand_all = {
      max_folder_discovery = 300,
    },
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
    remove_file = {
      close_window = true,
    },
  },
  trash = {
    cmd = "gio trash",
    require_confirm = true,
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
      watcher = false,
    },
  },
} -- END_DEFAULT_OPTS

local function open_nvim_tree()
    -- always open the tree
    require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Blankline
local present, blankline = pcall(require, "indent_blankline")

if not present then
  return
end

local blankline_options = {
  indentLine_enabled = 1,
  char = "▏",
  filetype_exclude = {
     "help",
     "terminal",
     "alpha",
     "packer",
     "lspinfo",
     "TelescopePrompt",
     "TelescopeResults",
     "nvchad_cheatsheet",
     "lsp-installer",
     "",
  },
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
}

blankline.setup(blankline_options)

-- Telescope
local present, telescope = pcall(require, "telescope")

if not present then
   return
end

local telescope_options = {
   defaults = {
      vimgrep_arguments = {
         "rg",
         "--color=never",
         "--no-heading",
         "--with-filename",
         "--line-number",
         "--column",
         "--smart-case",
      },
      prompt_prefix = "  ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
         horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
         },
         vertical = {
            mirror = false,
         },
         width = 0.87,
         height = 0.80,
         preview_cutoff = 120,
      },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "truncate" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
      mappings = {
         n = { ["q"] = require("telescope.actions").close },
      },
   },

   extensions_list = { "themes", "terms" },
}

-- check for any override
telescope.setup(telescope_options)

-- load extensions
pcall(function()
   for _, ext in ipairs(telescope_options.extensions_list) do
      telescope.load_extension(ext)
   end
end)

-- LSP
-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig').jedi_language_server.setup {
  capabilities = capabilities
}
require'lspconfig'.clangd.setup{
  capabilities = capabilities
}

local present, lsp_signature = pcall(require, "lsp_signature")

if not present then
  return
end

local lsp_signature_options = {
  bind = true,
  doc_lines = 0,
  floating_window = true,
  fix_pos = true,
  hint_enable = true,
  hint_prefix = " ",
  hint_scheme = "String",
  hi_parameter = "Search",
  max_height = 22,
  max_width = 140, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  handler_opts = {
     border = "single", -- double, single, shadow, none
  },
  zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
  padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
}

lsp_signature.setup(lsp_signature_options)

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
window = {
  completion = cmp.config.window.bordered(),
  documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'path' },
  { name = 'nvim_lsp' },
  { name = 'ultisnips' }, -- For ultisnips users.
}, {
  { name = 'buffer' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

-- Statusline
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'material',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

-- Dashboard
local newdash = require'alpha.themes.newdash'

newdash.section.header.val = {
[[           _____                    _____                _____          ]],
[[          /\    \                  /\    \              |\    \         ]],
[[         /::\    \                /::\    \             |:\____\        ]],
[[        /::::\    \              /::::\    \            |::|   |        ]],
[[       /::::::\    \            /::::::\    \           |::|   |        ]],
[[      /:::/\:::\    \          /:::/\:::\    \          |::|   |        ]],
[[     /:::/  \:::\    \        /:::/  \:::\    \         |::|   |        ]],
[[    /:::/    \:::\    \      /:::/    \:::\    \        |::|   |        ]],
[[   /:::/    / \:::\    \    /:::/    / \:::\    \       |::|___|______  ]],
[[  /:::/    /   \:::\ ___\  /:::/    /   \:::\ ___\      /::::::::\    \ ]],
[[ /:::/____/     \:::|    |/:::/____/  ___\:::|    |    /::::::::::\____\]],
[[ \:::\    \     /:::|____|\:::\    \ /\  /:::|____|   /:::/~~~~/~~      ]],
[[  \:::\    \   /:::/    /  \:::\    /::\ \::/    /   /:::/    /         ]],
[[   \:::\    \ /:::/    /    \:::\   \:::\ \/____/   /:::/    /          ]],
[[    \:::\    /:::/    /      \:::\   \:::\____\    /:::/    /           ]],
[[     \:::\  /:::/    /        \:::\  /:::/    /    \::/    /            ]],
[[      \:::\/:::/    /          \:::\/:::/    /      \/____/             ]],
[[       \::::::/    /            \::::::/    /                           ]],
[[        \::::/    /              \::::/    /                            ]],
[[         \::/____/                \::/____/                             ]],
[[          ~~                                                            ]],
}

require('alpha').setup(newdash.config)

-- JAQ
require('jaq-nvim').setup{
	-- Commands used with 'Jaq'
	cmds = {
		-- Default UI used (see `Usage` for options)
		default = "float",

		-- Uses external commands such as 'g++' and 'cargo'
		external = {
			typescript = "deno run %",
			javascript = "node %",
			markdown = "glow %",
			python = "$(which python) %",
			rust = "rustc % && ./$fileBase && rm $fileBase",
			cpp = "g++ % -o $fileBase && ./$fileBase",
			go = "go run %",
			sh = "sh %",
		},

		-- Uses internal commands such as 'source' and 'luafile'
		internal = {
			lua = "luafile %",
			vim = "source %"
		}
	},

	-- UI settings
	ui = {
		-- Start in insert mode
		startinsert = false,

		-- Switch back to current file
		-- after using Jaq
		wincmd      = false,

		-- Floating Window / FTerm settings
		float = {
			-- Floating window border (see ':h nvim_open_win')
			border    = "rounded",

			-- Num from `0 - 1` for measurements
			height    = 0.8,
			width     = 0.8,
			x         = 0.5,
			y         = 0.5,

			-- Highlight group for floating window/border (see ':h winhl')
			border_hl = "FloatBorder",
			float_hj  = "Normal",

			-- Floating Window Transparency (see ':h winblend')
			blend = 20
		},

		terminal = {
			-- Position of terminal
			position = "bot",

			-- Open the terminal without line numbers
			line_no = false,

			-- Size of terminal
			size     = 10
		},

		quickfix = {
			-- Position of quickfix window
			position = "bot",

			-- Size of quickfix window
			size     = 10
		}
	}
}

-- Smooth scroll
require('neoscroll').setup()

-- NeoTest
require("neotest").setup({
  diagnostic = {
    enabled = true
  },
  adapters = {
    require("neotest-vim-test")({ allow_file_types = { "python" } }),
  },

  highlights = {
    passed = "NeotestPassed",
    running = "NeotestRunning",
    failed = "NeotestFailed",
    skipped = "NeotestSkipped",
    test = "NeotestTest",
    namespace = "NeotestNamespace",
    focused = "NeotestFocused",
    file = "NeotestFile",
    dir = "NeotestDir",
    border = "NeotestBorder",
    indent = "NeotestIndent",
    expand_marker = "NeotestExpandMarker",
    adapter_name = "NeotestAdapterName",
    select_win = "NeotestWinSelect",
    marked = "NeotestMarked",
  },

  icons = {
    expanded = "",
    collapsed = "",
    passed = "✅",
    running = "✨",
    failed = "❌",
    unknown = "❔",
  },
})

-- TODOs
require("todo-comments").setup()

-- Stablize split
require("stabilize").setup()

-- Code context
require('treesitter-context').setup()

-- Symbols outline
require("symbols-outline").setup()

EOF

"" file indent
filetype plugin on
filetype indent on

"" Turn on omni completion
set omnifunc=syntaxcomplete

"" autoread if modified elsewehre
set autoread

"" fast saving
nmap <leader>w :w!<cr>
nmap <leader>q :qall<cr>

" === User Interface ===

"" Set 12 lines to the cursor - when moving vertically using j/k
set so=12

"" Enable mouse
set mouse=a

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
colorscheme duskfox

"" set color scheme when quit Goyo
function! GoyoAfter()
  colorscheme duskfox
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

" Quick navigation between splits
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0

if has('nvim')
    nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
    tnoremap <Esc> <C-\><C-n>
endif

" use ; for command
nnoremap ; <cmd>FineCmdline<CR>

" Manage tabs
nmap <leader>bn :BufferLineCycleNext<cr>
nmap <leader>bp :BufferLineCyclePrev<cr>
nmap <leader>bd :Bdelete<cr>
nnoremap <silent>mn :BufferLineMoveNext<CR>
nnoremap <silent>mp :BufferLineMovePrev<CR>

" Real delete for text
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>p "_dP

" === Status line ===
set laststatus=2

" === Spell checking ===
hi SpellBad ctermfg=128 ctermbg=000 cterm=none guifg=#FF0000 guibg=#0000FF gui=none
setlocal spell spelllang=en_us

" === ALE ===
let g:ale_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
let g:ale_set_balloons = 1
let g:ale_lint_on_enter = 1
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_fix_on_save = 1

let g:ale_python_flake8_options = '--max-line-length=88 --ignore=E203,E501,W503'
let g:ale_python_autoimport_options = '--config-file ~/.vim/autoimport-config.toml'
let g:ale_fixers = {
\   'python': ['black'],
\   'cpp': ['clang-format'],
\}
let g:ale_linters = {
\   'python': ['mypy', "jedils", "flake8"],
\}
if has("mac")
    let g:ale_cpp_cc_executable = "/usr/local/bin/g++-12"
endif

nnoremap <leader>gd <cmd>ALEGoToDefinition<cr>

" ==== NeoFormat ===
let g:neoformat_python_docformatter = {
            \ 'exe': 'docformatter',
            \ 'args': ['--wrap-summaries 88', '--wrap-descriptions 88', '-'],
            \ 'stdin': 1,
            \ }
let g:neoformat_enabled_python = ['docformatter']
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" === LaTeX ===
nmap <leader>tt :VimtexCompile<cr>
nmap <leader>vv :VimtexView<cr>
if has("mac")
    let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
endif
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_view_general_options_latexmk = '-r 1'
let g:tex_flavor = "latex"

" === Telescope ===
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

" === Git ===
let g:signify_vcs_list = [ 'git' ]

" === Vim Session ===
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'

" === Markdown ===
let g:goyo_width = 120
let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1

" === Code Runner ===
nnoremap <leader>r <cmd>Jaq<cr>

" === NeoTest ===
let test#python#pytest#options = "--color=yes"
command NTestRun :lua require("neotest").run.run(vim.fn.expand("%"))
command NTestRunNearest :lua require("neotest").run.run()
command NTestStopNearest :lua require("neotest").run.stop()
command NTestSummaryOpen :lua require("neotest").summary.open()
command NTestSummaryClose :lua require("neotest").summary.close()
command NTestSummaryToggle :lua require("neotest").summary.toggle()
command NTestOutput :lua require("neotest").output.open({ enter = true })

" === Code scroll bar===
let g:scrollview_excluded_filetypes = ['nerdtree']
let g:scrollview_current_only = 1
let g:scrollview_winblend = 75
highlight ScrollView ctermbg=159 guibg=LightCyan

" === Vim Doge for docstring ===
let g:doge_doc_standard_python = 'google'

" === Find and Replace ===
nmap <leader>h :lua require("replacer").run()<cr>

" === Float Terminal ===
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8

" === Copilot ===
imap <silent> <C-f> <Plug>(copilot-next)
imap <silent> <C-b> <Plug>(copilot-previous)

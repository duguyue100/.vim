vim.g.mapleader = ","

local opt = vim.opt

opt.ai = true
opt.autoread = true
opt.autowrite = true -- Enable auto write
opt.backspace = "eol,start,indent"
opt.belloff = "all"
-- if it doesn't work by default, try install xclip by sudo apt-get install xclip
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.cmdheight = 2
opt.colorcolumn = "88"
opt.completeopt = "menu,menuone,noselect"
opt.encoding = "utf-8"
opt.expandtab = true
opt.ffs = "unix,dos,mac"
opt.foldcolumn = "1"
opt.hid = true
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.laststatus = 2
opt.lazyredraw = true
opt.lbr = true
opt.magic = true
opt.mat=2
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.shiftwidth=4
opt.showcmd = true
opt.showmatch = true
opt.showmode = false
opt.si = true
opt.smartcase = true
opt.smarttab = true
opt.so = 12
opt.softtabstop=4
opt.spell = true
opt.spelllang = { "en" }
opt.tabstop=4
opt.termguicolors = true
opt.textwidth=79
opt.timeoutlen = 500
opt.ttimeoutlen = 0
opt.ttyfast = true
opt.tw=500
opt.whichwrap = opt.whichwrap + "<,>,h,l"
opt.wildignore = "*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store"
opt.wildmenu = true
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wrap = true

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append({ C = true })
end

vim.g.session_autoload = "yes"
vim.g.session_autosave = "yes"

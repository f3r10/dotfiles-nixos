local option = vim.opt
local global_opt = vim.opt_global

--global
option.wildignore = {
  ".git",
  "*/node_modules/*",
  "*/target/*",
  ".metals",
  ".bloop",
  ".ammonite",
}
global_opt.completeopt = { "menuone", "noselect" }

vim.api.nvim_win_set_option(0, "number", true)
option.history = 1000
option.ignorecase = true --case insensitive searching
option.hlsearch = true --highlight search results
option.incsearch = true -- set incremental search, like modern browsers
option.magic = true -- Set magic on, for regex
global_opt.cmdheight = 2 --" command bar height

global_opt.showbreak = "↪"

---- window-scoped
option.wrap = true
option.wrapmargin = 8
option.linebreak = true
option.breakindent = true
option.autoindent = true --" automatically set indent of new line
option.diffopt = "vertical" -- the original conf had +=
option.wildmode = "list:longest" --" complete files like a shell

option.foldenable = false

-- Global
option.laststatus = 2
option.smartcase = true
option.lazyredraw = true
option.updatetime = 300
option.splitright = true
option.showmatch = true
option.showmode = false
option.pumheight = 25
option.title = true
option.previewheight = 18
option.pumblend = 20
option.hidden = true
option.showtabline = 2
option.scrolloff = 8
option.termguicolors = true
global_opt.termguicolors = true
global_opt.shortmess:remove("F"):append "c"
option.clipboard:append { "unnamedplus" }
option.fillchars = {
  eob = " ",
  stlnc = "─",
  diff = "·",
}

-- Local to window
option.number = true
option.relativenumber = false
option.cursorline = false -- elm issue
option.mouse = "a"
option.virtualedit = "block"
option.signcolumn = "yes"
-- option.signcolumn="number"
option.list = true
option.listchars = {
  tab = "> ",
  eol = "¬",
  nbsp = "␣",
  trail = "•",
}
option.foldmethod = "expr"
option.foldexpr = "nvim_treesitter#foldexpr()"
-- Hack indent-blankline https://github.com/lukas-reineke/indent-blankline.nvim/issues/59#issuecomment-806398054
option.colorcolumn = "99999"

-- Local to buffer
local indent = 2
option.shiftwidth = indent
option.tabstop = indent
option.softtabstop = indent
option.expandtab = true
option.smartindent = true
option.swapfile = false

option.fileformat = "unix"
option.undofile = true
option.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- credits to https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- for an weird error relate with CursorHold
-- vim.g["cursorhold_updatetime"] = 100


vim.g.loaded_matchparen = 1

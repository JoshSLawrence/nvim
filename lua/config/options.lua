------------------------------- [VIM Globals] -------------------------------

-- IMPORTANT: mapleader/maplocalleader must be set before lazy.nvim loads
-- (see init.lua load order) so that plugin mappings pick up the right leader.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- NOTE: I have configured plugins that optionally support nerd fonts to query this setting
vim.g.have_nerd_font = true

------------------------------- [VIM Options] -------------------------------

-- Hide fill characters
vim.opt.fillchars = { eob = " " }

-- vertical split to right side so that current file stays in postion
vim.opt.splitright = true

-- ignore case when search with /
vim.opt.ignorecase = true

-- Allow for cross session undo history
vim.opt.undofile = true

-- Fat cursor in insert mode
vim.opt.guicursor = ""

-- Dark vertical guide line for line length limits
vim.opt.colorcolumn = "80"

vim.opt.wrap = false

-- Enable mouse mode
vim.opt.mouse = "a"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Map both neovim registers to the system clipboard
vim.opt.clipboard = "unnamedplus"

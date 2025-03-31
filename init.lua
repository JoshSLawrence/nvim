------------------------------- [VIM Globals] -------------------------------

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NOTE: I have configured plugins that optionally support nerd fonts to query this setting
vim.g.have_nerd_font = true

------------------------------- [VIM Options] -------------------------------

-- Allow for cross session undo history
vim.opt.undofile = true

-- Fat cursor in insert mode
vim.opt.guicursor = ""

vim.opt.colorcolumn = "80"

vim.opt.wrap = false

-- Enable mouse mode
vim.opt.mouse = "a"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.opt.clipboard = "unnamedplus"

------------------------------- [VIM Keymaps] -------------------------------

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Ensures nav keymaps above work intuitively when tmux panes are used
vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Move focus to the upper window" })

------------------------------- [Filetype Mappings] -------------------------------

vim.filetype.add({
	extension = {
		tf = "terraform",
		tfstate = "json",
	},
	pattern = {
		[".*/*.tfstate.backup"] = "json",
	},
})

------------------------------- [Plugin Manager] -------------------------------

require("config.lazy")

------------------------------- [Default Theme] -------------------------------

-- vim.cmd("colorscheme catppuccin-mocha")
vim.cmd("colorscheme tokyonight-night")

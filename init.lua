------------------------------- [VIM Globals] -------------------------------

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NOTE: I have configured plugins that optionally support nerd fonts to query this setting
vim.g.have_nerd_font = true

------------------------------- [VIM Options] -------------------------------

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

------------------------------- [VIM Keymaps] -------------------------------

vim.keymap.set(
	"n",
	"<leader>gg",
	":!tmux new-window -c '" .. vim.fn.getcwd() .. "' -n lazygit lazygit <CR>",
	{ desc = "Lazygit", silent = true }
)

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Ensures nav keymaps above work intuitively when tmux panes are used
vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Move focus to the upper window" })

-- Open terminal in vsplit, bind double escape in terminal mode to return to normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, desc = "Return to normal mode" })
vim.keymap.set("n", "<leader>tt", "<cmd>vsplit | terminal<CR>", { noremap = true, desc = "[C]reate [T]erminal" })

------------------------------- [Auto Commands] -------------------------------

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.html", "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue" },
	callback = function()
		local clients = vim.lsp.get_clients()
		for _, client in ipairs(clients) do
			if client.name == "tailwindcss" then
				vim.cmd("TailwindSort")
				break
			end
		end
	end,
})

------------------------------- [Filetype Mappings] -------------------------------

vim.filetype.add({
	extension = {
		tf = "terraform",
		tfstate = "json",
		hcl = "terraform",
		tmux = "tmux",
	},
	pattern = {
		[".*%.tfstate.backup"] = "json",
		[".*%.env%..*"] = "bash",
	},
	filename = {
		[".aliases"] = "bash",
		[".exports"] = "bash",
	},
})

------------------------------- [Plugin Manager] -------------------------------

require("config.lazy")

------------------------------- [Default Theme] -------------------------------

vim.cmd("colorscheme tokyonight-night")
-- vim.cmd("colorscheme catppuccin-mocha")

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			transparent_background = true,
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
		},
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		opts = {},
	},
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"ayu-theme/ayu-vim",
	},
	{
		-- Follow the OS light/dark setting (macOS, Linux desktops, and WSL).
		-- Owns the active colorscheme: tokyonight-night (dark) / -day (light).
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 1001,
		opts = {
			update_interval = 3000,
			fallback = "dark",
			set_dark_mode = function()
				vim.o.background = "dark"
				vim.cmd("colorscheme tokyonight-night")
			end,
			set_light_mode = function()
				vim.o.background = "light"
				vim.cmd("colorscheme tokyonight-day")
			end,
		},
	},
}

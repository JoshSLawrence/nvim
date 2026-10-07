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
		config = function(_, opts)
			require("tokyonight").setup(opts)
			-- auto-dark-mode applies its theme asynchronously after a dbus
			-- query, so set a default now to avoid starting uncolored.
			vim.cmd("colorscheme tokyonight-night")
		end,
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
		-- Higher priority loads first, so without this the tokyonight
		-- colorscheme isn't on the runtimepath when set_*_mode first fires.
		dependencies = { "folke/tokyonight.nvim" },
		opts = {
			update_interval = 3000,
			fallback = "dark",
			set_dark_mode = function()
				vim.o.background = "dark"
				vim.cmd("colorscheme tokyonight-night")
			end,
			set_light_mode = function()
				vim.o.background = "light"
				vim.cmd("colorscheme tokyonight-night")
			end,
		},
	},
}

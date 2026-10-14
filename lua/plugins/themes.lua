-- auto-dark-mode queries the OS asynchronously, so there is a moment at
-- startup before it knows the appearance. Remember the last result and apply
-- it synchronously when tokyonight loads; auto-dark-mode then corrects it
-- (and updates the file) if the OS setting changed since the last session.
local appearance_file = vim.fn.stdpath("state") .. "/appearance"

---@param mode "dark"|"light"
local function apply_appearance(mode)
	vim.o.background = mode
	vim.cmd("colorscheme " .. (mode == "light" and "tokyonight-day" or "tokyonight-night"))
end

---@return "dark"|"light"|nil mode, or nil when no appearance has been remembered yet
local function remembered_appearance()
	local ok, lines = pcall(vim.fn.readfile, appearance_file)
	if not ok then
		return nil
	end
	return lines[1] == "light" and "light" or "dark"
end

---@param mode "dark"|"light"
local function remember_appearance(mode)
	if remembered_appearance() ~= mode then
		pcall(vim.fn.writefile, { mode }, appearance_file)
	end
end

return {
	-- Only tokyonight is applied at startup (see auto-dark-mode below). The
	-- other colorschemes are lazy and load on demand, e.g. via the Snacks
	-- colorschemes picker (<leader>uC), which scans unloaded plugins too.
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
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
			apply_appearance(remembered_appearance() or "dark")
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		opts = {},
	},
	{
		"webhooked/kanso.nvim",
		lazy = true,
		opts = {},
	},
	{
		"ayu-theme/ayu-vim",
		lazy = true,
	},
	{
		-- Follow the OS light/dark setting (macOS, Linux desktops, and WSL).
		-- Owns the active colorscheme: tokyonight-night (dark) / -day (light).
		-- Loaded after startup; the remembered appearance above covers the gap.
		"f-person/auto-dark-mode.nvim",
		event = "VeryLazy",
		dependencies = { "folke/tokyonight.nvim" },
		opts = {
			update_interval = 3000,
			fallback = "dark",
			set_dark_mode = function()
				apply_appearance("dark")
				remember_appearance("dark")
			end,
			set_light_mode = function()
				apply_appearance("light")
				remember_appearance("light")
			end,
		},
	},
}

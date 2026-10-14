-- Plugin: skanehira/github-actions.nvim
-- Installed via store.nvim

return {
	"skanehira/github-actions.nvim",
	-- telescope.nvim is an optional dependency; without it the plugin falls
	-- back to vim.ui.select, which Snacks provides.
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {},
}

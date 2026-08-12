return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		keys = {
			{ "<leader>td", "<cmd>TodoTelescope<CR>", desc = "[T]o[D]o" },
		},
	},
}

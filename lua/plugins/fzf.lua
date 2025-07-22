return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
    vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua<CR>", {desc = "[F]zf[L]ua"}),
	},
}

return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"github/copilot.vim",
		},
		opts = {
			interactions = {
				chat = {
					adapter = "copilot",
					-- WARNING: Bug with claude-sonnet through GitHub Copilot API
					-- adapter = {
					-- 	name = "copilot",
					-- 	model = "claude-sonnet-4.5",
					-- },
				},
				inline = {
					adapter = "copilot",
					-- WARNING: Bug with claude-sonnet through GitHub Copilot API
					-- adapter = {
					-- name = "copilot",
					-- model = "claude-sonnet-4.5",
					-- },
				},
				-- WARNING: Better of using tmux with opencode in a split / window imo
				cli = {
					agent = "opencode",
					agents = {
						opencode = {
							cmd = "opencode",
							args = {},
							description = "OpenCode",
							provider = "terminal",
						},
					},
				},
			},
			-- NOTE: The log_level is in `opts.opts`
			opts = {
				log_level = "DEBUG", -- or "TRACE"
			},
		},
		vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "[C]ode[C]ompanion [C]hat" }),
		vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true }),
		vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true }),
	},
}

return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		cmd = "Copilot",
		keys = {
			{ "<leader>tc", "<cmd>ToggleCopilot<CR>", desc = "[T]oggle [C]opilot" },
		},
		init = function()
			-- copilot.vim only sets g:copilot_enabled after an explicit
			-- enable/disable, so an unset value means it's on by default.
			-- Defined in init so the command exists before the plugin loads;
			-- running :Copilot triggers the lazy load.
			vim.api.nvim_create_user_command("ToggleCopilot", function()
				if vim.g.copilot_enabled == 0 then
					vim.cmd("Copilot enable")
					vim.notify("Copilot enabled")
				else
					vim.cmd("Copilot disable")
					vim.notify("Copilot disabled")
				end
			end, {})
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"github/copilot.vim",
		},
		cmd = {
			"CodeCompanion",
			"CodeCompanionChat",
			"CodeCompanionActions",
			"CodeCompanionCmd",
			"CodeCompanionCLI",
			"CodeCompanionCodeReview",
		},
		keys = {
			{ "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", desc = "[C]ode[C]ompanion [C]hat" },
			{ "<leader>ca", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
			{ "ga", "<cmd>CodeCompanionChat Add<CR>", mode = "v", desc = "Add selection to CodeCompanion chat" },
		},
		opts = {
			interactions = {
				chat = {
					adapter = {
						name = "copilot",
						model = "claude-sonnet-5",
					},
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
			display = {
				chat = {
					window = {
						buflisted = false, -- List the chat buffer in the buffer list?
						sticky = false, -- Chat window follows when switching tabs (ignored when `pertab` is true)
						pertab = false, -- Treat each tab as having its own chat window?

						layout = "float", -- float|vertical|horizontal|tab|buffer
						full_height = true, -- for vertical layout
						position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)

						-- NOTE: You can set these to 0 for auto width/height
						width = 0.5, ---@return number|fun(): number
						height = 0.5, ---@return number|fun(): number

						border = "single",
						relative = "editor",

						-- Ensure that long paragraphs of markdown are wrapped
						opts = {
							breakindent = true,
							linebreak = true,
							wrap = true,
						},
					},
				},
			},
		},
	},
}

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			model = "claude-sonnet-4.5", -- AI model to use
			temperature = 0.1, -- Lower = focused, higher = creative
			-- auto_insert_mode = true, -- Enter insert mode when opening
			window = {
				layout = "float",
				width = 0.80, -- ratio 0-1 == % whole integers (over 1) == pixels
				height = 0.80, -- ratio 0-1 == % whole integers (over 1) == pixels
				border = "rounded", -- 'single', 'double', 'rounded', 'solid'
				title = "🤖 GitHub Copilot",
				zindex = 100, -- Ensure window stays on top
			},
			headers = {
				user = "👤 You",
				assistant = "🤖 Copilot",
				tool = "🔧 Tool",
			},
			separator = "━━",
			auto_fold = true, -- Automatically folds non-assistant messages
		},
		-- See Commands section for default commands if you want to lazy load on them
		config = function(_, opts)
			local copilot = require("CopilotChat")
			copilot.setup(opts)
			vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Open/Close CopilotChat Window" })
		end,
	},
}

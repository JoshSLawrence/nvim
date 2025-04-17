return {
	{
		"windwp/nvim-ts-autotag",
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false,
		},
		-- Override by filetype:
		-- per_file_type = {
		-- 	["html"] = {
		-- 		enable_close = false,
		-- 	},
		-- },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		-- Optional dependency
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			-- If you want to automatically add `(` after selecting a function or method
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
}

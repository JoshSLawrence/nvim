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
		config = function(_, opts)
			require("nvim-ts-autotag").setup(opts)
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
}

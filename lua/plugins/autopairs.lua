return {
	{
		"windwp/nvim-ts-autotag",
		opts = {
			-- NOTE: This plugin opts layout is odd nested opts > opts,
			-- and opts outside of opts > opts, e.g. opts > per_filetype, opts > enable_close
			opts = {
				-- Defaults
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = false, -- Auto close on trailing </
			},
			-- Also override individual filetype configs, these take priority.
			-- Empty by default, useful if one of the "opts" global settings
			-- doesn't work well in a specific filetype
			per_filetype = {
				["html"] = {
					enable_close = false,
				},
			},
		},
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			opts = {},
		},
	},
}

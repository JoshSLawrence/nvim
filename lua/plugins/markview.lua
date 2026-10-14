return {
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown", "codecompanion" },
		dependencies = { "saghen/blink.cmp" },
		opts = {
			preview = {
				filetypes = { "markdown", "codecompanion" },
				ignore_buftypes = {},
			},
		},
	},
}

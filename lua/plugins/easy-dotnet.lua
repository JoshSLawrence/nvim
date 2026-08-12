return {
	{
		"GustavEikaas/easy-dotnet.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
		opts = {
			picker = "snacks",
		},
		config = function(_, opts)
			require("easy-dotnet").setup(opts)
		end,
	},
}

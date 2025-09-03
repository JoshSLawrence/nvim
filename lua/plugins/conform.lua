return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = false, lsp_fallback = false, timeout_ms = 500 })
				end,
				mode = "",
				desc = "[F]ormat",
			},
		},
		opts = {
			notify_on_error = false,
			formatters = {
				csharpier = {
					command = "csharpier",
					args = { "format", "--write-stdout" },
					stdin = true,
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				terraform = { "terraform_fmt" },
				cs = { "csharpier" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				yml = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				go = { "gofmt", stop_after_first = true },
				["terraform-vars"] = { "terraform_fmt" },
			},
			format_after_save = {
				lsp_format = "never",
				timeout_ms = 500,
			},
		},
	},
}

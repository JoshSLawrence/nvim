return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					terraform = { "terraform_fmt" },
					csharp = { "csharpier" },
				},
				format_on_save = {
					lsp_format = "never",
					async = false,
					timeout_ms = 500,
				},
			})

			vim.keymap.set("n", "<leader>cf", function()
				conform.format({
					lsp_fallback = false,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
	{
		-- NOTE: used to ensure LSP servers are installed via Mason
		-- this shares functionality with mason-tool-installer below mason-tool-installer can be used for this purpose as well
		-- however, I will use mason-lspconfig to install lsp servers
		-- and linters and use mason-tool-installer to install everything else
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"lua_ls",
					"csharp_ls",
					"powershell_es",
					"bashls",
					"terraformls",
				},
				-- NOTE: this is unrelated to "ensure_installed"
				-- Auto installs lsp / linters configured via lspconfig
				-- sounds great... but I have yet to get it to work
				automatic_installation = false,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		opts = {
			servers = {
				lua_ls = {},
				csharp_ls = {},
				powershell_es = {},
				bashls = {},
				terraformls = {},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			vim.lsp.inlay_hint.enable(true)

			---@diagnostic disable-next-line: unused-local
			for server, config in pairs(opts.servers) do
				-- Add blink.cmp to capabilities property of every lsp server defined above in opts
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			end

			-- Run require/setup for every lsp server declared above in opts
			for server, config in pairs(opts.servers) do
				lspconfig[server].setup(config)
			end
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			local installer = require("mason-tool-installer")

			installer.setup({
				ensure_installed = {
					"stylua",
					"csharpier",
					"black",
					"lua_ls",
					"csharp_ls",
					"powershell_es",
					"bashls",
					"terraformls",
					"markdownlint",
				},

				-- NOTE: the integrations below are enabled by default
				-- explicity calling mason-lspconfig so I remain aware
				-- as I am not a fan of implicit defaults
				-- disabling the rest as I use conform over null-ls
				-- and I do not use nvim-dap at this time
				integrations = {
					["mason-lspconfig"] = true,
					["mason-null-ls"] = false,
					["mason-nvim-dap"] = false,
				},
			})
		end,
	},
	{
		-- NOTE: this configures environment for lua dev
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}

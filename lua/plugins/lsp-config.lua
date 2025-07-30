return {
	{
		"qvalentin/helm-ls.nvim",
		ft = "helm",
		opts = {
			{
				conceal_templates = {
					-- enable the replacement of templates with virtual text of their current values
					enabled = true, -- this might change to false in the future
				},
				indent_hints = {
					-- enable hints for indent and nindent functions
					enabled = true,
					-- show the hints only for the line the cursor is on
					only_for_current_line = true,
				},
			},
		},
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
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					registries = {
						"github:mason-org/mason-registry",
						"github:Crashdummyy/mason-registry", -- For C# rosyln language server
					},
				},
			},
			"WhoIsSethDaniel/mason-tool-installer.nvim", -- Only used so that lspconfig names can be used
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			{
				"seblyng/roslyn.nvim",
				ft = "cs",
				---@module 'roslyn.config'
				---@type RoslynNvimConfig
				opts = {},
			},
		},
		opts = {
			servers = {
				lua_ls = {},
				roslyn = {},
				powershell_es = {
					bundle_path = "~/.local/share/nvim/mason/packages/powershell-editor-services/",
				},
				bashls = {},
				terraformls = {},
				ts_ls = {},
				tflint = {},
				eslint = {},
				html = {},
				cssls = {},
				dockerls = {},
				docker_compose_language_service = {},
				pyright = {},
				helm_ls = {},
				yamlls = {},
				gopls = {},
			},
		},
		config = function(_, opts)
			local ensure_installed = vim.tbl_keys(opts.servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"csharpier",
				"black",
				"markdownlint",
				"pyright",
			})

			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
				integrations = {
					-- Only used so that lspconfig names can be used
					["mason-lspconfig"] = true,
					["mason-null-ls"] = false,
					["mason-nvim-dap"] = false,
				},
			})

			for server, config in pairs(opts.servers) do
				local capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})

				-- NOTE: Roslyn language server is handled by the seblyng/roslyn.nvim
				-- plugin above, lspconfig should not enable the server. We have the
				-- server in opts.servers so that mason-tool-installer, installs it.
				-- WARNING: lspconfig refers to roslyn as roslyn_ls if enable is moved
				if server ~= "roslyn" then
					require("lspconfig")[server].setup(config)
				end
			end

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				automatic_enable = false,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local snacks = require("snacks")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client == nil then
						print("Failed to get lsp client")
						return
					end

					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("<leader>lR", vim.lsp.buf.rename, "[R]ename")
					map("<leader>la", vim.lsp.buf.code_action, "Code [A]ction", { "n", "x" })
					map("<leader>lD", vim.lsp.buf.declaration, "[D]eclaration")

					map("<leader>lr", function()
						snacks.picker.lsp_references()
					end, "[R]eferences")

					map("<leader>li", function()
						snacks.picker.lsp_implementations()
					end, "[I]mplementation")

					map("<leader>ld", function()
						snacks.picker.lsp_definitions()
					end, "[G]oto [D]efinition")

					map("<leader>ls", function()
						snacks.picker.lsp_symbols()
					end, "Document [S]ymbols")

					map("<leader>lS", function()
						snacks.picker.lsp_workspace_symbols()
					end, "Workspace [S]ymbols")

					map("<leader>lt", function()
						snacks.picker.lsp_type_definitions()
					end, "[T]ype Definition")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client
						and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>lh", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay [H]ints")
					end
				end,
			})
		end,
	},
}

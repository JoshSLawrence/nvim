return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
			multiwindow = false, -- Enable multiwindow support.
			max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
			min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
			line_numbers = true,
			multiline_threshold = 20, -- Maximum number of lines to show for a single context
			trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
			mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
			-- Separator between context and content. Should be a single character string, like '-'.
			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
			separator = nil,
			zindex = 20, -- The Z-index of the context window
			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		init = function()
			-- Restrict mise-specific TOML injection queries (see
			-- after/queries/toml/injections.scm) to actual mise config
			-- files instead of every TOML file.
			require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
				local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(tonumber(bufnr) or 0))
				local filename = vim.fn.fnamemodify(filepath, ":t")
				return filename:match("^%.?mise.*%.toml$") ~= nil
					or filepath:match("/%.?mise/config%.toml$") ~= nil
					or filepath:match("/%.?mise/config%.local%.toml$") ~= nil
					or filepath:match("/%.?mise/config%.[^/]+%.toml$") ~= nil
					or filepath:match("/%.config/mise/mise%.toml$") ~= nil
					or filepath:match("/%.config/mise/mise%.local%.toml$") ~= nil
					or filepath:match("/%.?mise/conf%.d/[^/]+%.toml$") ~= nil
			end, { force = true, all = false })
		end,
		config = function()
			-- Install parsers using the new API
			require("nvim-treesitter").install({
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"bash",
				"regex",
				"terraform",
				"helm",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"diff",
				"c_sharp",
				"dockerfile",
				"xml",
				"json",
				"yaml",
				"soql",
				"toml",
			})

			-- Enable treesitter highlighting for specific filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"bash",
					"terraform",
					"helm",
					"html",
					"css",
					"tsx",
					"typescript",
					"typescriptreact",
					"javascript",
					"javascriptreact",
					"diff",
					"cs",
					"dockerfile",
					"xml",
					"json",
					"yaml",
					"soql",
					"toml",
				},
				callback = function()
					-- Parsers install asynchronously, so one may be missing on
					-- first launch (or if an install failed). Don't blow up
					-- opening the buffer in that case; just skip highlighting.
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			-- Enable LSP features (hover, completion, diagnostics) for
			-- languages injected into mise.toml `run` commands, e.g. via
			-- after/queries/toml/injections.scm.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "toml" },
				group = vim.api.nvim_create_augroup("EmbedToml", {}),
				callback = function()
					require("otter").activate()
				end,
			})
		end,
	},
}

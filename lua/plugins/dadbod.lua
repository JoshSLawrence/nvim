return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			-- Wired into blink.cmp via the "dadbod" provider in blink.lua
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
				lazy = true,
			},
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
			"DBUIRenameBuffer",
			"DBUILastQueryInfo",
		},
		keys = {
			{ "<leader>db", "<CMD>DBUIToggle<CR>", desc = "Toggle database UI" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			-- Keep saved queries and connections out of the dotfiles repo
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
			vim.g.db_ui_use_nvim_notify = 1
			vim.g.db_ui_winwidth = 40
			-- Default is to execute on every save, which is dangerous for
			-- INSERT/UPDATE/DELETE; run explicitly with <leader>dr instead
			vim.g.db_ui_execute_on_save = 0

			-- Move the buffer-local defaults (<Leader>S/W/E/R) under <leader>d so
			-- all database keys are co-located. Drawer mappings are left alone.
			vim.g.db_ui_disable_mappings_sql = 1
			vim.g.db_ui_disable_mappings_javascript = 1
			vim.g.db_ui_disable_mappings_dbout = 1

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql", "javascript" },
				callback = function(args)
					local function map(mode, lhs, plug, desc)
						vim.keymap.set(mode, lhs, plug, { buffer = args.buf, desc = desc })
					end
					map({ "n", "v" }, "<leader>dr", "<Plug>(DBUI_ExecuteQuery)", "Run query")
					map("n", "<leader>dw", "<Plug>(DBUI_SaveQuery)", "Save query")
					map("n", "<leader>de", "<Plug>(DBUI_EditBindParameters)", "Edit bind parameters")
				end,
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dbout",
				callback = function(args)
					vim.keymap.set("n", "<leader>dl", "<Plug>(DBUI_ToggleResultLayout)", {
						buffer = args.buf,
						desc = "Toggle result layout",
					})
				end,
			})
		end,
	},
}

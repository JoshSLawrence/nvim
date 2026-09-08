------------------------------- [Auto Commands] -------------------------------

local keymaps = require("config.keymaps")

-- Run checktime to detect external file changes. Combined with autoread
-- (on by default), this auto-reloads buffers modified outside Neovim.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "checktime",
})

-- After an external change is detected and the buffer reloads, restart LSP
-- to clear stale semantic tokens. See keymaps.refresh_lsp() for details.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		vim.schedule(keymaps.refresh_lsp)
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.html", "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue" },
	callback = function()
		local clients = vim.lsp.get_clients()
		for _, client in ipairs(clients) do
			if client.name == "tailwindcss" then
				vim.cmd("TailwindSort")
				break
			end
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*.csv" },
	callback = function()
		vim.cmd("CsvViewEnable display_mode=border header_lnum=1")
	end,
})

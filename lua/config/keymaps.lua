------------------------------- [VIM Keymaps] -------------------------------

local M = {}

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Open terminal in vsplit, bind double escape in terminal mode to return to normal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, desc = "Return to normal mode" })
vim.keymap.set("n", "<leader>tt", "<cmd>vsplit | terminal<CR>", { noremap = true, desc = "[C]reate [T]erminal" })

-- Refresh LSP for current buffer. Fixes stale semantic tokens after external
-- file changes (e.g., from AI agents). Discovered with terraformls but may
-- affect other LSP servers that provide semantic tokens.
-- Exported so config.autocmds can reuse it on FileChangedShellPost.
function M.refresh_lsp()
	local buf = vim.api.nvim_get_current_buf()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
		client:stop()
	end
	-- Re-trigger filetype to restart LSP clients via vim.lsp.enable
	local ft = vim.bo[buf].filetype
	vim.bo[buf].filetype = ""
	vim.schedule(function()
		vim.bo[buf].filetype = ft
	end)
end

vim.keymap.set("n", "<leader>uH", M.refresh_lsp, { desc = "Refresh LSP" })

return M

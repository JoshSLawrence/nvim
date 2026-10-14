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

-- Re-request semantic tokens for a buffer. Fixes stale highlighting after
-- external file changes (e.g., from AI agents). Discovered with terraformls
-- but may affect other LSP servers that provide semantic tokens.
--
-- This deliberately does not restart clients: a client is usually shared by
-- several buffers, and stopping it detaches it from all of them (they only
-- re-attach on FileType). Use :LspRestart for a full restart.
-- Exported so config.autocmds can reuse it on FileChangedShellPost.
function M.refresh_lsp(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end
	vim.lsp.semantic_tokens.force_refresh(bufnr)
end

vim.keymap.set("n", "<leader>uH", function()
	M.refresh_lsp()
end, { desc = "Refresh LSP semantic tokens" })

return M

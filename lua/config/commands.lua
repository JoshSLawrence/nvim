------------------------------- [Manual Commands] -------------------------------

vim.api.nvim_create_user_command("GhosttyConfig", function()
	vim.cmd("edit $XDG_CONFIG_HOME/ghostty/config")
end, {})

vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("checkhealth vim.lsp")
end, {})

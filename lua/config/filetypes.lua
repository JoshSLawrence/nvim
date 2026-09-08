------------------------------- [Filetype Mappings] -------------------------------

vim.filetype.add({
	extension = {
		tf = "terraform",
		tfstate = "json",
		hcl = "terraform",
		tmux = "tmux",
	},
	pattern = {
		[".*%.tfstate.backup"] = "json",
		[".*%.env%..*"] = "bash",
		[".*/.config/ghostty/config"] = "ghostty",
	},
	filename = {
		[".aliases"] = "bash",
		[".exports"] = "bash",
		[".exports_ignored"] = "bash",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "ghostty",
	callback = function()
		vim.bo.commentstring = "# %s"
	end,
})

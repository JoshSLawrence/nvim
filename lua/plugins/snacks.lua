-- Wrap a Snacks.picker source so keymaps can reference it concisely.
local function pick(name, opts)
	return function()
		Snacks.picker[name](opts)
	end
end

-- Shuffle bag: draw quips without replacement, persisted across launches, so
-- every quip shows once per cycle and none repeats back-to-back.
local function random_header()
	local quips = require("config.quips")
	local path = vim.fn.stdpath("state") .. "/quips_bag.json"
	-- Seed explicitly so the shuffle differs per launch regardless of Neovim's default.
	math.randomseed(vim.uv.hrtime())

	local state = {}
	local ok, lines = pcall(vim.fn.readfile, path)
	if ok then
		local decoded_ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
		if decoded_ok and type(decoded) == "table" then
			state = decoded
		end
	end

	-- A changed quip count means the saved indices are stale (quips added or
	-- removed), so start a fresh bag instead of trusting them.
	local bag = state.bag
	if type(bag) ~= "table" or state.count ~= #quips then
		bag = {}
	end

	if #bag == 0 then
		for i = 1, #quips do
			bag[i] = i
		end
		for i = #bag, 2, -1 do
			local j = math.random(i)
			bag[i], bag[j] = bag[j], bag[i]
		end
		-- Draws pop from the end; keep the last-shown quip from leading the new cycle.
		if #bag > 1 and bag[#bag] == state.last then
			bag[#bag], bag[1] = bag[1], bag[#bag]
		end
	end

	local pick = table.remove(bag)
	pcall(vim.fn.writefile, { vim.json.encode({ bag = bag, last = pick, count = #quips }) }, path)
	return quips[pick]
end

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = {

				enabled = true,
				width = 60,
				row = nil, -- dashboard position. nil for center
				col = nil, -- dashboard position. nil for center
				pane_gap = 4, -- empty columns between vertical panes
				autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
				-- These settings are used by some built-in sections
				preset = {
					-- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
					---@type fun(cmd:string, opts:table)|nil
					pick = nil,
					-- Used by the `keys` section to show keymaps.
					-- Set your custom keymaps here.
					-- When using a function, the `items` argument are the default keymaps.
					---@type snacks.dashboard.Item[]
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{
							icon = "󰒲 ",
							key = "L",
							desc = "Lazy",
							action = ":Lazy",
							enabled = package.loaded.lazy ~= nil,
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
					-- Used by the `header` section
					header = random_header(),
				},
				-- item field formatters
				formats = {
					icon = function(item)
						if item.file and item.icon == "file" or item.icon == "directory" then
							return Snacks.dashboard.icon(item.file, item.icon)
						end
						return { item.icon, width = 2, hl = "icon" }
					end,
					footer = { "%s", align = "center" },
					header = { "%s", align = "center" },
					file = function(item, ctx)
						local fname = vim.fn.fnamemodify(item.file, ":~")
						fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
						if #fname > ctx.width then
							local dir = vim.fn.fnamemodify(fname, ":h")
							local file = vim.fn.fnamemodify(fname, ":t")
							if dir and file then
								file = file:sub(-(ctx.width - #dir - 2))
								fname = dir .. "/…" .. file
							end
						end
						local dir, file = fname:match("^(.*)/(.+)$")
						return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
							or { { fname, hl = "file" } }
					end,
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
			explorer = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
				top_down = false,
			},
			picker = {
				enabled = true,
				layout = { preset = "select" },
				win = {
					input = {
						keys = {
							["<c-o>"] = { "edit_vsplit", mode = { "i", "n" } },
						},
					},
					list = {
						keys = {
							["<c-o>"] = "edit_vsplit",
						},
					},
				},
				sources = {
					files = {
						hidden = true,
						ignored = true,
					},
					explorer = {
						hidden = true,
						ignored = true,
						win = {
							input = {
								keys = {
									["<c-t>"] = { "tab", mode = { "i", "n" } },
								},
							},
							list = {
								keys = {
									["<c-t>"] = "tab",
								},
							},
						},
						layout = { layout = { position = "right" } },
					},
					todo_comments = {
						on_show = function(picker)
							picker.input.statuscolumn = function()
								return "%#SnacksPickerPrompt# %*"
							end
						end,
					},
				},
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = false },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},
		keys = {
			-- Top Pickers & Explorer
			{ "<leader><space>", pick("smart"), desc = "Smart Find Files" },
			{ "<leader>,", pick("buffers"), desc = "Buffers" },
			{ "<leader>/", pick("grep"), desc = "Grep" },
			{ "<leader>:", pick("command_history"), desc = "Command History" },
			{
				"<leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
			-- find
			{ "<leader>fb", pick("buffers"), desc = "Buffers" },
			{ "<leader>fc", pick("files", { cwd = vim.fn.stdpath("config") }), desc = "Find Config File" },
			{ "<leader>ff", pick("files"), desc = "Find Files" },
			{ "<leader>fg", pick("git_files"), desc = "Find Git Files" },
			{ "<leader>fp", pick("projects"), desc = "Projects" },
			{ "<leader>fr", pick("recent"), desc = "Recent" },
			-- git
			{ "<leader>gb", pick("git_branches"), desc = "Git Branches" },
			{ "<leader>gl", pick("git_log"), desc = "Git Log" },
			{ "<leader>gL", pick("git_log_line"), desc = "Git Log Line" },
			{ "<leader>gs", pick("git_status"), desc = "Git Status" },
			{ "<leader>gS", pick("git_stash"), desc = "Git Stash" },
			{ "<leader>gd", pick("git_diff"), desc = "Git Diff (Hunks)" },
			{ "<leader>gf", pick("git_log_file"), desc = "Git Log File" },
			-- Grep
			{ "<leader>sb", pick("lines"), desc = "Buffer Lines" },
			{ "<leader>sB", pick("grep_buffers"), desc = "Grep Open Buffers" },
			{ "<leader>sg", pick("grep"), desc = "Grep" },
			{ "<leader>sw", pick("grep_word"), desc = "Visual selection or word", mode = { "n", "x" } },
			-- search
			{ '<leader>s"', pick("registers"), desc = "Registers" },
			{ "<leader>s/", pick("search_history"), desc = "Search History" },
			{ "<leader>sa", pick("autocmds"), desc = "Autocmds" },
			{ "<leader>sc", pick("command_history"), desc = "Command History" },
			{ "<leader>sC", pick("commands"), desc = "Commands" },
			{ "<leader>sd", pick("diagnostics"), desc = "Diagnostics" },
			{ "<leader>sD", pick("diagnostics_buffer"), desc = "Buffer Diagnostics" },
			{ "<leader>sh", pick("help"), desc = "Help Pages" },
			{ "<leader>sH", pick("highlights"), desc = "Highlights" },
			{ "<leader>si", pick("icons"), desc = "Icons" },
			{ "<leader>sj", pick("jumps"), desc = "Jumps" },
			{ "<leader>sk", pick("keymaps"), desc = "Keymaps" },
			{ "<leader>sl", pick("loclist"), desc = "Location List" },
			{ "<leader>sm", pick("marks"), desc = "Marks" },
			{ "<leader>sM", pick("man"), desc = "Man Pages" },
			{ "<leader>sp", pick("lazy"), desc = "Search for Plugin Spec" },
			{ "<leader>sq", pick("qflist"), desc = "Quickfix List" },
			{ "<leader>sR", pick("resume"), desc = "Resume" },
			{ "<leader>su", pick("undo"), desc = "Undo History" },
			{ "<leader>uC", pick("colorschemes"), desc = "Colorschemes" },
			-- Other
			{
				"<leader>z",
				function()
					Snacks.zen()
				end,
				desc = "Toggle Zen Mode",
			},
			{
				"<leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},
			{
				"<leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>cR",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Rename File",
			},
			{
				"<leader>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse",
				mode = { "n", "v" },
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
			{
				"<c-/>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},
			{
				"<c-_>",
				function()
					Snacks.terminal()
				end,
				desc = "which_key_ignore",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},
			{
				"<leader>N",
				desc = "Neovim News",
				function()
					Snacks.win({
						file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							signcolumn = "yes",
							statuscolumn = " ",
							conceallevel = 3,
						},
					})
				end,
			},
		},
		init = function()
			vim.api.nvim_set_keymap(
				"n",
				"<leader>q",
				":lua vim.diagnostic.open_float()<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					Snacks.toggle.inlay_hints():map("<leader>uh")
					Snacks.toggle.indent():map("<leader>ug")
					Snacks.toggle.dim():map("<leader>uD")
				end,
			})
		end,
	},
}

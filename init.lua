-- Load order matters:
--   1. options    - sets leader keys; MUST run before lazy loads plugins so
--                   their mappings use the correct leader.
--   2. keymaps    - defines refresh_lsp, which autocmds depends on.
--   3. autocmds   - requires config.keymaps.
--   4. filetypes  - filetype detection + related autocmds.
--   5. lazy       - bootstraps and loads all plugins.
--   6. tailwind-sort - custom command setup (independent of plugins).
--   7. colorscheme - MUST run after lazy so the theme plugin is installed.
--   8. commands   - user commands (order-independent).

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.filetypes")

require("config.lazy")

require("config.tailwind-sort").setup()

------------------------------- [Default Theme] -------------------------------

-- The colorscheme is owned by auto-dark-mode.nvim (see lua/plugins/themes.lua),
-- which follows the OS appearance: tokyonight-night (dark) / tokyonight-day
-- (light). It runs during lazy setup above, so no colorscheme is set here.

require("config.commands")

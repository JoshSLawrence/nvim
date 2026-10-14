# nvim

My personal Neovim configuration (part of my dotfiles —
[joshslawrence/dotfiles](https://github.com/joshslawrence/dotfiles)).

## Requirements

- Neovim 0.12.0+
- A [Nerd Font](https://www.nerdfonts.com/) (the config sets
  `vim.g.have_nerd_font = true`)
- `git` (used to bootstrap lazy.nvim)
- A C compiler. Treesitter compiles its parsers from source, so without
  a compiler on your `PATH` the parsers will fail to build and
  Treesitter features will not work.

LSP servers, formatters, and linters are installed automatically via
[mason.nvim](https://github.com/mason-org/mason.nvim) on first launch
(stylua, prettierd, csharpier, black, markdownlint, and the language
servers configured in `lua/plugins/lsp-config.lua`).

## Structure

```text
.
├── init.lua              # Thin loader; documents module load order
├── lazy-lock.json        # Pinned plugin versions
├── lua/
│   ├── config/           # Core editor config (options, keymaps, autocmds…)
│   └── plugins/          # Feature-grouped lazy.nvim specs
└── queries/              # Custom Treesitter queries
```

Files under `lua/plugins/` are grouped by topic rather than strictly one
plugin per file (e.g. `themes.lua` holds all colorschemes, and some
specs bundle a plugin with its companions).

## Notable choices

- [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management
- [snacks.nvim](https://github.com/folke/snacks.nvim) as the picker,
  explorer, and general UI layer
- Transparent [tokyonight](https://github.com/folke/tokyonight.nvim), switched
  between `tokyonight-night` and `tokyonight-day` by
  [auto-dark-mode.nvim](https://github.com/f-person/auto-dark-mode.nvim) to
  follow the OS appearance
- A small custom Tailwind class sorter in
  `lua/config/tailwind-sort.lua`

## Development

Formatting and whitespace are enforced with
[pre-commit](https://pre-commit.com). The StyLua hook runs the `stylua`
binary that mason installs, so make sure `~/.local/share/nvim/mason/bin`
is on your `PATH`, then:

```sh
pre-commit install
pre-commit run --all-files
```

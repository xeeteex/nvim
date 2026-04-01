# Neovim Config

`mapleader` is set to `Space`, so `<leader>a` means `Space` then `a`.

## Theme

The colorscheme is currently the default Kanagawa theme:

```vim
:colorscheme kanagawa
```

If you want the darker built-in variant:

```vim
:colorscheme kanagawa-dragon
```

## Current Features

- Kanagawa colorscheme
- Telescope file/buffer/help search
- Harpoon file list and Telescope integration
- Fugitive Git workflow
- Git change signs in the gutter
- Treesitter highlighting and incremental selection
- Built-in LSP setup for Python, JavaScript, TypeScript, Lua, CSS, and JSON
- `nvim-cmp` completion popup
- GitHub Copilot as a completion source
- LuaSnip snippet support

## General

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>q` | Normal | Open `netrw` file explorer |
| `J` | Visual | Move selected lines down |
| `K` | Visual | Move selected lines up |
| `J` | Normal | Join line below and keep cursor centered |
| `<C-d>` | Normal | Half-page down and keep cursor centered |
| `<C-u>` | Normal | Half-page up and keep cursor centered |
| `n` | Normal | Next search result and keep centered |
| `N` | Normal | Previous search result and keep centered |
| `<leader>p` | Visual | Paste without replacing unnamed register |
| `<C-c>` | Insert | Exit insert mode |
| `<leader>y` | Normal | Yank to system clipboard |
| `<leader>y` | Visual | Yank selection to system clipboard |
| `<leader>Y` | Normal | Yank line to system clipboard |
| `<` | Visual | Indent left and keep selection |
| `>` | Visual | Indent right and keep selection |
| `<C-c>` | Normal | Clear search highlight |

## Telescope

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fb` | Normal | List open buffers |
| `<leader>fh` | Normal | Search help tags |

## Harpoon

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>a` | Normal | Add current file to Harpoon |
| `<C-e>` | Normal | Toggle Harpoon quick menu |
| `<C-p>` | Normal | Go to previous Harpoon file |
| `<C-n>` | Normal | Go to next Harpoon file |
| `<leader>fl` | Normal | Open Harpoon list in Telescope |

## Git With Fugitive

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>gs` | Normal | Open Git status |
| `<leader>gd` | Normal | Open diff split |
| `<leader>gb` | Normal | Open blame view |
| `<leader>gc` | Normal | Start `Git commit` |
| `<leader>gp` | Normal | Run `Git push` |
| `<leader>gl` | Normal | Run `Git pull` |
| `<leader>gw` | Normal | Stage current file with `:Gwrite` |
| `<leader>gr` | Normal | Reset current file with `:Gread` |

Inside Fugitive status, there are more built-in keys. The most useful are:

| Shortcut | Action |
| --- | --- |
| `-` | Stage or unstage item under cursor |
| `=` | Toggle inline diff for item under cursor |
| `cc` | Commit |
| `dv` | Vertical diff split |
| `dh` | Horizontal diff split |

## Git Signs

Git gutter markers:
- green = added lines
- blue = changed lines
- red = deleted lines

| Shortcut | Mode | Action |
| --- | --- | --- |
| `]h` | Normal | Next git hunk |
| `[h` | Normal | Previous git hunk |
| `<leader>hp` | Normal | Preview git hunk |
| `<leader>hs` | Normal | Stage git hunk |
| `<leader>hr` | Normal | Reset git hunk |
| `<leader>hb` | Normal | Toggle current line blame |

## LSP

| Shortcut | Mode | Action |
| --- | --- | --- |
| `K` | Normal | Hover documentation |
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `gi` | Normal | Go to implementation |
| `go` | Normal | Go to type definition |
| `gr` | Normal | List references |
| `gs` | Normal | Signature help |
| `gl` | Normal | Show line diagnostics |
| `<F2>` | Normal | Rename symbol |
| `<F3>` | Normal / Visual | Format buffer or selection |
| `<F4>` | Normal | Code action |

## Completion

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<C-Space>` | Insert | Open completion menu |
| `<C-e>` | Insert | Cancel completion |
| `<CR>` | Insert | Confirm selected completion |
| `<Tab>` | Insert / Select | Next completion item or expand snippet |
| `<S-Tab>` | Insert / Select | Previous completion item or jump backward in snippet |
| `<C-b>` | Insert | Scroll completion docs up |
| `<C-f>` | Insert | Scroll completion docs down |

Completion sources in the popup:
- `LSP`
- `Copilot`
- `buffer`
- `path`
- `LuaSnip`

Typical autocomplete stack:
- Python: `pyright` + `nvim-cmp` + optional Copilot
- JavaScript / TypeScript / JSX / TSX: `ts_ls` + `nvim-cmp` + optional Copilot
- Lua: `lua_ls` + `nvim-cmp`
- CSS / JSON: `cssls` and `jsonls`

## Treesitter

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<C-Space>` | Normal / Visual | Start incremental selection |
| `<C-Space>` | Normal / Visual | Expand to next node |
| `<C-s>` | Normal / Visual | Expand to current scope |
| `<M-Space>` | Normal / Visual | Shrink selection |

Some terminals do not pass these keys correctly. If they do not work, remap them.

## Other Plugins

| Shortcut | Mode | Action |
| --- | --- | --- |
| `<leader>u` | Normal | Toggle Undotree |

## Setup Checks

Use these commands inside Neovim to confirm plugins are working:

```vim
:Lazy
:checkhealth
:checkhealth vim.lsp
:checkhealth cmp
:LspInfo
:Telescope find_files
:TSInstallInfo
:InspectTree
:Git
:Copilot status
```

Useful maintenance commands:

```vim
:Lazy sync
:TSUpdate
:Copilot auth
```

## Quick Start

After changing plugin config, run:

```vim
:Lazy sync
```

Then restart Neovim.

To verify Python autocomplete:

1. Open a `.py` file.
2. Run `:LspInfo` and confirm `pyright` is attached.
3. Type something like `str.` or `os.` and check that the completion menu opens.

To verify JS / JSX / TS / TSX autocomplete:

1. Open a `.js`, `.jsx`, `.ts`, or `.tsx` file.
2. Run `:LspInfo` and confirm `ts_ls` is attached.
3. Type on an object or import path and check the completion menu.

To verify Copilot:

1. Run `:Copilot auth`
2. Sign in with your GitHub account
3. Open a supported file and check that `[Copilot]` appears in completion results

## LSP Server Binaries

The Neovim config currently enables these servers, and you still need the binaries installed on your system:

```text
lua-language-server
pyright-langserver
typescript
typescript-language-server
vscode-css-language-server
vscode-json-language-server
node
```

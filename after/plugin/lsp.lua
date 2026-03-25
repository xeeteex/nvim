local capabilities = vim.lsp.protocol.make_client_capabilities()

do
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
end

vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = capabilities,
})

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    style = "minimal",
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "»",
    },
  },
})

local orig = vim.lsp.util.open_floating_preview

---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  opts.max_width = opts.max_width or 80
  opts.max_height = opts.max_height or 24
  opts.wrap = opts.wrap ~= false
  return orig(contents, syntax, opts, ...)
end

local lsp_attach_group = vim.api.nvim_create_augroup("chichi.lsp", { clear = true })
local lsp_highlight_group = vim.api.nvim_create_augroup("chichi.lsp.highlight", { clear = false })
local lsp_format_group = vim.api.nvim_create_augroup("chichi.lsp.format", { clear = false })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_attach_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local buf = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
    end

    map("n", "K", vim.lsp.buf.hover, "LSP hover")
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
    map("n", "gr", vim.lsp.buf.references, "List references")
    map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
    map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
    map({ "n", "x" }, "<F3>", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")
    map("n", "<F4>", vim.lsp.buf.code_action, "Code action")

    if client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_clear_autocmds({ group = lsp_highlight_group, buffer = buf })

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = buf,
        group = lsp_highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = buf,
        group = lsp_highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
    end

    local excluded_filetypes = { php = true, c = true, cpp = true }
    if not client:supports_method("textDocument/willSaveWaitUntil")
      and client:supports_method("textDocument/formatting")
      and not excluded_filetypes[vim.bo[buf].filetype]
    then
      vim.api.nvim_clear_autocmds({ group = lsp_format_group, buffer = buf })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = lsp_format_group,
        buffer = buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

vim.lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = { enable = false },
    },
  },
}

vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
}

vim.lsp.config.cssls = {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}

vim.lsp.config.intelephense = {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  root_markers = { "composer.json", ".git" },
  settings = {
    intelephense = {
      files = {
        maxSize = 5000000,
      },
    },
  },
}

vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  settings = {
    completions = {
      completeFunctionCalls = true,
    },
  },
}

vim.lsp.config.zls = {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "zls.json", "build.zig", ".git" },
  settings = {
    zls = {
      enable_build_on_save = true,
      build_on_save_step = "install",
      warn_style = false,
      enable_snippets = true,
    },
  },
}

vim.lsp.config.nil_ls = {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "default.nix", ".git" },
  settings = {
    ["nil"] = {
      formatting = {
        command = { "alejandra" },
      },
    },
  },
}

vim.lsp.config.rust_analyzer = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      formatting = {
        command = { "rustfmt" },
      },
    },
  },
}

vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--query-driver=/nix/store/*-gcc-*/bin/gcc*,/nix/store/*-clang-*/bin/clang*,/run/current-system/sw/bin/cc*",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", ".clangd", "configure.ac", "Makefile", ".git" },
  init_options = {
    fallbackFlags = { "-std=c23" },
  },
}

vim.lsp.config.c3_lsp = {
  cmd = { "c3-lsp" },
  filetypes = { "c3" },
  root_markers = { "project.json", ".git" },
}

vim.lsp.config.serve_d = {
  cmd = { "serve-d" },
  filetypes = { "d" },
  root_markers = { "dub.sdl", "dub.json", ".git" },
}

vim.lsp.config.jsonls = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git", "config.jsonc" },
}

vim.lsp.config.hls = {
  cmd = { "haskell-language-server-wrapper", "--lsp" },
  filetypes = { "haskell", "lhaskell" },
  root_markers = { "stack.yaml", "cabal.project", "package.yaml", "*.cabal", "hie.yaml", ".git" },
  settings = {
    haskell = {
      formattingProvider = "fourmolu",
      plugin = {
        semanticTokens = { globalOn = false },
      },
    },
  },
}

vim.lsp.config.gopls = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.work", ".git" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = false,
        ST1003 = false,
        ST1000 = false,
      },
      staticcheck = true,
    },
  },
}

vim.lsp.config.templ = {
  cmd = { "templ", "lsp" },
  filetypes = { "templ" },
  root_markers = { "go.mod", ".git" },
}

vim.filetype.add({
  extension = {
    h = "c",
    c3 = "c3",
    d = "d",
    templ = "templ",
  },
})

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "cssls",
  "intelephense",
  "ts_ls",
  "zls",
  "nil_ls",
  "rust_analyzer",
  "clangd",
  "c3_lsp",
  "serve_d",
  "jsonls",
  "hls",
  "gopls",
  "templ",
})

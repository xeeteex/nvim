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

    if not client:supports_method("textDocument/willSaveWaitUntil")
      and client:supports_method("textDocument/formatting")
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

local function find_uv_workspace_root(start_dir)
  local normalized = vim.fs.normalize(start_dir)
  local dirs = { normalized }

  for parent in vim.fs.parents(normalized) do
    table.insert(dirs, parent)
  end

  for _, dir in ipairs(dirs) do
    local pyproject = dir .. "/pyproject.toml"
    if vim.fn.filereadable(pyproject) == 1 then
      for _, line in ipairs(vim.fn.readfile(pyproject)) do
        if line:match("^%[tool%.uv%.workspace%]") then
          return dir
        end
      end
    end
  end

  return nil
end

local function is_uv_workspace_member(workspace_root, project_root)
  local pyproject = workspace_root .. "/pyproject.toml"
  if vim.fn.filereadable(pyproject) == 0 then
    return false
  end

  local relative_project = vim.fs.relpath(workspace_root, project_root)
  if not relative_project then
    return false
  end

  local in_workspace_section = false

  for _, line in ipairs(vim.fn.readfile(pyproject)) do
    if line:match("^%[tool%.uv%.workspace%]") then
      in_workspace_section = true
    elseif in_workspace_section and line:match("^%[.+%]") then
      break
    elseif in_workspace_section then
      for member in line:gmatch('"([^"]+)"') do
        if member == relative_project then
          return true
        end
      end
    end
  end

  return false
end

local function get_python_path(root_dir)
  local venv_python = root_dir .. "/.venv/bin/python"
  local workspace_root = find_uv_workspace_root(root_dir)

  if workspace_root and workspace_root ~= root_dir and is_uv_workspace_member(workspace_root, root_dir) then
    local workspace_python = workspace_root .. "/.venv/bin/python"
    if vim.fn.executable(workspace_python) == 1 then
      return workspace_python
    end
  end

  if vim.fn.executable(venv_python) == 1 then
    return venv_python
  end

  if vim.env.VIRTUAL_ENV then
    local active_python = vim.env.VIRTUAL_ENV .. "/bin/python"
    if vim.fn.executable(active_python) == 1 then
      return active_python
    end
  end

  if vim.fn.executable("python3") == 1 then
    return vim.fn.exepath("python3")
  end

  return vim.fn.exepath("python")
end

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
  before_init = function(_, config)
    local root_dir = config.root_dir or vim.fn.getcwd()
    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = get_python_path(root_dir)
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        extraPaths = { "." },
      },
    },
  },
}

vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  settings = {
    completions = {
      completeFunctionCalls = true,
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

vim.lsp.config.jsonls = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git", "config.jsonc" },
}

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ts_ls",
  "cssls",
  "jsonls",
})

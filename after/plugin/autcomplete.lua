local ok_npairs, npairs = pcall(require, "nvim-autopairs")
if not ok_npairs then
  return
end

local ok_rule, Rule = pcall(require, "nvim-autopairs.rule")
if not ok_rule then
  return
end

npairs.setup({
  check_ts = true,
  ts_config = {
    lua = { "string" },
    javascript = { "template_string" },
    java = false,
  },
})

local ok_ts_conds, ts_conds = pcall(require, "nvim-autopairs.ts-conds")
if ok_ts_conds then
  npairs.add_rules({
    Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
    Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
  })
end

local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then
  return
end

local ok_luasnip, luasnip = pcall(require, "luasnip")
if not ok_luasnip then
  return
end

require("luasnip.loaders.from_vscode").lazy_load()

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end

  local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return current_line:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
  formatting = {
    format = function(entry, vim_item)
      local source_labels = {
        copilot = "[Copilot]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        path = "[Path]",
        buffer = "[Buf]",
      }

      vim_item.menu = source_labels[entry.source.name]
      return vim_item
    end,
  },
})

local ok_cmp_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if ok_cmp_autopairs then
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

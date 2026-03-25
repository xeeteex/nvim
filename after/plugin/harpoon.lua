local ok, harpoon = pcall(require, "harpoon")
if not ok then
  return
end

harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Harpoon add file" })

vim.keymap.set("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })

vim.keymap.set("n", "<C-p>", function()
  harpoon:list():prev()
end, { desc = "Harpoon previous" })

vim.keymap.set("n", "<C-n>", function()
  harpoon:list():next()
end, { desc = "Harpoon next" })

vim.keymap.set("n", "<leader>fl", function()
  local ok_config, telescope_config = pcall(require, "telescope.config")
  local ok_themes, telescope_themes = pcall(require, "telescope.themes")
  local ok_pickers, telescope_pickers = pcall(require, "telescope.pickers")
  local ok_finders, telescope_finders = pcall(require, "telescope.finders")

  if not (ok_config and ok_themes and ok_pickers and ok_finders) then
    vim.notify("Telescope is not available", vim.log.levels.WARN)
    return
  end

  local file_paths = {}
  for _, item in ipairs(harpoon:list().items) do
    table.insert(file_paths, item.value)
  end

  telescope_pickers.new(telescope_themes.get_ivy({ prompt_title = "Working List" }), {
    finder = telescope_finders.new_table({ results = file_paths }),
    previewer = telescope_config.values.file_previewer({}),
    sorter = telescope_config.values.generic_sorter({}),
  }):find()
end, { desc = "Open Harpoon window" })

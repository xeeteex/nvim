local ok_copilot, copilot = pcall(require, "copilot")
if not ok_copilot then
  return
end

copilot.setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = {
    markdown = true,
    help = false,
  },
})

local ok_copilot_cmp, copilot_cmp = pcall(require, "copilot_cmp")
if not ok_copilot_cmp then
  return
end

copilot_cmp.setup()

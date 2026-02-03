-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remap 0 to go to the first non-blank character (like ^)
-- If already there, it goes to the absolute start (like the default 0)
vim.keymap.set("n", "0", function()
  local line_str = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local first_non_blank = string.find(line_str, "%S")

  -- Handle empty lines safely
  if first_non_blank == nil then
    vim.cmd("normal! 0")
    return
  end

  -- Lua string.find is 1-indexed, nvim cursor is 0-indexed

  if col == first_non_blank - 1 then
    vim.cmd("normal! 0")
  else
    vim.cmd("normal! ^")
  end
end, { desc = "Smart Start of Line" })

vim.keymap.set('i', 'jk', '<ESC>')

-- Move in vim if possible, otherwise ask tmux to move
local function move_or_tmux(direction)
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. direction)

  if cur_win == vim.api.nvim_get_current_win() then
    -- We're still in the same window, must be at the edge
    local tmux_dir = {
      h = "L",
      j = "D",
      k = "U",
      l = "R"
    }
    vim.fn.system({'tmux', 'select-pane', '-' .. tmux_dir[direction]})
  end
end

-- Keybindings for Ctrl-h/j/k/l
vim.keymap.set('n', '<C-h>', function() move_or_tmux('h') end, { silent = true, noremap = true })
vim.keymap.set('n', '<C-j>', function() move_or_tmux('j') end, { silent = true, noremap = true })
vim.keymap.set('n', '<C-k>', function() move_or_tmux('k') end, { silent = true, noremap = true })
vim.keymap.set('n', '<C-l>', function() move_or_tmux('l') end, { silent = true, noremap = true })


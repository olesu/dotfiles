-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use dotfiles venv for Neovim's Python provider (must have pynvim installed)
vim.g.python3_host_prog = vim.fn.expand("~/.dotfiles/.venv/bin/python")

-- Allow Prettier to run without a local config file
vim.g.lazyvim_prettier_needs_config = false

-- Use dotfiles venv for Neovim (has pynvim installed)
-- LSP servers and project tools will automatically detect project .venv
vim.g.python3_host_prog = vim.fn.expand('~/.dotfiles/.venv/bin/python')

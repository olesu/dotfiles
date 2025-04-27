vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4	
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

vim.g.mapleader = ' '

vim.cmd('colorscheme desert')

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e1e", fg = "#ffffff" })

vim.api.nvim_create_user_command('TestConfig', function()
    require('plenary.test_harness').test_directory('~/.config/nvim/tests', { minimal_init = 'init.lua' })
end, {})


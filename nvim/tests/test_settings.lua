local assert = require('plenary.assert')
local it = require('plenary.test.harness').it

it('should have line numbers enabled', function()
    assert.equals(true, vim.opt.number:get())
end)

it('should use 4 spaces for a tab', function()
    assert.equals(4, vim.opt.tabstop:get())
    assert.equals(true, vim.opt.expandtab:get())
end)

it('should have <leader> as space', function()
    assert.equals(' ', vim.g.mapleader)
end)


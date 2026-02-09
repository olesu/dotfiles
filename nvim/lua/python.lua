-- Try local .venv first, then fall back to dotfiles venv
local venv_paths = {
    vim.fn.getcwd() .. '/.venv/bin/python',
    vim.fn.expand('~/.dotfiles/.venv/bin/python'),
}

for _, path in ipairs(venv_paths) do
    if vim.fn.filereadable(path) == 1 then
        vim.g.python3_host_prog = path
        break
    end
end

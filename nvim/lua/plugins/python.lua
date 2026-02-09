return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        settings = {
          python = {
            venvPath = ".",
            pythonPath = ".venv/bin/python",
          },
        },
      },
    },
  },
}

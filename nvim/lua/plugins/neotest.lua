return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {},
        ["neotest-python"] = {
          dap = { justMyCode = false },
        },
      },
    },
  },
}

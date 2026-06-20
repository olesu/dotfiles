return {
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("xcodebuild").setup()

      local map = vim.keymap.set
      map("n", "<leader>X",  "<cmd>XcodebuildPicker<cr>",            { desc = "Xcodebuild Actions" })
      map("n", "<leader>Xi", "<cmd>XcodebuildSetup<cr>",             { desc = "Setup Wizard" })
      map("n", "<leader>Xb", "<cmd>XcodebuildBuild<cr>",             { desc = "Build" })
      map("n", "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>",          { desc = "Build & Run" })
      map("n", "<leader>Xt", "<cmd>XcodebuildTest<cr>",              { desc = "Run Tests" })
      map("n", "<leader>XT", "<cmd>XcodebuildTestClass<cr>",         { desc = "Run This File's Tests" })
      map("n", "<leader>Xl", "<cmd>XcodebuildToggleLogs<cr>",        { desc = "Toggle Build Logs" })
      map("n", "<leader>Xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Test Explorer" })
      map("n", "<leader>Xs", "<cmd>XcodebuildSelectScheme<cr>",      { desc = "Select Scheme" })
    end,
  },
}

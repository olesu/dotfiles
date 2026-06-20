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
      map("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>",             { desc = "Build" })
      map("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>",          { desc = "Build & Run" })
      map("n", "<leader>xt", "<cmd>XcodebuildTest<cr>",              { desc = "Run Tests" })
      map("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>",         { desc = "Run This File's Tests" })
      map("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>",        { desc = "Toggle Build Logs" })
      map("n", "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Test Explorer" })
      map("n", "<leader>xs", "<cmd>XcodebuildSelectScheme<cr>",      { desc = "Select Scheme" })
    end,
  },
}

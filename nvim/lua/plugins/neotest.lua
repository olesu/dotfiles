return {
  -- Ensure neotest core is set up
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      "wojciech-kulik/xcodebuild.nvim",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {},
        ["xcodebuild.integrations.neotest"] = {},
      },
    },
  },
}

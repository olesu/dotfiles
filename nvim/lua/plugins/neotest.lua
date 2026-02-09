return {
  -- Ensure neotest core is set up
  {
    "nvim-neotest/neotest",
    dependencies = {
      -- This is the crucial Vitest adapter
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        -- Include the adapter in the setup function
        ["neotest-vitest"] = {},
      },
    },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Add custom sections
    local function show_macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == "" then
        return ""
      else
        return "Recording @" .. recording_register
      end
    end

    -- Modify lualine sections
    opts.sections = opts.sections or {}
    opts.sections.lualine_b = opts.sections.lualine_b or {}
    opts.sections.lualine_x = opts.sections.lualine_x or {}

    -- Add macro recording
    table.insert(opts.sections.lualine_x, 1, {
      show_macro_recording,
      color = { fg = "#ff9e64" },
    })

    return opts
  end,
}

-- lua/plugins/neogit.lua
return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - for better diff viewing
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    require("neogit").setup({
      -- You can leave this empty to use the excellent defaults
    })

    -- I recommend setting a keymap to open it easily
    vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit" })
  end
}

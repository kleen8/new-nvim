return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false, -- Use standard navigation
      },
      view_options = {
        show_hidden = true,
      },
    })
    -- Open parent directory in current window
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end
}

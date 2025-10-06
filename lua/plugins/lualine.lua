-- lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- For filetype icons
  config = function()
    require("lualine").setup({
      options = {
        -- You can change the theme here.
        -- Available themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
        theme = "auto", 
        icons_enabled = true,
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        -- Left side of the statusline
        lualine_a = {'mode'},
        lualine_b = {
            'branch', -- This is the Git branch component
            'diff',   -- This shows added/modified/removed lines
            'diagnostics' -- Errors/warnings from your LSP
        },
        lualine_c = {'filename'},

        -- Right side of the statusline
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    })
  end,
}

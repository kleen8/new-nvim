return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        -- set to false to use custom keymaps
        auto_trigger = true,
        keymap = {
          accept = "<C-i>",        -- Accept suggestion (Ctrl+L)
          accept_word = false,     -- Accept one word of suggestion
          accept_line = false,     -- Accept one line of suggestion
          next = "<C-n>",          -- Cycle to next suggestion (Ctrl+J)
          prev = "<C-p>",          -- Cycle to previous suggestion (Ctrl+K)
          dismiss = "<C-m>",       -- Dismiss suggestion (Ctrl+H)
        },
      },
      panel = {
        -- set to false to disable panel
        enabled = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>", -- (Alt+Enter)
        },
      },
      filetypes = {
        -- Add any filetypes you want to disable copilot for
        -- Example:
        -- markdown = false,
        -- help = false,
      }
    },
  },
}

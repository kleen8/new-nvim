return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- For icons
  config = function()
    -- Optional:
    -- You can set FZF_DEFAULT_OPTS in your shell environment for global FZF settings
    -- Or configure fzf-lua specific options
    require("fzf-lua").setup({
      -- Global fzf-lua options can go here if needed
      -- e.g., winopts for borders, preview window settings, etc.
      winopts = {
        -- height = 0.85,
        -- width = 0.8,
        -- row = 0.5,
        -- col = 0.5,
        -- border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }, -- example border
        -- preview = {
        --   border = "border",
        --   wrap = "nowrap",
        --   hidden = "nohidden",
        --   vertical = "up:40%",
        --   horizontal = "right:60%",
        --   layout = "flex", -- 'flex' or 'window'
        --   flip_columns = 120,
        --   window = nil, -- window number or opts for nvim_open_win
        --   title = true, -- preview window title
        --   title_align = "left", -- "center", "right"
        -- },
      },
      -- Default options for file finding with fd
      files = {
        prompt = "🔍 Files> ",
        cmd = "fd --type f --hidden --follow --exclude .git", -- Show hidden files
        -- fd_opts = "--type f --hidden --follow --exclude .git", -- Alternative way to pass fd opts
        -- For rg_opts in live_grep, etc.
        -- rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git'",
      },
      -- Default options for live_grep with rg
      live_grep = {
        prompt = "🔍 Live Grep> ",
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git'",
      },
      grep = { -- For non-live grep, if you use it
        prompt = "🔍 Grep> ",
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git'",
      },
      keymap = {
        -- These are fzf-lua's internal keymaps when FZF window is active
        --["ctrl-d"] = "preview_page_down",
        --["ctrl-u"] = "preview_page_up",
      },
      actions = {
        -- These are actions for results in FZF window
        -- default = require("fzf-lua.actions").file_edit_or_qf,
        -- ["ctrl-s"] = require("fzf-lua.actions").file_split,
        -- ["ctrl-v"] = require("fzf-lua.actions").file_vsplit,
        -- ["ctrl-t"] = require("fzf-lua.actions").file_tabedit,
      }
      -- ... other fzf-lua global setup options
    })

    -- Now, define your keymaps using the fzf-lua module
    -- It's good practice to get the module once if you use it multiple times
    local fzf = require("fzf-lua")

    -- Your previous Telescope keybindings translated to fzf-lua:
    vim.keymap.set('n', '<leader>pf', function()
      fzf.files({
        prompt = "🔍 Files> ",
        fd_opts = "--type f --hidden --follow --exclude .git", -- Ensure hidden files
        -- You can also add 'actions' here to override defaults for this specific picker
      })
    end, { desc = "FZF Find Files" })

    vim.keymap.set('n', '<C-p>', function()
      fzf.git_files({ prompt = '🔍 Git Files> ' })
    end, { desc = "FZF Git Files" })

    vim.keymap.set('n', '<leader>pws', function()
      fzf.grep_cword({
        prompt = '🔍 Grep Word> ',
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git'",
      })
    end, { desc = "FZF Grep Current Word" })

    vim.keymap.set('n', '<leader>pWs', function()
      fzf.grep_cWORD({
        prompt = '🔍 Grep CWORD> ',
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git'",
      })
    end, { desc = "FZF Grep Current CWORD" })

    vim.keymap.set('n', '<leader>ps', function()
      local search_term = vim.fn.input("Grep > ")
      -- Proceed only if search_term is not nil and not empty
      if search_term and #search_term > 0 then
        fzf.live_grep({
          search = search_term, -- Pass the input directly to the search parameter
          prompt = '🔍 Live Grep> ',
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git'",
        })
      else
        print("Grep cancelled or empty input.")
      end
    end, { desc = "FZF Live Grep Input" })

    vim.keymap.set('n', '<leader>vh', function()
      fzf.help_tags({ prompt = '🔍 Help Tags> ' })
    end, { desc = "FZF Help Tags" })

  end, -- end of config function
}

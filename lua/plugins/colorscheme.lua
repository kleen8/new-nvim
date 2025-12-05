-- return {
--    {
--         "rebelot/kanagawa.nvim",
--         lazy = false, -- make sure we load this during startup if it is your main colorscheme
--         priority = 1000, -- make sure to load this before all the other start plugins
--         config = function()
--             -- load the colorscheme here
--             vim.cmd.colorscheme("kanagawa-wave")
--         end,
--     },
-- }


return {
    {
        "alljokecake/naysayer-theme.nvim",
        name = 'naysayer',
        lazy = false, -- Load immediately so colors apply on startup
        priority = 1000, -- Ensure it loads before other UI plugins
        config = function()
            require('naysayer').setup({
                variant = 'main',
                dark_variant = 'main',
                -- ENABLE the background to match the Emacs theme #062329
                disable_background = false,
                disable_float_background = false,
                disable_italics = true, -- Emacs config didn't emphasize italics
            })

            vim.cmd("colorscheme naysayer")

            -- Manual Overrides to match the Emacs Lisp definition exactly
            -- We use the variables you provided:
            -- background="#062329", selection="#0000ff", text="#d1b897"
            -- comments="#44b340", line-fg="#126367", highlight-line="#0b3335"
            local colors = {
                bg = "#062329",
                bg_inactive = "#04171b",
                fg = "#d1b897",
                selection = "#0000ff",
                comment = "#44b340",
                line_fg = "#126367",
                cursor_line = "#0b3335",
                constant = "#7ad0c6",
                string = "#2ec09c",
                keyword = "#ffffff",
                error = "#ff0000",
                warning = "#ffaa00",
                search_bg = "#f6c177",
            }

            -- Force specific groups to match the Emacs theme
            local set_hl = vim.api.nvim_set_hl

            -- Editor UI
            set_hl(0, "Normal", { bg = colors.bg, fg = colors.fg })
            set_hl(0, "NormalNC", { bg = colors.bg_inactive, fg = colors.fg })
            set_hl(0, "Visual", { bg = colors.selection, fg = nil }) -- Bright blue selection
            set_hl(0, "LineNr", { fg = colors.line_fg, bg = colors.bg }) -- Teal line numbers
            set_hl(0, "CursorLine", { bg = colors.cursor_line }) -- Subtle line highlight
            set_hl(0, "CursorLineNr", { fg = "#ffffff", bg = colors.cursor_line, bold = true })

            -- Syntax Highlights (Mapping Emacs variables to Neovim groups)
            set_hl(0, "Comment", { fg = colors.comment, italic = false })
            set_hl(0, "String", { fg = colors.string })
            set_hl(0, "Constant", { fg = colors.constant }) -- Numbers/Constants
            set_hl(0, "Number", { fg = colors.constant })
            set_hl(0, "Function", { fg = "#ffffff", bold = false }) -- Emacs 'functions' var
            set_hl(0, "Keyword", { fg = "#ffffff", bold = false }) -- Emacs 'keywords' var
            set_hl(0, "Statement", { fg = "#ffffff", bold = false }) -- Often maps to keywords
            set_hl(0, "Type", { fg = "#8cde94" }) -- Emacs 'punctuation'/'type' var match

            -- 3. SEARCH & MATCHING (New)
            -- 'Search' is for all matches, 'CurSearch' is the one under your cursor
            set_hl(0, "Search", { bg = colors.line_fg, fg = "#ffffff" })
            set_hl(0, "CurSearch", { bg = colors.search_bg, fg = "#000000", bold = true })
            set_hl(0, "IncSearch", { link = "CurSearch" })
            set_hl(0, "MatchParen", { bg = "#555555", fg = "#ffffff", bold = true }) -- Highlights matching () [] {}

            -- 4. FLOATING WINDOWS (New)
            -- This controls hover docs (K) and other popups.
            -- We link them to Normal so they blend in, or give them a subtle border.
            set_hl(0, "NormalFloat", { bg = "#031619", fg = colors.fg })
            set_hl(0, "FloatBorder", { bg = "#031619", fg = colors.line_fg })

            -- 5. DIAGNOSTICS (New)
            -- Make sure errors/warnings are visible but don't look like default terminal red
            set_hl(0, "DiagnosticError", { fg = colors.error })
            set_hl(0, "DiagnosticWarn", { fg = colors.warning })
            set_hl(0, "DiagnosticInfo", { fg = colors.constant })
            set_hl(0, "DiagnosticHint", { fg = colors.line_fg })
            -- Underlines often clutter the screen; keeping them subtle is professional
            set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
            set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warning })

            -- 6. POPUP MENU (Autocomplete)
            set_hl(0, "Pmenu", { bg = "#031619", fg = colors.fg })
            set_hl(0, "PmenuSel", { bg = colors.selection, fg = "#ffffff", bold = true })
            set_hl(0, "PmenuSbar", { bg = "#031619" }) -- Scrollbar track
            set_hl(0, "PmenuThumb", { bg = colors.line_fg }) -- Scrollbar handle

            set_hl(0, "FlashLabel", { bg = "#ff00ff", fg = "#ffffff", bold = true })
            -- The "Match" is the word you searched for
            -- We make this Gold/Yellow (like your search color)
            set_hl(0, "FlashMatch", { bg = colors.search_bg, fg = "#000000" })

            -- The "Backdrop" is everything else on screen (dimmed)
            -- We make it a dull grey/blue so it fades away but is still readable
            set_hl(0, "FlashBackdrop", { fg = "#606060" })

            -- The "Current" match (if you used standard search)
            set_hl(0, "FlashCurrent", { bg = colors.selection, fg = "#ffffff" })

        end
    }
}

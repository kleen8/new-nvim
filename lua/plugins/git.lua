return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr })
                    vim.keymap.set("n", "<leader>hb", gs.blame_line, { buffer = bufnr })
                end,
            })
        end,
    },
    {
        "tpope/vim-fugitive",
        config = function()
            -- Create an autocommand that only runs when 'diff' mode is active
            vim.api.nvim_create_autocmd("OptionSet", {
                pattern = "diff",
                callback = function()
                    -- Only apply if 'diff' is actually turned on (vim.v.option_new is the new value)
                    if vim.v.option_new then
                        -- 'gh' (Get Here/Left) gets the change from the Left buffer (Target/Master)
                        vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>", { buffer = true, desc = "Get Left (Target)" })

                        -- 'gl' (Get Left/Right) gets the change from the Right buffer (Merge/Branch)
                        vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>", { buffer = true, desc = "Get Right (Merge)" })
                    end
                end,
            })
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
        config = true,
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
        },
    },
}

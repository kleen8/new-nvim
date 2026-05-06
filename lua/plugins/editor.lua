return {
    -- 1. FZF-Lua (The Search Engine)
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local fzf = require("fzf-lua")
            fzf.setup({ winopts = { preview = { horizontal = "right:50%" } } })

            vim.keymap.set("n", "<leader>pf", fzf.files, { desc = "Find Files" })
            vim.keymap.set("n", "<C-p>", fzf.git_files, { desc = "Git Files" })
            vim.keymap.set("n", "<leader>ps", fzf.live_grep, { desc = "Grep Project" })
            vim.keymap.set("n", "<leader>vh", fzf.help_tags, { desc = "Help Tags" })
        end,
    },

    -- 2. Oil (File Explorer)
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                view_options = { show_hidden = true },
                keymaps = { ["<C-l>"] = false, ["<C-h>"] = false },
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>")
        end,
    },

    -- 3. Harpoon (Quick Navigation)
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local ui = require("harpoon.ui")
            local mark = require("harpoon.mark")
            vim.keymap.set("n", "<leader>a", mark.add_file)
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
            vim.keymap.set("n", "<A-h>", function() ui.nav_file(1) end)
            vim.keymap.set("n", "<A-j>", function() ui.nav_file(2) end)
            vim.keymap.set("n", "<A-k>", function() ui.nav_file(3) end)
            vim.keymap.set("n", "<A-l>", function() ui.nav_file(4) end)
        end,
    },

    -- 4. Treesitter & Context (Highlighting & Sticky Headers)
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup {
            }
            require("nvim-treesitter").install {
                "go", "lua", "vim", "vimdoc", "javascript", "typescript", "svelte", "css", "dockerfile", "yaml", "bash", "hcl"
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context", -- Sticky Headers!
        event = "BufReadPost",
        lazy = false,
        opts = { max_lines = 3 },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },
    {
        "mbbill/undotree",

        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        config = function()
            vim.o.foldcolumn = "1" -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- *** THIS IS THE IMPORTANT PART ***
            -- Initialize nvim-ufo and set the provider
            require('ufo').setup({
                -- Set the default provider to Tree-sitter.
                -- You can also add 'lsp' to this list as a fallback, like {'treesitter', 'lsp', 'indent'}
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end
            })
            -- Using ufo provider need to disable the default vim folder provider
            vim.o.foldmethod = "expr"
            vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

            -- Set keymaps for folding
            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
        end,
    }
}

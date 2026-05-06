return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- <--- This is the missing piece!
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require("lsp_signature").setup({
                -- 1. THE FLOATING WINDOW ("Small Screen Buffer")
                bind = true,
                floating_window = true,
                floating_window_above_cur_line = true,
                fix_pos = false, -- Let it follow the cursor slightly
                doc_lines = 0,   -- Senior Tip: Keep it 0. Shows only params, not the huge doc wall.

                -- 2. THE DYNAMIC GHOST TEXT ("Show name as I type")
                hint_enable = true,     -- This is the magic switch
                hint_prefix = "jg ",    -- Identifier (e.g., "jg" for "Just Go")
                hint_scheme = "String", -- Color of the hint

                -- This moves the hint to the END of the line so it doesn't shift your code around
                -- while you are typing.
                hint_inline = function() return false end,

                -- 3. VISUALS
                handler_opts = {
                    border = "rounded" -- Matches your other UI elements
                },

                -- 4. BEHAVIOR
                always_trigger = true,  -- Show even if you backspace into the ()
                auto_close_after = nil, -- Don't close automatically, wait for ')'
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>S",  function() require("spectre").toggle() end,                                 desc = "Toggle Spectre" },
            { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end,      desc = "Search current word" },
            { "<leader>sp", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Search on current file" },
        },
    },
    -- {
    --     "zbirenbaum/copilot.lua",
    --     cmd = "Copilot",
    --     event = "InsertEnter",
    --     opts = {
    --         suggestion = {
    --             -- set to false to use custom keymaps
    --             auto_trigger = true,
    --             keymap = {
    --                 accept = "<C-i>",    -- Accept suggestion (Ctrl+L)
    --                 accept_word = false, -- Accept one word of suggestion
    --                 accept_line = false, -- Accept one line of suggestion
    --                 next = "<C-n>",      -- Cycle to next suggestion (Ctrl+J)
    --                 prev = "<C-p>",      -- Cycle to previous suggestion (Ctrl+K)
    --                 dismiss = "<C-m>",   -- Dismiss suggestion (Ctrl+H)
    --             },
    --         },
    --         panel = {
    --             -- set to false to disable panel
    --             enabled = true,
    --             keymap = {
    --                 jump_prev = "[[",
    --                 jump_next = "]]",
    --                 accept = "<CR>",
    --                 refresh = "gr",
    --                 open = "<M-CR>", -- (Alt+Enter)
    --             },
    --         },
    --         filetypes = {
    --             -- Add any filetypes you want to disable copilot for
    --             -- Example:
    --             -- markdown = false,
    --             -- help = false,
    --         }
    --     },
    -- },
}

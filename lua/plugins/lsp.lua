return {
    -- 1. Mason (Must load independently)
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
    },

    -- 2. Mason LSP Config + LSP Config (Combined for the Handlers pattern)
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "b0o/schemastore.nvim",
        },
        config = function()
            -- 1. SETUP MASON (Manages binary downloads only)
            require("mason").setup()

            -- Ensure binaries are installed, but DO NOT use Mason's handlers to setup the LSP.
            -- We want full control via the native API.
            require("mason-lspconfig").setup({
                ensure_installed = { "gopls", "yamlls", "lua_ls" },
            })

            -- 2. DEFINE CAPABILITIES (Keep nvim-cmp happy)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            if ok then
                capabilities = cmp_lsp.default_capabilities()
            end

            -- =========================================================
            -- NATIVE CONFIGURATION (Neovim 0.11+)
            -- =========================================================

            -- GO CONFIGURATION (Pure Native)
            -- We modify the global vim.lsp.config table directly.
            vim.lsp.config.gopls = {
                cmd = { "gopls" },                              -- Mason puts this in your PATH automatically
                root_markers = { "go.mod", ".git", "go.work" }, -- Native root detection
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                capabilities = capabilities,
                settings = {
                    gopls = {
                        buildFlags = { "-tags=integration" },

                        -- Analysis settings
                        analyses = { unusedparams = true, shadow = true },
                        staticcheck = true,
                        gofumpt = true,
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
            }

            -- LUA CONFIGURATION (Pure Native)
            vim.lsp.config.lua_ls = {
                cmd = { "lua-language-server" },
                root_markers = { ".git", ".luarc.json" },
                filetypes = { "lua" },
                capabilities = capabilities,
                settings = {
                    Lua = { diagnostics = { globals = { "vim" } } }
                },
            }

            -- 3. ENABLE SERVERS (The "Start" Trigger)
            -- In 0.11, we use FileType autocmds to enable the native client.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "go", "gomod", "gowork" },
                callback = function()
                    vim.lsp.enable("gopls")
                end,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    -- Check if the LSP server actually supports inlay hints
                    if client.server_capabilities.inlayHintProvider then
                        -- Enable them globally (or pass { bufnr = ev.buf } for just this buffer)
                        vim.lsp.inlay_hint.enable(true)
                    end
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "lua",
                callback = function()
                    vim.lsp.enable("lua_ls")
                end,
            })

            -- =========================================================
            -- KEYMAPS (LspAttach)
            -- =========================================================
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)

                    -- Toggle Inlay Hints
                    if vim.lsp.inlay_hint then
                        vim.keymap.set("n", "<leader>ti", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, { desc = "Toggle Hints" })
                    end
                end,
            })
        end,

        -- config = function()
        --     local mason = require("mason")
        --     local mason_lsp = require("mason-lspconfig")
        --     local lspconfig = require("lspconfig")
        --
        --     mason.setup()
        --
        --     -- 1. Capabilities (Resilient)
        --     local capabilities = vim.lsp.protocol.make_client_capabilities()
        --     local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        --     if ok then
        --         capabilities = cmp_lsp.default_capabilities()
        --     end
        --
        --     -- 2. Define Handlers (The Fix for 0.11 Deprecation & Clean Arch)
        --     -- Instead of calling setup() manually at the top level, we define them here.
        --     local handlers = {
        --         -- The default handler for any server without a specific custom config
        --         function(server_name)
        --             lspconfig[server_name].setup({
        --                 capabilities = capabilities,
        --             })
        --         end,
        --
        --         -- GO CONFIGURATION
        --         ["gopls"] = function()
        --             print("!!! GOPLS HANDLER IS FIRING !!!")
        --             lspconfig.gopls.setup({
        --                 capabilities = capabilities,
        --                 settings = {
        --                     gopls = {
        --                         buildFlags = { "-tags=integration" },
        --                         analyses = { unusedparams = true, shadow = true },
        --                         staticcheck = true,
        --                         gofumpt = true,
        --                         hints = {
        --                             assignVariableTypes = true,
        --                             compositeLiteralFields = true,
        --                             constantValues = true,
        --                             functionTypeParameters = true,
        --                             parameterNames = true,
        --                             rangeVariableTypes = true,
        --                         },
        --                     },
        --                 },
        --             })
        --         end,
        --
        --         -- YAML CONFIGURATION
        --         ["yamlls"] = function()
        --             lspconfig.yamlls.setup({
        --                 capabilities = capabilities,
        --                 settings = {
        --                     yaml = {
        --                         schemaStore = { enable = false, url = "" },
        --                         schemas = require("schemastore").yaml.schemas(),
        --                     },
        --                 },
        --             })
        --         end,
        --
        --         -- LUA CONFIGURATION (Fixes the Undefined global 'vim' warning)
        --         ["lua_ls"] = function()
        --             lspconfig.lua_ls.setup({
        --                 capabilities = capabilities,
        --                 settings = {
        --                     Lua = {
        --                         diagnostics = { globals = { "vim" } },
        --                     },
        --                 },
        --             })
        --         end,
        --     }
        --
        --     -- 3. Setup Mason-LSPConfig with the handlers
        --     mason_lsp.setup({
        --         ensure_installed = {
        --             "gopls", "ts_ls", "svelte", "cssls", "tailwindcss",
        --             "dockerls", "helm_ls", "yamlls", "bashls", "terraformls", "jsonls", "lua_ls"
        --         },
        --         handlers = handlers, -- Pass the handlers here!
        --     })
        --
        --     -- 4. Global Keymaps (LspAttach)
        --     vim.api.nvim_create_autocmd("LspAttach", {
        --         callback = function(args)
        --             local opts = { buffer = args.buf }
        --             vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        --             vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        --             vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        --             vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        --             vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        --             vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        --
        --             -- Toggle Inlay Hints (Safe check)
        --             if vim.lsp.inlay_hint then
        --                 vim.keymap.set("n", "<leader>ti",
        --                     function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        --                     { desc = "Toggle Hints" })
        --             end
        --         end,
        --     })
        -- end,
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>tt",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    }
}

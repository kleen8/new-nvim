-- lua/plugins/lsp.lua
return {
    -- Mason core (auto-updates its registry)
    { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },

    -- nvim-lspconfig (we will configure this directly now)
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- This autocommand tells Neovim to treat .avsc files as JSON
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = "*.avsc",
                callback = function()
                    vim.bo.filetype = "json"
                end,
            })
        end,
    },

    -- mason-lspconfig: downloads servers & wires them to lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        -- This config block is the main change.
        -- We'll set up servers explicitly in the lspconfig plugin spec below.
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            if ok then
                capabilities = cmp_lsp.default_capabilities(capabilities)
            end

            -- List of servers to install with Mason
            local servers = {
                "eslint", "tailwindcss", "jsonls", "cssls", "html", "svelte",
                "dockerls", "helm_ls", "yamlls", "bashls", "terraformls",
                "lua_ls",
            }

            -- Setup mason-lspconfig to install the servers
            require("mason-lspconfig").setup({
                ensure_installed = servers,
            })

        -- Common on_attach function for keymaps
            local on_attach = function(client, bufnr)
                print("LSP attached: " .. client.name)
                vim.diagnostic.config({
                    virtual_text = true,
                    signs = true,
                    underline = true,
                    update_in_insert = false,
                })

                local opts = { buffer = bufnr, noremap = true, silent = true }
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            end

            -- Get capabilities for nvim-cmp
            capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Loop through the installed servers and configure them
            for _, server_name in ipairs(servers) do
                -- This table holds the settings for the current server
                local opts = {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }

                -- === Add special settings for specific servers ===
                if server_name == "lua_ls" then
                    opts.settings = {
                        Lua = {
                            diagnostics = { globals = { 'vim' } },
                        },
                    }
                end

                if server_name == "yamlls" then
                    opts.filetypes = { "yaml" }
                end

                if server_name == "jsonls" then
                    opts.filetypes = { "json", "jsonc", "avsc" }
                end

                -- 1. Configure the server with its settings
                vim.lsp.config(server_name, opts)

                -- 2. Enable the server
                vim.lsp.enable(server_name)
            end
        end,
    },

    -- === ADD THIS NEW PLUGIN FOR GO ===
    {
        "ray-x/go.nvim",
        dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig" },
        config = function()
            require("go").setup({
                lsp_cfg = true,
                lsp_keymaps = false,
                dap_cfg = true,
                lint_on_save = "file",
                diagnostic = {  -- set diagnostic to false to disable vim.diagnostic.config setup,
                    -- true: default nvim setup
                    hdlr = false, -- hook lsp diag handler and send diag to quickfix
                    underline = true,
                    virtual_text = { spacing = 2, prefix = '' }, -- virtual text setup
                    signs = {'', '', '', ''},  -- set to true to use default signs, an array of 4 to specify custom signs
                    update_in_insert = true,
                },
                -- if you need to setup your ui for input and select, you can do it here
                -- go_input = require('guihua.input').input -- set to vim.ui.input to disable guihua input
                -- go_select = require('guihua.select').select -- vim.ui.selecpt to disable guihua select
                lsp_document_formatting = true,
                -- set to true: use gopls to format
                -- false if you want to use other formatter tool(e.g. efm, nulls)
                lsp_inlay_hints = {
                    enable = true, -- this is the only field apply to neovim > 0.10
                },
            })
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require('go.format').goimports()
                end,
                group = format_sync_grp,
            })
            -- Keymaps for testing
            vim.keymap.set("n", "<leader>t", ":GoTest<CR>", { desc = "Run Go Tests in file" })
            vim.keymap.set("n", "<leader>T", ":GoTestFunc<CR>", { desc = "Run Go Test function" })
            vim.keymap.set("n", "<leader>tc", ":GoCoverageToggle<CR>", { desc = "Toggle Go Test Coverage" })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()',
    },

}

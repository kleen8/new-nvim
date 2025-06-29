-- lua/plugins/lsp.lua
return {
    -- Mason core (auto-updates its registry)
    { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },

    -- nvim-lspconfig (we will configure this directly now)
    { "neovim/nvim-lspconfig" },

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

            -- Now, configure each server with lspconfig
            local lspconfig = require("lspconfig")
            for _, server_name in ipairs(servers) do
                local opts = {
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        -- Your on_attach function here. Example keymaps:
                        print("Lsp attached: " .. client.name)
                        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
                        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
                        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
                    end,
                }

                -- === Special settings for Lua ===
                if server_name == "lua_ls" then
                    opts.settings = {
                        Lua = {
                            diagnostics = { globals = {'vim'} }
                        }
                    }
                end

                lspconfig[server_name].setup(opts)
            end
        end,
    },
    -- === ADD THIS NEW PLUGIN FOR GO ===
    {
        "ray-x/go.nvim",
        dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig" },
        config = function()
            require("go").setup({
                -- Tell go.nvim NOT to set up lspconfig, as you've done it yourself above.
                -- This is the key to avoiding conflicts.
                lsp_cfg = true,
                lsp_on_attach = true,
                -- Let go.nvim handle DAP configuration for Go
                dap_cfg = true,
                -- Other nice settings
                lint_on_save = "file",
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
        -- This will install delve, gofumpt, golangci-lint, etc.
        build = ':lua require("go.install").update_all_sync()',
    },

}

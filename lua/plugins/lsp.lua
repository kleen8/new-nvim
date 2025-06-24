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

      -- Your custom definition handler
      vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx, _)
        if not result or vim.tbl_isempty(result) then
          vim.notify("No definition found", vim.log.levels.INFO)
          return
        end
        vim.lsp.util.jump_to_location(result[1], "utf-8", true)
      end

      -- List of servers to install with Mason
      local servers = {
        "eslint", "tailwindcss", "jsonls", "cssls", "html", "svelte",
        "gopls", -- Go
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
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
          end,
        }

        -- === Special settings for Go ===
        if server_name == "gopls" then
          opts.settings = {
            gopls = {
              gofumpt = true, -- Use the stricter gofumpt formatter
              analyses = {
                  unusedparams = true,
              },
              staticcheck = true,
            },
          }
        end
        
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
        lsp_cfg = false,
        -- Let go.nvim handle DAP configuration for Go
        dap_cfg = true,
        -- Other nice settings
        lint_on_save = "file",
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

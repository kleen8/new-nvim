local capabilities = vim.lsp.protocol.make_client_capabilities()
do
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end
end

vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx, _)
  if not result or vim.tbl_isempty(result) then
    vim.notify("No definition found", vim.log.levels.INFO)
    return
  end
  -- always pick the first location; keep current window
  vim.lsp.util.jump_to_location(result[1], "utf-8", true)
end

return {
    -- Mason core (auto-updates its registry)
    { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
    -- nvim-lspconfig
    { "neovim/nvim-lspconfig" },
    -- make cmp advertise the extra completion capabilities to *every* server
    -- mason-lspconfig: downloads servers & wires them to lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {  
                "eslint",
                "tailwindcss",
                "jsonls",
                "ts_ls",

                -- Golang & DevOps
                "gopls",
                "dockerls",
                "helm_ls",
                "yamlls",
                "bashls",
                "terraformls",

                -- Lua (for Neovim config)
                "lua_ls",},
            handlers = {
                -- Default handler for every server *except* those you override later
                function(server)
                    require("lspconfig")[server].setup({
                        capabilities = capabilities,
                    })
                end,
            },
        },
    },
}


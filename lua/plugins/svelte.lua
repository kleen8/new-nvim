return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      svelte = function()
        require("lspconfig").svelte.setup({
          on_attach = function(client, bufnr)
            client.server_capabilities.semanticTokensProvider = nil
          end,
        })
      end,
    },
  },
}


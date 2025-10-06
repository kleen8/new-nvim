-- In a file like lua/plugins/svelte.lua
return {
  "neovim/nvim-lspconfig",
  ft = "svelte", -- Lazy-load for svelte files
  config = function()
    -- Define a custom on_attach for svelte if needed
    local on_attach = function(client, bufnr)
      -- This is a common workaround for issues with svelte-tools
      client.server_capabilities.semanticTokensProvider = nil
      -- You can add other keymaps or logic here
    end

    -- 1. Define the configuration for svelte
    vim.lsp.config('svelte', {
      on_attach = on_attach,
    })

    -- 2. Enable the svelte server
    vim.lsp.enable('svelte')
  end,
}

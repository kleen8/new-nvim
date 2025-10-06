-- lua/plugins/lua_ls.lua
return {
  "neovim/nvim-lspconfig",
  ft = "lua", -- Load only when a Lua file is opened
  config = function()
    -- 1. Define the configuration for lua_ls
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    -- 2. Enable the lua_ls server
    vim.lsp.enable('lua_ls')
  end,
}

-- lua/plugins/lua_ls.lua   (rename the file or keep the same name)
return {
  "neovim/nvim-lspconfig",
  ft = "lua",                             -- load only when a Lua file is opened
  config = function()
    require("lspconfig").lua_ls.setup({
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
        },
      },
    })
  end,
}


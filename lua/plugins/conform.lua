-- lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      java = { "google-java-format" },
      go   = { "gofumpt" },
      lua  = { "stylua" },
      svelte = { "prettier" },
    },
  },
}


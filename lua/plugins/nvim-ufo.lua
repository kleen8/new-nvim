return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

        -- *** THIS IS THE IMPORTANT PART ***
    -- Initialize nvim-ufo and set the provider
    require('ufo').setup({
      -- Set the default provider to Tree-sitter.
      -- You can also add 'lsp' to this list as a fallback, like {'treesitter', 'lsp', 'indent'}
      provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
      end
    })
    -- Using ufo provider need to disable the default vim folder provider
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    -- Set keymaps for folding
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
  end,
}

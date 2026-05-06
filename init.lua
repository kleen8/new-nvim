require("config.lazy")
require("core.remaps")
require("core.set")

local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
    pattern = { "go", "lua", "javascript", "typescript", "yaml", "bash" },
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gv", function()
            vim.cmd("vsplit")        -- 1. Create the split
            vim.lsp.buf.definition() -- 2. Jump to definition in the new split
            vim.cmd("normal! zz")
        end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() require("fzf-lua").lsp_references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>vws", function() require("fzf-lua").lsp_document_symbols() end, opts)
        vim.keymap.set("n", "<leader>vd", function() require("fzf-lua").diagnostics_document() end, opts)
        vim.keymap.set("i", "<C-q>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    end
})

-- lua/plugins/nvim-java.lua
return {
    "nvim-java/nvim-java",
    ft = "java",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",   -- so we can extend capabilities
    },

    config = function()
        -------------------------------------------------------------------------
        -- 1. LSP capabilities (adds cmp’s completion items when cmp is present)
        -------------------------------------------------------------------------
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        if ok then
            capabilities = cmp_lsp.default_capabilities(capabilities)
        end

        -------------------------------------------------------------------------
        -- 2. Figure out the project root & workspace dir
        -------------------------------------------------------------------------
        local util        = require("lspconfig.util")
        local project_root = util.root_pattern(
            "settings.gradle", ".git"
        )(vim.fn.expand("%:p"))

        -- If we opened a loose file outside any project, just abort quietly.
        if not project_root then return end

        local workspace_dir = vim.fn.stdpath("cache")
        .. "/jdtls/workspace/"
        .. vim.fn.fnamemodify(project_root, ":p:h:t")

        -------------------------------------------------------------------------
        -- 3. Boot nvim-java (wires JDTLS into lspconfig)
        -------------------------------------------------------------------------
        require("java").setup({
            jdk = { auto_install = false },   -- we’re already on JDK 21
            jdtls = {
                root_dir  = project_root,       -- never falls back to CWD
                workspace = workspace_dir,      -- per-project workspace
            },
        })

        -------------------------------------------------------------------------
        -- 4. Tell lspconfig to start/attach JDTLS with the shared capabilities
        -------------------------------------------------------------------------
        local handlers = require("core.lsp_handlers")
        require("lspconfig").jdtls.setup({
            capabilities = capabilities,
            handlers = {
                ["textDocument/definition"] = handlers.jump_first,
            }
        })
    end,
}


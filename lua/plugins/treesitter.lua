return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Automatically update parsers on install
    config = function()
        require("nvim-treesitter.configs").setup({
            -- List of parsers to install
            ensure_installed = { "lua", "javascript", "python", "html", "css", "bash" },
            sync_install = false, -- Install parsers asynchronously
            auto_install = true, -- Automatically install missing parsers
            highlight = {
                enable = true, -- Enable syntax highlighting
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true, -- Enable smart indentation
            },
            -- Additional features
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
            	},
	    },
            rainbow = {
                enable = true,
                extended_mode = true, -- Highlight non-bracket delimiters
            },
        })
    end,
}



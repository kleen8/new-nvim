-- return {
--    {
--         "rebelot/kanagawa.nvim",
--         lazy = false, -- make sure we load this during startup if it is your main colorscheme
--         priority = 1000, -- make sure to load this before all the other start plugins
--         config = function()
--             -- load the colorscheme here
--             vim.cmd.colorscheme("kanagawa-wave")
--         end,
--     },
-- }
return {
    {
        "alljokecake/naysayer-theme.nvim",
        name = 'naysayer',
        config = function()
            require('naysayer').setup({
                variant = 'main',
                dark_variant = 'main',
                bold_vert_split = false,
                dim_nc_background = false,
                disable_background = true,
                disable_float_background = true,
                disable_italics = true,
            })
            vim.cmd("colorscheme naysayer")
        end
    }
}

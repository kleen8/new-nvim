return {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Harpoon depends on plenary.nvim
    config = function()
        require("harpoon").setup({
            menu = {
                width = vim.api.nvim_win_get_width(0) - 20,
            },
        })
	local mark = require("harpoon.mark")
	local ui = require("harpoon.ui")
	vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Add file to Harpoon" })
	vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle Harpoon Menu" })

	  -- Navigate between Harpoon marks
        vim.keymap.set("n", "<leader>h1", function() ui.nav_file(1) end, { desc = "Go to Harpoon Mark 1" })
    	vim.keymap.set("n", "<leader>h2", function() ui.nav_file(2) end, { desc = "Go to Harpoon Mark 2" })
    	vim.keymap.set("n", "<leader>h3", function() ui.nav_file(3) end, { desc = "Go to Harpoon Mark 3" })
    	vim.keymap.set("n", "<leader>h4", function() ui.nav_file(4) end, { desc = "Go to Harpoon Mark 4" })

   end,
}

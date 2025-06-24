-- lua/plugins/dap.lua
return {
    {
        -- Core Debugger
        "mfussenegger/nvim-dap",
        dependencies = {
            -- Installs and configures debug adapters
            "williamboman/mason.nvim",
            "rcarriga/nvim-dap-ui",
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            local dap = require("dap")

            dap.set_log_level('DEBUG')

            -- mason-nvim-dap will see this and install/configure delve automatically
            require("mason-nvim-dap").setup({
                ensure_installed = { "delve" },
                handlers = {},
            })

            -- Keymaps for debugging
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
            vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<leader>ds", dap.step_out, { desc = "Step Out" })

            -- You can keep your function key maps as well
            vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue (F5)" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over (F10)" })
        end,
    },
    {
        -- UI for nvim-dap
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()

            -- Automatically open/close dap-ui when a session starts/ends
            dap.listeners.before.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        -- Helper to configure DAP for Go
        "leoluz/nvim-dap-go",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("dap-go").setup()
        end,
    },
}

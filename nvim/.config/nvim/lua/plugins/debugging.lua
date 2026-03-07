return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    "leoluz/nvim-dap-go",
  },
  keys = {
    {
      "<Leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "DAP: Toggle Breakpoint",
    },
    {
      "<Leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "DAP: Continue/Start",
    },
    {
      "<Leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "DAP: Step Over",
    },
    {
      "<Leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "DAP: Step Into",
    },
    {
      "<Leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "DAP: Terminate",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- 1. Initialize the UI and Virtual Text
    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    -- 2. Initialize the Go debugger specific setup
    require("dap-go").setup()

    -- 3. Automatically open/close the UI when debugging starts/stops
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
}

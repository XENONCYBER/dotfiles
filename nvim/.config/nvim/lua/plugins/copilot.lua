return {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<S-Tab>", -- Shift + Tab to accept
        next = "<M-]>", -- Alt + ] to see next suggestion
        prev = "<M-[>", -- Alt + [ to see previous suggestion
      },
    },
    panel = { enabled = false },
  },
}

-- ~/.config/nvim/lua/plugins/theme.lua
return {
  -- 1. Load Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Ensure it loads first
    opts = {
      -- You can customize the theme here
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = true, -- Enable if you want transparent background
      term_colors = true,
      integrations = {
        lazy = true,
        mason = true,
        notify = true,
        snacks = true,
        which_key = true,
      },
    },
  },

  -- 2. Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

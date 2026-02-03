-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.tabstop = 4      -- Number of spaces that a tab character represents
vim.opt.shiftwidth = 4   -- Number of spaces to use for indentation
vim.opt.expandtab = true -- Convert tabs to spaces

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = false -- IMPORTANT for Go
    end,
})

-- Tab for moving through the suggesitons list when visible

return {
    {
        "saghen/blink.cmp",
        -- distinct from "nvim-cmp", blink uses a 'keymap' table directly in opts
        opts = {
            keymap = {
                preset = "default", -- Keep the other default mappings (like C-space for trigger)

                -- "select_next" moves down the list.
                -- "snippet_forward" jumps to the next part of a snippet (if you are in one).
                -- "fallback" inserts a real Tab character if the menu is closed.
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },

                -- "select_prev" moves up the list.
                -- "snippet_backward" jumps backward in a snippet.
                -- "fallback" does the normal Shift+Tab behavior.
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

                -- Optional: Make Enter accept the completion (standard IDE behavior)
                ["<CR>"] = { "accept", "fallback" },
            },
        },
    },
}

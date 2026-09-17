return {
    "fzf-lua",
    cmd = "FzfLua",

    after = function()
      require("fzf-lua").setup()
    end,
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
    },
}

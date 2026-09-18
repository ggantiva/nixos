return {
	"vim-kitty-navigator",
	lazy = false,

	before = function()
		vim.g.kitty_navigator_no_mappings = 1
		vim.g.kitty_navigator_enable_stack_layout = 1
	end,

	keys = {
		{ "<M-h>", "<cmd>KittyNavigateLeft<cr>", mode = "n", desc = "Navigate Left to Kitty/Vim" },
		{ "<M-j>", "<cmd>KittyNavigateDown<cr>", mode = "n", desc = "Navigate Down to Kitty/Vim" },
		{ "<M-k>", "<cmd>KittyNavigateUp<cr>", mode = "n", desc = "Navigate Up to Kitty/Vim" },
		{ "<M-l>", "<cmd>KittyNavigateRight<cr>", mode = "n", desc = "Navigate Right to Kitty/Vim" },
	},
}

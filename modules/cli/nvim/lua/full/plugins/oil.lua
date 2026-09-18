return {
	"oil.nvim",
	lazy = false,

	keys = {
		{ "<leader>-", "<CMD>Oil<CR>", mode = "n", desc = "Open Oil File Explorer" },
	},

	after = function()
		require("oil").setup({
			default_file_explorer = true,
			watch_for_changes = true,

			columns = {
				"icon",
			},

			view_options = {
				show_hidden = true,
			},
		})
	end,
}

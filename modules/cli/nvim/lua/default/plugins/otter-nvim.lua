return {
	"otter.nvim",
	lazy = false,
	dependencies = {
		"nvim-treesitter",
	},

	after = function()
		local otter = require("otter")

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "markdown", "nix" },
			callback = function()
				vim.treesitter.start()
				otter.activate({ "bash", "lua" }, true, true, nil)
			end,
		})
	end,
}

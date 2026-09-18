return {
	"mini.statusline",
	lazy = false,

	after = function()
		require("mini.statusline").setup()
	end,
}

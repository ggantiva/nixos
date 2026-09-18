return {
	"mini.indentscope",
	after = function()
		require("mini.indentscope").setup({
			draw = {
				delay = 100,
				animation = require("mini.indentscope").gen_animation.none(),
			},

			options = {
				indent_at_cursor = false,
			},
		})
	end,
}

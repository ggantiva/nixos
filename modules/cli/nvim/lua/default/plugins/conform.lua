return {
	"conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = {
		{
			mode = "",
			"<leader>lf",
			function()
				require("conform").format({ async = true })
			end,
		},
	},

	after = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				nix = { "nixfmt" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				markdown = { "prettierd", "markdownlint-cli2" },
				html = { "prettierd" },
				css = { "prettierd" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				python = { "ruff_format" },
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}

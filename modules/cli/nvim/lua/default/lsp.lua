-- Enable servers
local servers = { "lua_ls", "bashls", "nixd", "html", "cssls", "ts_ls", "pyright" }
for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end

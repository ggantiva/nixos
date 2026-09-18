-- Enable servers
local servers = { "lua_ls", "bashls", "nixd" }
for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end

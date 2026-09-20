local options = {
	termguicolors = true,

	-- Line number
	number = true,
	relativenumber = true,

	wrap = false, -- Do not wrap lines by default
	mouse = "a", -- Enable mouse support
	signcolumn = "yes",

	-- Scrolloff
	scrolloff = 10,
	sidescrolloff = 10,

	-- Indenting
	tabstop = 2,
	shiftwidth = 2,
	softtabstop = 2,
	expandtab = true, -- Use spaces
	smartindent = true, -- Smart auto indent
	autoindent = true, -- Copy indent from current line

	-- Search
	ignorecase = true, -- Case insensitive
	smartcase = true, -- Case sensitive if uppercase is present

	completeopt = "menuone,noselect,popup",

	fillchars = { eob = " " }, -- Hide '~' on empty lines

	-- Disable backup file
	backup = false,
	writebackup = false,

	swapfile = false,
	undofile = true,
	updatetime = 300, -- Faster completion
	timeoutlen = 500, -- Timeout duration
	ttimeoutlen = 0, -- Key code timeout

	-- Use treesitter for folding
	foldmethod = "expr",
	foldexpr = "v:lua.vim.treesitter.foldexpr()",
	foldlevel = 99, -- Start with all folds open

	-- Split locations
	splitbelow = true,
	splitright = true,

	spelllang = { "en", "es" }, -- Spellchecking languages
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

local append_options = {
	{ "clipboard", "unnamedplus" }, -- Use system clipboard
	{ "iskeyword", "-" }, -- Include '-' in words
	{ "path", "**" }, -- Include subdirs in search
}

for _, option in ipairs(append_options) do
	vim.opt[option[1]]:append(option[2])
end

-- Fast startup & minimal UI
vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "no"
vim.opt.wrap = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.list = false
vim.opt.eventignore:append("FileType")

-- Keybindings
local map = vim.keymap.set

-- Quick exit
map("n", "q", "<cmd>qa!<cr>", { silent = true })
map("n", "<esc>", "<cmd>qa!<cr>", { silent = true })

-- Visual mode: yank to clipboard and exit
map("v", "y", '"+y<cmd>qa!<cr>', { silent = true })

-- Page navigation
map("n", "d", "<C-d>", { silent = true })
map("n", "u", "<C-u>", { silent = true })
map("n", "f", "<C-f>", { silent = true })
map("n", "b", "<C-b>", { silent = true })

-- Prevent accidental insert mode edits in read-only pager
map("n", "i", "<nop>")
map("n", "a", "<nop>")
map("n", "o", "<nop>")
map("n", "c", "<nop>")
map("n", "s", "<nop>")

-- Parse ANSI escape codes and scroll to bottom
vim.schedule(function()
  vim.api.nvim_open_term(0, {})
  vim.cmd("$")
  vim.bo.modified = false
end)

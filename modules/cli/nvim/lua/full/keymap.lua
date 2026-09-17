-- Space for leader and local leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function map(m, k, v)
  vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

map("n", "<leader>W", ":set wrap!<CR>") -- Toggle text wrapping
map("n", "<leader>c", ":nohlsearch<CR>") -- Clear search highlights

-- Buffers
map("n", "<leader>bn", ":bnext<CR>")
map("n", "<leader>bp", ":bprevious<CR>")

map("x", "<leader>p", '"_dP') -- Paste without yanking
map({"n", "v"}, "<leader>x", '"_d') -- Delete without yanking

-- Move line around
map("n", "<C-j>", ":m .+1<CR>==")
map("n", "<C-k>", ":m .-2<CR>==")

-- Move selection around
map("v", "<C-j>", ":m '>+1<CR>gv=gv")
map("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Indent and reselect
map("v", ">", ">gv")
map("v", "<", "<gv")

map("n", "J", "mzJ`z") -- Keep cursor position when joining

local map = vim.keymap.set

map("n", "<Tab>", ":bnext<CR>", {noremap = true, silent = true})
map('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

map("n", "<C-Left>",  "<C-w>h", { silent = true })
map("n", "<C-Down>",  "<C-w>j", { silent = true })
map("n", "<C-Up>",    "<C-w>k", { silent = true })
map("n", "<C-Right>", "<C-w>l", { silent = true })

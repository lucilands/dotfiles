local map = vim.keymap.set

map("n", "<Tab>", ":bnext<CR>", {noremap = true, silent = true})
map('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

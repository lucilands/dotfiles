require("config.lazy")
require("config.telescope")
require("config.noice")
require("config.cmp")
require("config.telescope-file-browser")
require("config.lualine")
require("config.nvim")
require("config.keymaps")

vim.lsp.enable("pyright")

vim.cmd.colorscheme("catppuccin-mocha")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

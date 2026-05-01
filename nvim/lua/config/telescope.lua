local ignore_filetypes_list = {
    "venv", "__pycache__", "%.xlsx", "%.jpg", "%.png", "%.webp",
    "%.pdf", "%.odt", "%.ico", "%.o",
}
local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
	defaults = {
		file_ignore_patterns = ignore_filetypes_list,
	},
})

vim.keymap.set('n', 'ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', 'fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', 'fh', builtin.help_tags, { desc = 'Telescope help tags' })


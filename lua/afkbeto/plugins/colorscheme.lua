return {
	{
		'AlexvZyl/nordic.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			require('nordic').setup({
				bold_keyword = true,
				override = {
					LineNr = {
                        fg = "#d99cd0",
                    },
				}
			})
			vim.cmd([[colorscheme nordic]])
		end
	},
}

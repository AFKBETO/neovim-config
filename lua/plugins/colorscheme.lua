return {
	{
		'metalelf0/black-metal-theme-neovim',
		lazy = false,
		priority = 1000,
		config = function()
			require('black-metal').setup({
				theme = 'bathory',
				variant = 'light',
				alt_bg = true,
			})
			require('black-metal').load()
		end,
	},
}

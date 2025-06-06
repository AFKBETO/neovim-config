return {
	'folke/which-key.nvim',
	event = 'VeryLazy',
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	keys = {
		{
			'<leader>?',
			function()
				require('which-key').show()
			end,
			desc = 'Show Keymaps (which-key)'
		}
	},
}

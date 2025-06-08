return {
	"SmiteshP/nvim-navbuddy",
	dependencies = {
		{
			"SmiteshP/nvim-navic",
			opts = {
				lsp = {
					auto_attach = true,
					preference = {
						"denols",
						"vue_ls",
						"ts_ls",
					}
				}
			},
		},
		"MunifTanjim/nui.nvim"
	},
	opts = { lsp = { auto_attach = true } },
}

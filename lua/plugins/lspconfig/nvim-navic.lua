return {
	"SmiteshP/nvim-navbuddy",
	dependencies = {
		{
			"SmiteshP/nvim-navic",
			opts = { lsp = { auto_attach = true } },
		},
		"MunifTanjim/nui.nvim"
	},
	opts = { lsp = { auto_attach = true } },
}

return {
	-- copied config from nvim-lspconfig
	cmd = { 'vscode-html-language-server', '--stdio' },
	filetypes = { 'html', 'templ' },
	root_markers = { 'package.json', },
	settings = {},
	init_options = {
		provideFormatter = true,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { 'html', 'css', 'javascript' },
	},
}

return {
	-- copied config from nvim-lspconfig
	cmd = { 'terraform-ls', 'serve' },
	filetypes = { 'terraform', 'terraform-vars' },
	root_markers = { '.terraform', },
}

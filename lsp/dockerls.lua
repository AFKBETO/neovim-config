return {
	-- copied config from nvim-lspconfig
	cmd = { 'docker-langserver', '--stdio' },
	filetypes = { 'dockerfile' },
	root_markers = { 'Dockerfile' },
}

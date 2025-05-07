return {
	-- copied config from nvim-lspconfig
	cmd = { 'helm_ls', 'serve' },
	filetypes = { 'helm' },
	root_markers = { 'Chart.yaml' },
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
	settings = {
		["helm_ls"] = {
			yamlls = {
				path = "yaml-language-server",
			}
		}
	}
}

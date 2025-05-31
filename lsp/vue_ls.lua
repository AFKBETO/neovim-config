local util = require('lsp.util')

return {
	cmd = { 'vue-language-server', '--stdio' },
	filetypes = { 'vue' },
	root_markers = {
		'vue.config.js',
		'vue.config.ts',
		'vite.config.js',
		'vite.config.ts',
		'nuxt.config.js',
		'nuxt.config.ts',
	},
	-- https://github.com/vuejs/language-tools/blob/v2/packages/language-server/lib/types.ts
	init_options = {
		typescript = {
			tsdk = '',
		},
		vue = {
			hybridMode = false
		},
	},
	before_init = function(_, config)
		if config.init_options and config.init_options.typescript and config.init_options.typescript.tsdk == '' then
			config.init_options.typescript.tsdk = util.get_typescript_server_path(config.root_dir)
		end
	end,
}

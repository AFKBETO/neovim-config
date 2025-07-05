return {
	"nvim-treesitter/nvim-treesitter",
	tag = "v0.10.0",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- import nvim-treesitter plugin
		local configs = require("nvim-treesitter.configs")

		-- configure treesitter
		configs.setup({
			-- enable syntax highlighting
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			sync_install = false,
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"groovy"
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})

		-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
		require('ts_context_commentstring').setup {}
	end,
}


--[[ return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter")

			treesitter.install({
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"groovy"
			});

			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

			-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
			require('ts_context_commentstring').setup {}
		end,
	},
}
 ]]

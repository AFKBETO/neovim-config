require('lsp.cmd')

vim.lsp.config('lua_ls', {
	-- copied config from nvim-lspconfig
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = {
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'selene.toml',
		'selene.yml',
	},
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	}
})

vim.lsp.enable({
	"denols",
	"ts_ls",
	"html",
	"cssls",
	"lua_ls",
	"pyright",
	"dockerls",
	"jsonls",
	"terraformls",
	"docker_compose_language_service",
	"yamlls",
	"helm_ls",
	"rust_analyzer",
	"vue_ls",
})

vim.keymap.set('n', 'gK', function()
	local new_config = not vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			if mode == nil then
				mode = "n"
			end
			vim.keymap.set(mode, keys, func, { noremap = true, silent = true, buffer = event.buf, desc = desc })
		end
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

		map("<leader>lr", "<cmd>LspRestart<CR>", "Restart LSP")
		map("<leader>li", "<cmd>LspInfo<CR>", "Show LSP info")

		if client:supports_method('textDocument/implementation') then
			map("gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations") -- show lsp implementations
		end
		if client:supports_method('textDocument/typeDefinition') then
			map("gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions") -- show lsp type definitions
		end
		if client:supports_method('textDocument/references') then
			map("gr", "<cmd>Telescope lsp_references<CR>", "Show LSP references") -- show lsp references
		end
		if client:supports_method('textDocument/declaration') then
			map("gD", vim.lsp.buf.declaration, "Go to declaration", "n") -- go to declaration
		end
		if client:supports_method('textDocument/defintion') then
			map("gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions") -- show lsp definitions
		end
		if client:supports_method('textDocument/codeAction') then
			map("<leader>ca", vim.lsp.buf.code_action, "See available code action", { "n", "v" }) -- see available code actions, in visual mode will apply to selection
		end
		if client:supports_method('textDocument/rename') then
			map("<leader>rn", vim.lsp.buf.rename, "Smart rename")
		end
		if client:supports_method('textDocument/diagnostic') then
			map("<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics") -- show diagnostics for file
			map("<leader>d", vim.diagnostic.open_float, "Show line diagnostics")         -- show diagnostics for line
			map("[d", vim.diagnostic.get_prev, "Go to previous diagnostic")              -- jump to previous diagnostic in buffer
			map("]d", vim.diagnostic.get_next, "Go to next diagnostic")                  -- jump to next diagnostic in buffer
		end

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			-- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			-- client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = false })
		end
		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = event.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = event.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
		if client.name == "denols" or client.name == "ts_ls" then
			require("twoslash-queries").setup(client, event.buf)
		end
	end,
})

vim.g.markdown_fenced_languages = {
	"ts=typescript"
}
local hl = "DiagnosticSign"

vim.diagnostic.config({
	virtual_text = {
		current_line = true
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 "
		},
		texthl = {
			[vim.diagnostic.severity.ERROR] = hl .. "Error",
			[vim.diagnostic.severity.WARN] = hl .. "Warn",
			[vim.diagnostic.severity.INFO] = hl .. "Info",
			[vim.diagnostic.severity.HINT] = hl .. "Hint",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

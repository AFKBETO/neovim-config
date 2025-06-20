-- copied from nvim-lspconfig
--
local util = require('lsp.util')

local api, lsp = vim.api, vim.lsp

local completion_sort = function(items)
	table.sort(items)
	return items
end

local lsp_complete_configured_servers = function(arg)
	return completion_sort(vim.tbl_filter(function(s)
		return s:sub(1, #arg) == arg
	end, util.available_servers()))
end

local lsp_get_active_clients = function(arg)
	local clients = vim.tbl_map(function(client)
		return ('%s'):format(client.name)
	end, util.get_managed_clients())

	return completion_sort(vim.tbl_filter(function(s)
		return s:sub(1, #arg) == arg
	end, clients))
end

---@return vim.lsp.Client[] clients
local get_clients_from_cmd_args = function(arg)
	local result = {}
	local managed_clients = util.get_managed_clients()
	local clients = {}
	for _, client in pairs(managed_clients) do
		clients[client.name] = client
	end

	local err_msg = ''
	arg = arg:gsub('[%a-_]+', function(name)
		if clients[name] then
			return clients[name].id
		end
		err_msg = err_msg .. ('config "%s" not found\n'):format(name)
		return ''
	end)
	for id in (arg or ''):gmatch '(%d+)' do
		local client = lsp.get_client_by_id(assert(tonumber(id)))
		if client == nil then
			err_msg = err_msg .. ('client id "%s" not found\n'):format(id)
		end
		result[#result + 1] = client
	end

	if err_msg ~= '' then
		vim.notify(('nvim-lspconfig:\n%s'):format(err_msg:sub(1, -2)), vim.log.levels.WARN)
		return result
	end

	if #result == 0 then
		return managed_clients
	end
	return result
end

api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', { desc = 'Alias to `:checkhealth vim.lsp`' })

api.nvim_create_user_command('LspStart', function(info)
	local server_name = string.len(info.args) > 0 and info.args or nil
	if server_name then
		local config = vim.lsp._enabled_configs[server_name]
		if config then
			config.launch()
			return
		end
	end

	local matching_configs = util.get_config_by_ft(vim.bo.filetype)
	for _, config in ipairs(matching_configs) do
		config.launch()
	end
end, {
	desc = 'Manually launches a language server',
	nargs = '?',
	complete = lsp_complete_configured_servers,
})

api.nvim_create_user_command('LspRestart', function(info)
	local clients = vim.lsp.get_clients { bufnr = 0 }
	vim.lsp.stop_client(clients)
	vim.cmd.update()
	vim.defer_fn(vim.cmd.edit, 1000)
end, {
	desc = 'Manually restart the given language client(s)',
	nargs = '?',
	complete = lsp_get_active_clients,
})

api.nvim_create_user_command('LspStop', function(info)
	---@type string
	local args = info.args
	local force = false
	args = args:gsub('%+%+force', function()
		force = true
		return ''
	end)

	local clients = {}

	-- default to stopping all servers on current buffer
	if #args == 0 then
		clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	else
		clients = get_clients_from_cmd_args(args)
	end

	for _, client in ipairs(clients) do
		-- Can remove diagnostic disabling when changing to client:stop(force) in nvim 0.11+
		--- @diagnostic disable: param-type-mismatch
		client.stop(force)
	end
end, {
	desc = 'Manually stops the given language client(s)',
	nargs = '?',
	complete = lsp_get_active_clients,
})

api.nvim_create_user_command('LspLog', function()
	vim.cmd(string.format('tabnew %s', lsp.get_log_path()))
end, {
	desc = 'Opens the Nvim LSP client log.',
})

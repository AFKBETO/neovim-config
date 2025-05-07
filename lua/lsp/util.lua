local lsp = vim.lsp

local M = { path = {} }

M.default_config = {
	log_level = lsp.protocol.MessageType.Warning,
	message_level = lsp.protocol.MessageType.Warning,
	settings = vim.empty_dict(),
	init_options = vim.empty_dict(),
	handlers = {},
	autostart = true,
	capabilities = lsp.protocol.make_client_capabilities(),
}

-- global on_setup hook
M.on_setup = nil

local function escape_wildcards(path)
	return path:gsub('([%[%]%?%*])', '\\%1')
end

function M.root_pattern(...)
	local patterns = M.tbl_flatten { ... }
	return function(startpath)
		startpath = M.strip_archive_subpath(startpath)
		for _, pattern in ipairs(patterns) do
			local match = M.search_ancestors(startpath, function(path)
				for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, '/'), true, true)) do
					if vim.uv.fs_stat(p) then
						return path
					end
				end
			end)

			if match ~= nil then
				return match
			end
		end
	end
end

function M.insert_package_json(config_files, field, fname)
	local path = vim.fn.fnamemodify(fname, ':h')
	local root_with_package = vim.fs.find({ 'package.json', 'package.json5' }, { path = path, upward = true })[1]

	if root_with_package then
		-- only add package.json if it contains field parameter
		for line in io.lines(root_with_package) do
			if line:find(field) then
				config_files[#config_files + 1] = vim.fs.basename(root_with_package)
				break
			end
		end
	end
	return config_files
end

-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
function M.strip_archive_subpath(path)
	-- Matches regex from zip.vim / tar.vim
	path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
	path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
	return path
end

function M.get_typescript_server_path(root_dir)
	local project_roots = vim.fs.find('node_modules', { path = root_dir, upward = true, limit = math.huge })
	for _, project_root in ipairs(project_roots) do
		local typescript_path = project_root .. '/typescript'
		local stat = vim.loop.fs_stat(typescript_path)
		if stat and stat.type == 'directory' then
			return typescript_path .. '/lib'
		end
	end
	return ''
end

function M.get_config_by_ft(filetype)
	local configs = vim.lsp._enabled_configs
	local matching_configs = {}
	for _, config in pairs(configs) do
		local filetypes = config.filetypes or {}
		for _, ft in pairs(filetypes) do
			if ft == filetype then
				table.insert(matching_configs, config)
			end
		end
	end
	return matching_configs
end

function M.available_servers()
	local servers = {}
	local configs = vim.lsp._enabled_configs
	for server, config in pairs(configs) do
		if config.manager ~= nil then
			table.insert(servers, server)
		end
	end
	return servers
end

function M.get_managed_clients()
	local clients = {}
	local configs = vim.lsp._enabled_configs
	for _, config in pairs(configs) do
		if config.manager then
			vim.list_extend(clients, config.manager:clients())
		end
	end
	return clients
end

return M

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"SmiteshP/nvim-navic",
	},
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		local nvim_navic = require("nvim-navic")
		nvim_navic.setup({
			seperator = "",
			highlight = true,
		})

		local create_symbol_bar = function()
			if not nvim_navic.is_available() then
				return ""
			end
			local details = {}
			for _, item in ipairs(nvim_navic.get_data()) do
				table.insert(details, item.icon .. item.name:gsub("%s*->%s*", ""))
			end
			return table.concat(details, " > ")
		end
		-- configure lualine with modified theme
		lualine.setup({
			sections = {
				lualine_c = {
					{ 'filename', path = 1, }
				},
				lualine_x = {
					{ lazy_status.updates, cond = lazy_status.has_updates, color = { fg = "#ff9e64" }, },
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
			winbar = {
				lualine_a = {
					{ "filetype", icon_only = true,    icon = { align = "left" } },
					{ "filename", file_status = false, path = 0 },
				},
				lualine_b = {
					create_symbol_bar
				},
				lualine_c = {
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {
					{ "filetype", icon_only = true,    icon = { align = "left" } },
					{ "filename", file_status = false, path = 0 },
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}

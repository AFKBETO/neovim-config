return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		-- {
		-- 	"nvim-telescope/telescope-fzf-native.nvim",
		-- 	build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
		-- },
		--comment out the line below to use make
		{
		'nvim-telescope/telescope-fzf-native.nvim', build = 'make',
		},
		'nvim-telescope/telescope-ui-select.nvim',
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-project.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local project_actions = require("telescope._extensions.project.actions")

		telescope.setup({
			defaults = {
				path_display = { "truncate " },
				layout_config = {
					prompt_position = "top",
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				theme = "center",
				sorting_strategy = "ascending",
			},
			extensions = {
				file_browser = {
					hijack_netrw = true,
					grouped = true,
					hidden = { file_browser = true, folder_browser = true },
				},
				["ui-select"] = {
					theme = "dropdown",
				},
				project = {
					hidden_files = true, -- default: false
					order_by = "asc",
					search_by = "title",
					sync_with_nvim_tree = true, -- default false
					-- default for on_project_selected = find project files
					on_project_selected = function(prompt_bufnr)
						-- Do anything you want in here. For example:
						project_actions.change_working_directory(prompt_bufnr, false)
					end
				}
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("file_browser")
		telescope.load_extension("ui-select")
		telescope.load_extension("project")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<space>fb", function()
			require("telescope").extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true })
		end, { desc = "File browser", noremap = true, silent = true })
		keymap.set("n", "<C-p>", function()
			require("telescope").extensions.project.project()
		end, { desc = "Open project picker", noremap = true, silent = true })
	end,
}

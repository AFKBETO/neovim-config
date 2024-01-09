return {
	"kdheepak/lazygit.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { noremap = true, silent = true, desc = "LazyGit" })
	end,
}

return {
	"github/copilot.vim",
	config = function()
		local keymap = vim.keymap
		vim.g.copilot_enabled = true

		local toggle_copilot = function()
			if vim.g.copilot_enabled then
				vim.g.copilot_enabled = false
				print("Copilot disabled")
			else
				vim.g.copilot_enabled = true
				print("Copilot enabled")
			end
		end
		keymap.set("n", "<leader>ct", toggle_copilot, {
			desc = "Toggle Copilot",
		})
	end,
}

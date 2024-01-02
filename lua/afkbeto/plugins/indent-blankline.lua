return {
	"lukas-reineke/indent-blankline.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	main = "ibl",
	config = function ()
		local highlight = {
			"CursorColumn",
			"Whitespace",
		}
		require("ibl").setup {
			indent = { char = "|", highlight = highlight },
			whitespace = {
				highlight = highlight,
				remove_blankline_trail = false,
			},
			scope = { char = "▎" }
		}
	end
}

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "+" },
        remove = { text = "-" },
      },
      current_line_blame = true,
      numhl = true
    })
  end
}

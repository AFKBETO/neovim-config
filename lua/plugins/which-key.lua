return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    defaults = {
      ["<leader>s"] = { name = "Split control prefix" },
      ["<leader>t"] = { name = "Tab control prefix" },
      ["<leader>f"] = { name = "Find/Search prefix" },
      ["<leader>e"] = { name = "Nvim Tree/File Explorer prefix" }
    },
  }
}

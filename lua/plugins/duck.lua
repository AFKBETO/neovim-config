return {
  "tamton-aquib/duck.nvim",
  config = function()
    local keymap = vim.keymap

    keymap.set("n", "<leader>zc", function() require("duck").hatch("🐈") end, { desc = "Add cat" })
    keymap.set("n", "<leader>zd", function() require("duck").hatch() end, { desc = "Add duck" })
    keymap.set("n", "<leader>zr", function() require("duck").cook() end, { desc = "Remove" })

  end,
}

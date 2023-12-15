return {
  "christoomey/vim-tmux-navigator",
  config = function()
    local keymap = vim.keymap -- for conciseness
    keymap.set("n", "<C-S-Left>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left" })
    keymap.set("n", "<C-S-Down>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down" })
    keymap.set("n", "<C-S-Up>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up" })
    keymap.set("n", "<C-S-Right>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right" })
  end
}

return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanso").setup({
        minimal = true,
        background = {
          dark = "zen"
        }
      })
    end
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanso",
    },
  }
}

return {
  lazyconfig = {
    {
      "R-nvim/R.nvim",
      lazy = false
    },
    {
      "R-nvim/cmp-r",
      config = function()
        require("cmp_r").setup{}
      end
    },
  },
}

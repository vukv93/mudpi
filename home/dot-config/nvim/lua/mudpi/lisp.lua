return {
  lazyconfig = {
    "olical/conjure",
    {
      "monkoose/nvlime",
      dependencies = {
        "monkoose/parsley",
      },
      init = function()
        vim.g.nvlime_config = {cmp = {enabled = true}}
      end,
    },
  },
}

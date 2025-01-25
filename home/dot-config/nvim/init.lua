local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
local mudpi = {"core"}
local mudpi_ide = {
  full = {"lsp","lisp","r","org","tex"},
  -- @todo[250125_032714] Subconfigs.
  cpp = {},
  lisp = {},
}
local lazyconfig = {}
local function runif(k) if k ~= nil then k{} end end
local function doif(k,f) if k ~= nil then return f(k) end end
doif(mudpi_ide[os.getenv('MUDPI_VIM_IDE')],
function (mods)
  for i,mod in ipairs(mods) do table.insert(mudpi,mod) end
end)
for i,mod in ipairs(mudpi) do
  local m = require("mudpi/"..mod)
  table.insert(lazyconfig, m.lazyconfig)
  runif(m.opts)
end
vim.opt.rtp:prepend(lazypath)
require"lazy".setup{lazyconfig}
for i,mod in ipairs(mudpi) do
  local m = require("mudpi/"..mod)
  runif(m.config)
  runif(m.keymaps)
end

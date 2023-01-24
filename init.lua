-- https://stackoverflow.com/questions/73358168/where-can-i-check-my-neovim-lua-runtimepath
-- ^^^^ check out to resolve path lua plugin issues

-- NOTE: needs to be the root directory of lua_tidalvim

-- vim.g.tidalvim_root = os.getenv("TIDALVIM_ROOT") .. 
vim.g.tidalvim_root = 
  os.getenv("HOME") .. '/.local/share/tidalvim_lua'

vim.o.runtimepath = vim.o.runtimepath .. ", " 
            .. vim.g.tidalvim_root .. ", " 

local huh = require('vim-tidal')

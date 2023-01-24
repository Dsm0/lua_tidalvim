-- https://stackoverflow.com/questions/73358168/where-can-i-check-my-neovim-lua-runtimepath
-- ^^^^ check out to resolve path lua plugin issues

-- NOTE: needs to be the root directory of lua_tidalvim
vim.g.tidalvim_root = os.getenv("CONF_PATH")

vim.o.runtimepath = vim.o.runtimepath .. ", " 
            .. vim.g.tidalvim_root .. ", " 

local huh = require('vim-tidal')


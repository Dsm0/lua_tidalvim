-- https://stackoverflow.com/questions/73358168/where-can-i-check-my-neovim-lua-runtimepath
-- ^^^^ check out to resolve path lua plugin issues
vim.o.runtimepath = vim.o.runtimepath .. ", " .. os.getenv("CONF_PATH")

require("vim-tidal")

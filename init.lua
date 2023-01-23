-- https://stackoverflow.com/questions/73358168/where-can-i-check-my-neovim-lua-runtimepath
-- ^^^^ check out to resolve path lua plugin issues
vim.o.runtimepath = vim.o.runtimepath .. ", " .. os.getenv("CONF_PATH")

-- default essential keybindings
local tidalSend = require('vim-tidal.tidalSend')

vim.api.nvim_set_keymap("n","<c-l>", ':TidalSendBlock<CR>',{})
vim.api.nvim_set_keymap("n","<c-k>", ':TidalSendLine<CR>',{})
-- default useful keybindings

vim.api.nvim_set_keymap("",";",":",{noremap=true})
vim.api.nvim_set_keymap("t","<Esc>","<C-\\><C-n>",{noremap=true})

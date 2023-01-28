-- https://stackoverflow.com/questions/73358168/where-can-i-check-my-neovim-lua-runtimepath
-- ^^^^ check out to resolve path lua plugin issues

-- NOTE: needs to be the root directory of lua_tidalvim

-- vim.g.tidalvim_root = os.getenv("TIDALVIM_ROOT") .. 
vim.g.tidalvim_root = 
  os.getenv("HOME") .. '/.local/share/lua_tidalvim'

vim.o.runtimepath = vim.o.runtimepath .. ", " 
            .. vim.g.tidalvim_root .. ", "

local vimTidal = require('vim-tidal')


vimTidal.defaults.set_default_mappings()
vimTidal.defaults.set_default_settings()
vimTidal.defaults.load_default_plugins()


local luasnip = require('luasnip.loaders.from_snipmate')
                  .load({paths = '/snippets'})

-- require('../plugins/l')
-- require("luasnip.loaders.from_snipmate")

-- vim.api.nvim_set_keymap('x',"<c-d>", ':NERDTreeToggle<CR>',{})
-- vim.api.nvim_exec("imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? 'luasnip-expand-or-jump' : '<Tab>' ",{})

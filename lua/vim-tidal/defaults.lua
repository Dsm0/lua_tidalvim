local tidalSend = require('vim-tidal.tidalSend')
local tidalSolo = require('vim-tidal.tidalSolo')
local fxMode = require('vim-tidal.fxMode')
local fxBindings = require('vim-tidal.fxBindings')

local M = {}

  -- default keybindings
function M.set_default_mappings()

  vim.keymap.set("",";",":",{noremap=true})
  vim.keymap.set("t","<Esc>","<C-\\><C-n>",{noremap=true})

  vim.keymap.set({"n","i","s"},"<c-l>", tidalSend.TidalSendBlock, {silent = true })
  vim.keymap.set({"n","i","s"},"<c-k>", tidalSend.TidalSendLine, {silent = true })

  for i=1,#tidalSolo.orbits do
    vim.keymap.set("n","<M-" .. i .. ">", function() tidalSolo.TidalSoloToggle(i) end, {silent = true})
  end

  vim.keymap.set({"n","i","s"},"<M-0>", tidalSolo.TidalUnsoloAll, {silent = true})

  vim.keymap.set({"n","i","s"},"<M-h>", tidalSolo.TidalHush, {silent = true})

  vim.keymap.set({"n","i","s"},"<M-S-h>", tidalSolo.TidalStreamHush, {silent = true})

  vim.keymap.set({"n"},"<Tab>", fxMode.FxMode, {silent = true})

  vim.keymap.set({"n","i","s"},"<M-R>", tidalSolo.TidalResetCycles, {silent = true})

  vim.keymap.set({"n","i","s"},"<M-d>", function() tidalSend.TidalJumpSendBlock('do$') end, {silent = true})
  
  vim.keymap.set({"n","i","s"},"<M-D>", function() tidalSend.TidalJumpSendBlock('do$','b') end, {silent = true})


  local searchstring="[\\$\\|\\#\\|&\\|\\|+]"

  vim.keymap.set({"n"},"H", "?" .. searchstring .. "<CR>", {silent = true})
  vim.keymap.set({"n"},"L", "/" .. searchstring .. "<CR>", {silent = true})

  vim.cmd('set nohlsearch')

  vim.keymap.set({'n'},"o","o ",{silent=true})
  vim.keymap.set({'n'},"O","O ",{silent=true})

  vim.keymap.set({'n',"x"},"<c-d>", ':NERDTreeToggle<CR>',{})
  vim.keymap.set({''},"<c-/>", ':Commentary<CR>',{})


  vim.keymap.set({"n","i","s"},"<M-e>", (function() 
		  fxBindings.FxStringToReg('e') 
		  vim.cmd("put e")
	  end),{silent = true})

end

-- default launch options (what I use)
-- feel free to use this as a base for building a 
-- more specific configuration in /init.lua
function M.set_default_settings()
  
  -- https://github.com/brainfucksec/neovim-lua/blob/main/nvim/lua/core/options.lua
  vim.opt.expandtab = true        -- Use spaces instead of tabs
  vim.opt.shiftwidth = 2          -- Shift 2 spaces when tab
  vim.opt.tabstop = 2             -- 1 tab == 2 spaces
  vim.opt.smartindent = true      -- Autoindent new lines
  vim.opt.lazyredraw = true
  vim.opt.commentstring = '-- %s'

  vim.opt.relativenumber = true

  local new_tidal_file = function()
    vim.cmd('setfiletype tidal')
    vim.cmd('setlocal syntax=haskell')
  end

  vim.api.nvim_create_autocmd(
      {"BufRead","BufNewFile"},
        {pattern = "*.tidal",
        callback = new_tidal_file
        }
    )

end

function M.load_default_plugins()

  vim.api.nvim_exec('source ' .. vim.g.tidalvim_root .. '/plug.vim',{})
  
  local Plug = vim.fn['plug#']
  
  vim.call('plug#begin', vim.g.tidalvim_root.. '/plugins')
  
  Plug 'jiangmiao/auto-pairs'

  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'preservim/nerdtree'
  Plug 'mbbill/undotree'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'neovimhaskell/haskell-vim'
  
  vim.call('plug#end')

end




return M

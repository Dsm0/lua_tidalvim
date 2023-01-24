-- default essential keybindings
local tidalSend = require('vim-tidal.tidalSend')
local tidalSolo = require('vim-tidal.tidalSolo')
local fxMode = require('vim-tidal.fxMode')

local M = {}

  -- default keybindings
function M.set_default_mappings()

  vim.api.nvim_set_keymap("",";",":",{noremap=true})
  vim.api.nvim_set_keymap("t","<Esc>","<C-\\><C-n>",{noremap=true})

  vim.api.nvim_set_keymap("n","<c-l>", '',
      {callback = tidalSend.TidalSendBlock})
  vim.api.nvim_set_keymap("n","<c-k>", '',
      {callback = tidalSend.TidalSendLine})

  for i=1,#tidalSolo.orbits do
    vim.api.nvim_set_keymap("n","<m-" .. i .. ">", '',
    {callback = function() tidalSolo.TidalSoloToggle(i) end})
  end

  vim.api.nvim_set_keymap("n","<m-0>", '',
    {callback = tidalSolo.TidalUnsoloAll})

  vim.api.nvim_set_keymap("n","<m-h>", '',
    {callback = tidalSolo.TidalHush})

  vim.api.nvim_set_keymap("n","<m-S-h>", '',
    {callback = tidalSolo.TidalStreamHush})

  vim.api.nvim_set_keymap("n","<Tab>", '',
      {callback = fxMode.FxMode})

  vim.api.nvim_set_keymap("n","<m-R>", '',
      {callback = tidalSolo.TidalResetCycles})

  vim.api.nvim_set_keymap('n',"<c-d>", ':NERDTreeToggle<CR>',{})
  vim.api.nvim_set_keymap('x',"<c-d>", ':NERDTreeToggle<CR>',{})
  vim.api.nvim_set_keymap('',"<c-/>", ':Commentary<CR>',{})

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
  
  vim.call('plug#end')

end

return M

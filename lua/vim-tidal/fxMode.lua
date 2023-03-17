local tidalSend = require("vim-tidal.tidalSend")
local fxBindings = require('vim-tidal.fxBindings')
local bindings = fxBindings.bindings
local specialChars = require('vim-tidal.specialChars').specialChars

local M = {}



function M.FxMode()
  vim.cmd("highlight Normal ctermbg=DarkGray")

  char = vim.fn.getchar()
  c = vim.fn.nr2char(char)
  bind = bindings[c]

  while bind ~= 'quit' do

    vim.cmd('redrawstatus!')

    if type(bind) == 'function'
      then bind()
			else print(string.byte(char,1,-1))
    end

    vim.cmd('redrawstatus!')

    char = vim.fn.getchar()

    if specialChars[char] ~= nil -- note: should only satisfy this case if vim.fn.nr2char(char) doesn't return a printable character
      then c = specialChars[char] 
      else c = vim.fn.nr2char(char)
    end

    bind = bindings[c]

  end

  vim.cmd('redrawstatus!')

  vim.cmd("highlight Normal ctermbg=Black")

  return 
end

vim.api.nvim_create_user_command('TidalFxMode', M.FxMode, {nargs = 0, desc = 'enters FxMode, an event loop where you can bind the execution of lua functions to keys specified in fxBindings.lua'})

return M

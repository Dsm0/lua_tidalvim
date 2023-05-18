local tidalSend = require("vim-tidal.tidalSend")
local specialChars = require('vim-tidal.specialChars').specialChars

local M = {}

local fxBindings
local bindings

function M.setFxBindings(new_fxBindings) 
	fxBindings = new_fxBindings
	bindings = new_fxBindings.bindings
end

function M.FxMode()
  if (fxBindings == nil) then
	  vim.notify("ERROR: must load fxBindings in init.lua with:\n require('vim-tidal.fxMode').setFxBindings(<your fxBindings bindings )")
	  return
  end

  vim.cmd("highlight Normal ctermbg=DarkGray")

  char = vim.fn.getchar()

  if specialChars[char] ~= nil -- note: should only satisfy this case if vim.fn.nr2char(char) doesn't return a printable character
    then c = specialChars[char] 
    else c = vim.fn.nr2char(char)
  end

  bind = bindings[c]

  while bind ~= 'quit' do

    vim.cmd('redrawstatus!')

    if type(bind) == 'function'
      then bind() else print(string.byte(char,1,-1))
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

local ftplugin = require("vim-tidal.ftplugin")
local fxBindings = require('vim-tidal.fxBindings')
local bindings = fxBindings.bindings
local specialChars = fxBindings.specialChars

local M = {}

function M.FxMode()
  vim.cmd("highlight Normal ctermbg=DarkGray")

  char = vim.fn.getchar()
  c = vim.fn.nr2char(char)
  bind = bindings[c]

  while bind ~= 'quit' do

    if type(bind) == 'function'
      then bind()
      -- else print('????? ', char, c, bind)
    end

    vim.cmd('redrawstatus!')
    -- vim.cmd('silent! echom ""')

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

return M

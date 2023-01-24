local ftplugin = require("vim-tidal.ftplugin")
local fxBindings = require('vim-tidal.fxBindings')
local bindings = fxBindings.bindings

local M = {}

function M.FxMode()
  vim.cmd("highlight Normal ctermbg=DarkGray")

  local char = vim.fn.getchar()
  local c = vim.fn.nr2char(char)
  local bind = bindings[c]

  while bind ~= 'quit' do

    if type(bind) == 'function'
      then bind()
      -- else print('????? ', vim.fn.char2nr(char), c, bind)
    end

    vim.cmd('redrawstatus!')
    vim.cmd('silent! echom ""')

    char = vim.fn.getchar()
    print(char)

    -- TODO: figure out how to case on fucking backspace
    if char == 128 
      then c = 'BACKSPACE'
      else c = vim.fn.nr2char(char)
    end

    bind = bindings[c]


  end


  vim.cmd('redrawstatus!')

  vim.cmd("highlight Normal ctermbg=Black")

  return 
end

return M

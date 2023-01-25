local ftplugin = require('vim-tidal.ftplugin')

local M = {}

function M.TidalSendBlock()

  vim.api.nvim_exec('normal!ml',{})
  -- save the location of the last tidal evaluation to mark l

  local pos = vim.fn.getpos('.')

  vim.api.nvim_exec('normal!"tyip',{}) -- yanks block to register 't'
  ftplugin.TidalSendRegister('t')
  -- vim.api.nvim_input('<Esc>')

  vim.fn.setpos('.',pos)

end

function M.TidalJumpSendBlock(x,opts)
  opts = opts or ''
  vim.fn.search(x,opts)
  M.TidalSendBlock();
end

function M.TidalSendLine()

  vim.api.nvim_exec('normal!ml',{}) 
  -- save the location of the last tidal evaluation to mark l

  local pos = vim.fn.getpos('.')

  vim.api.nvim_exec('normal!"tyy',{}) -- yanks line to register 't'
  ftplugin.TidalSendRegister('t')
  -- vim.api.nvim_input('<Esc>')

  vim.fn.setpos('.',pos)

end


vim.api.nvim_create_user_command('TidalSendLine', M.TidalSendLine, {nargs = 0, desc = 'send individual line of text to tidal process using register "t"'})

vim.api.nvim_create_user_command('TidalSendBlock', M.TidalSendBlock, {nargs = 0, desc = 'send the block of text the cursor is on to tidal process using register "t"'})

return M

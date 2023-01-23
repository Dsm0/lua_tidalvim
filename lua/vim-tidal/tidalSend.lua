local ftplugin = require('vim-tidal.ftplugin')

function TidalSendBlock()

  local pos = vim.fn.getpos('.')

  vim.api.nvim_exec('normal!"tyip',{}) -- yanks block to register 't'
  ftplugin.TidalSendRegister('t')
  vim.api.nvim_input('<Esc>')

  vim.fn.setpos('.',pos)

end

function TidalSendLine()

  local pos = vim.fn.getpos('.')

  vim.api.nvim_exec('normal!"tyy',{}) -- yanks line to register 't'
  ftplugin.TidalSendRegister('t')
  vim.api.nvim_input('<Esc>')

  vim.fn.setpos('.',pos)

end

vim.api.nvim_create_user_command('TidalSendLine', TidalSendLine, {nargs = 0, desc = 'send individual line of text to tidal process'})

vim.api.nvim_create_user_command('TidalSendBlock', TidalSendBlock, {nargs = 0, desc = 'send the block of text the cursor is on to tidal process'})

return {TidalSendBlock, TidalSendLine}

-- api.nvim_command('botright split new') -- split a new window 
-- api.nvim_win_set_height(0, 30)) -- set the window height 
-- win_handle = api.nvim_tabpage_get_win(0) -- get the window handler 
-- buf_handle = api.nvim_win_get_buf(0) -- get the buffer handler 
-- -- run your stuff here, could be anything 



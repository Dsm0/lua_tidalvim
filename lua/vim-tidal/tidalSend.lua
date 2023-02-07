local M = {}

local tidal_channel = -1

M.tidal_term_active = -1

function M.TidalOpen()
  if M.tidal_term_active ~= -1 then return end
  M.tidal_term_active = 1

  local og_win = vim.api.nvim_get_current_win()

  -- TODO: make tidal open in background
  -- and make any compiler errors pop up side windows
  -- (that will be closed again when another command is 
  -- successfully run)

  vim.api.nvim_command('botright split term')

  tidal_channel = vim.fn.termopen('tidal')
  vim.api.nvim_exec('normal!G',{})

  vim.api.nvim_set_current_win(og_win)
  vim.api.nvim_win_set_height(og_win,20)

  return og_win

end


function M.TidalSend(text)
  if M.tidal_term_active == -1 
    then M.TidalOpen() 
  end
  vim.api.nvim_chan_send(tidal_channel,text .. "\r")
end


function M.TidalSendRegister(reg)
  local txt = vim.fn.getreg(reg)

  -- TODO: should process text a bit more
  M.TidalSend('\n:{\r' .. txt .. ":}")
end

local function TidalSendRegisterCmd(args)
  local reg = args.fargs[1]
  M.TidalSendRegister(reg)
end


function M.TidalSendBlock()

  local og_reg_text = vim.fn.getreg("")
  vim.api.nvim_exec('normal!ml',{})
  -- save the location of the last tidal evaluation to mark l

  local pos = vim.fn.getpos('.')

  vim.api.nvim_exec('normal!"tyip',{}) -- yanks block to register 't'
  M.TidalSendRegister('t')
  -- vim.api.nvim_input('<Esc>')
  --

  vim.fn.setpos('.',pos)
  vim.fn.setreg('',og_reg_text)

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
  M.TidalSendRegister('t')
  -- vim.api.nvim_input('<Esc>')

  vim.fn.setpos('.',pos)

end

vim.api.nvim_create_user_command('TidalSendLine', M.TidalSendLine, {nargs = 0, desc = 'send individual line of text to tidal process using register "t"'})

vim.api.nvim_create_user_command('TidalSendBlock', M.TidalSendBlock, {nargs = 0, desc = 'send the block of text the cursor is on to tidal process using register "t"'})

vim.api.nvim_create_user_command('TidalOpen', M.TidalOpen, {nargs = 0, desc = 'start tidal process'})

vim.api.nvim_create_user_command('TidalSendRegister', TidalSendRegisterCmd, {nargs = 1, desc = 'send text in the specified register to tidal'})

return M

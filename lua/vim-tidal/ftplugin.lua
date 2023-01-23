local M = {}

M.tidal_term_active = -1
local tidal_channel = -1

function M.TidalOpen()
  if M.tidal_term_active ~= -1 then return end
  M.tidal_term_active = 1

  local og_tab = vim.api.nvim_tabpage_get_number(0)

  -- TODO: make tidal open in background
  -- and make any compiler errors pop up side windows
  -- (that will be closed again when another command is 
  -- successfully run)

  vim.api.nvim_command('split term')

  -- local tidal_buf = vim.api.nvim_create_buf(true, true)
  -- vim.api.nvim_set_current_buf(tidal_buf)

  tidal_channel = vim.fn.termopen('tidal')

  -- vim.api.nvim_tabpage_set_number(og_tab) -- silly that they don't have such a function imo
  
  vim.api.nvim_command('tabn ' .. og_tab )

  -- vim.api.nvim_set_current_buf(txt_buf)

  -- vim.api.nvim_chan_send(tidal_channel,"tidal\r")

end


function M.TidalSend(text)
  if M.tidal_term_active == -1 then
    print("tidal not open")
    return
  end
  vim.api.nvim_chan_send(tidal_channel,text .. "\r")
end


-- source: https://neovim.discourse.group/t/function-that-return-visually-selected-text/1601
local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")

  -- if (s_start[1] == s_end[1] 
  --     and s_start[2] == s_end[2] 
  --     and s_start[3] == s_end[3]) then return '' end

  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

  
-- -- BUGGY
-- function M.TidalSendSelection()
--   local txt = get_visual_selection()
--   if M.tidal_term_active == -1 
--     then M.TidalOpen() 
--   end
--   -- TODO: should process text a bit more
--   M.TidalSend('\n:{\r' .. txt .. "\r:}")
-- end


function M.TidalSendRegister(reg)
  local txt = vim.fn.getreg(reg) -- get_visual_selection()
  if M.tidal_term_active == -1 
    then M.TidalOpen() 
  end
  -- TODO: should process text a bit more
  M.TidalSend('\n:{\r' .. txt .. ":}")
end

vim.api.nvim_create_user_command('TidalOpen', M.TidalOpen, {nargs = 0, desc = 'start tidal process'})

-- it was more consistent to just yank the paragraph into a register
-- than to have to use nvim_buf_get_lines
-- vim.api.nvim_create_user_command('TidalSendSelection', M.TidalSendSelection, {nargs = 0, desc = 'send selected text to tidal'})

vim.api.nvim_create_user_command('TidalSendRegister', M.TidalSendRegister, {nargs = 1, desc = 'send text in the specified register to tidal'})


return M

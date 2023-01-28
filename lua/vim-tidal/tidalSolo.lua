local tidalSend = require("vim-tidal.tidalSend")

local M = {}

M.orbits = {0,0,0,0,0,0,0,0,0}

-- usually use a max of 9 orbits, 
-- could easilly add more

function M.TidalSoloedAsString()
  return table.concat(M.orbits,',')
end


function M.TidalUnsoloAll()

  for i=1,#M.orbits do
    M.orbits[i] = 0
  end

  tidalSend.TidalSend('streamUnsoloAll tidal')

end


-- NOTE: I have different bindings for sending
-- `hush` and `streamHush tidal` because
-- I have hush defined differently in my config

function M.TidalHush()
  tidalSend.TidalSend('hush')
end

function M.TidalStreamHush()
  tidalSend.TidalSend('streamHush tidal')
end

function M.TidalResetCycles()
  tidalSend.TidalSend('streamResetCycles tidal')
end

function M.TidalSoloToggle(orbit)
  if (orbit > #M.orbits or orbit < 1) 
    then print("invalid orbit: ", orbit)
      return else
      if M.orbits[orbit] == 0
        then 
          tidalSend.TidalSend('solo ' .. orbit)
          M.orbits[orbit] = 1
        else
          tidalSend.TidalSend('unsolo ' .. orbit)
          M.orbits[orbit] = 0
      end
  end
end

local function TidalSoloToggleCmd(args)
  local orbit = args.fargs[1]
  M.TidalSendRegister(orbit)
end

vim.api.nvim_create_user_command('TidalSoloToggle', TidalSoloToggleCmd, {nargs = 1, desc = 'toggles solo on/off for specified orbit'})

vim.api.nvim_create_user_command('TidalUnsoloAll', M.TidalUnsoloAll, {nargs = 0, desc = 'unsolos all orbits'})

vim.api.nvim_create_user_command('TidalHush', M.TidalHush, {nargs = 0, desc = 'hush tidal'})

vim.api.nvim_create_user_command('TidalStreamHush', M.TidalStreamHush, {nargs = 0, desc = 'streamHush tidal'})

return M

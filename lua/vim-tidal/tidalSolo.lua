local ftplugin = require("vim-tidal.ftplugin")

local M = {}

M.orbits = {0,0,0,0,0,0,0,0,0}

-- usually use a max of 9 orbits, 
-- could easilly add more

function M.TidalUnsoloAll()
  for i=1,#M.orbits do
    M.orbits[i] = 0
  end
  ftplugin.TidalSend(('mapM_ unsolo [1..'.. #M.orbits ..']'))
end


function M.TidalHush()
  ftplugin.TidalSend('hush')
end

function M.TidalStreamHush()
  ftplugin.TidalSend('streamHush tidal')
end

function M.TidalSoloToggle(orbit)
  if (orbit > #M.orbits or orbit < 1) 
    then print("invalid orbit: ", orbit)
      return else
      if M.orbits[orbit] == 0
        then 
          ftplugin.TidalSend('solo ' .. orbit)
          M.orbits[orbit] = 1
        else
          ftplugin.TidalSend('unsolo ' .. orbit)
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

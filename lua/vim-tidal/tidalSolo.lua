local ftplugin = require("vim-tidal.ftplugin")

local M = {}

M.orbits = {0,0,0,0,0,0,0,0,0}

-- usually use a max of 9 orbits, 
-- could easilly add more but

function M.ShowSolos()
  print(M.orbits)
end

function M.TidalUnsoloAll()
  for i=1,#M.orbits do
    M.orbits[i] = 0
  end
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

-- vim.api.nvim_create_user_command('TidalSoloToggle', M.TidalSoloToggle, {nargs = 1, desc = 'toggles solo on/off for specified orbit'})

return M

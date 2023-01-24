-- NOTE: this file should be changed to suit the user's needs.
-- fxMode should be a state where every key somehow changes 
-- an internal data structure denoting a configuration of effects,
-- whatever that entails....

-- this file might balloon in complexity and warrent its own seperate 
-- directory, but the keyboard interface this implements is what I'm 
-- used to


local tidalSolo = require('vim-tidal.tidalSolo')
local ftplugin = require('vim-tidal.ftplugin')

local effectsChain = ''

local M = {}

function M.GetFxStatus()
  return effectsChain
end

local function SendFx()
  local tosend = 'all $ id '

  for c in effectsChain:gmatch"." do
    tosend = tosend .. '. eff_' .. c .. ' '
  end

  ftplugin.TidalSend(tosend)
end

function TidalPushEffect(effect)
  effectsChain = effectsChain .. effect
  SendFx()
end

function TidalPopEffect()
  if #effectsChain == 0 
    then print('no effects to pop')
    else effectsChain = effectsChain:sub(1,-2)
  end
  SendFx()
end

function TidalRestoreEffects()
  SendFx()
end

function TidalResetEffects()
  effectsChain = ""
  SendFx()
end



function mkBind(x)
  willPush = function()
    TidalPushEffect(x)
  end
  return willPush
end


-- function unichr(ord)
--     if ord == nil then return nil end
--     if ord < 32 then return string.format('\\x%02x', ord) end
--     if ord < 126 then return string.char(ord) end
--     if ord < 65539 then return string.format("\\u%04x", ord) end
--     if ord < 1114111 then return string.format("\\u%08x", ord) end
-- end


-- TODO: figure out how to case on fucking backspace
-- as well as get numbers in there, etc...
local tab = '\9'
local esc = '\x1b'
local ret = '\13' -- return
local backspace = '\x08' 
-- local backspace = '\x7f'-- vim.fn.nr2char(126)

M.bindings = {
  ['a'] = mkBind("a"),  
  ['b'] = mkBind("b"),  
  ['c'] = mkBind("c"),  
  ['d'] = mkBind("d"),  
  ['e'] = mkBind("e"),  
  ['f'] = mkBind("f"),  
  ['g'] = mkBind("g"),  
  ['h'] = mkBind("h"),  
  ['i'] = mkBind("i"),  
  ['j'] = mkBind("j"),  
  ['k'] = mkBind("k"),  
  ['l'] = mkBind("l"),  
  ['m'] = mkBind("m"),  
  ['n'] = mkBind("n"),  
  ['o'] = mkBind("o"),  
  ['p'] = mkBind("p"),  
  ['q'] = mkBind("q"),  
  ['r'] = mkBind("r"),  
  ['s'] = mkBind("s"),  
  ['t'] = mkBind("t"),  
  ['u'] = mkBind("u"),  
  ['v'] = mkBind("v"),  
  ['w'] = mkBind("w"),  
  ['x'] = mkBind("x"),  
  ['y'] = mkBind("y"),  
  ['z'] = mkBind("z"),  
  ['A'] = mkBind("A"),
  ['B'] = mkBind("B"),
  ['C'] = mkBind("C"),
  ['D'] = mkBind("D"),
  ['E'] = mkBind("E"),
  ['F'] = mkBind("F"),
  ['G'] = mkBind("G"),
  ['H'] = mkBind("H"),
  ['I'] = mkBind("I"),
  ['J'] = mkBind("J"),
  ['K'] = mkBind("K"),
  ['L'] = mkBind("L"),
  ['M'] = mkBind("M"),
  ['N'] = mkBind("N"),
  ['O'] = mkBind("O"),
  ['P'] = mkBind("P"),
  ['Q'] = mkBind("Q"),
  ['R'] = mkBind("R"),
  ['S'] = mkBind("S"),
  ['T'] = mkBind("T"),
  ['U'] = mkBind("U"),
  ['V'] = mkBind("V"),
  ['W'] = mkBind("W"),
  ['X'] = mkBind("X"),  
  ['Y'] = mkBind("Y"), 
  ['Z'] = mkBind("Z"),  
  ['0'] = tidalSolo.UnsoloAll,
  ['\9'] = "quit",
  [ret] = TidalResetEffects,
  ['`'] = TidalPopEffect,
  [backspace] = TidalPopEffect,
  [esc] = "quit"
}

return M

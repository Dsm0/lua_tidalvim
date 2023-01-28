-- NOTE: this file should be changed to suit the user's needs.
-- fxMode should be a state where every key somehow changes 
-- an internal data structure denoting a configuration of effects,
-- whatever that entails....

-- this file might balloon in complexity and warrent its own seperate 
-- directory, but the keyboard interface this implements is what I'm used to

local tidalSolo = require('vim-tidal.tidalSolo')
local tidalSend = require('vim-tidal.tidalSend')

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

  tidalSend.TidalSend(tosend)
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

function TidalClearEffects()
  tidalSend.TidalSend('all $ id')
end

function TidalClearEffectsUnsolo()
  tidalSolo.TidalUnsoloAll()
  tidalSend.TidalSend('all $ id')
end

function mkEffectBind(x)
  willPush = function()
    TidalPushEffect(x)
  end
  return willPush
end

function mkSoloBind(x)
  willSolo = function()
    tidalSolo.TidalSoloToggle(x)
  end
  return willSolo
end


-- TODO: refactor into 
function mkFxModeBind(x)
  willCall = function() 
    x()
    vim.call("TidalFxMode") 
  end
  return willCall
end








local tab = '\9'
local esc = '\x1b'
local ret = '\13' -- return
-- local backspace = tostring('\80kb')


-- some keys return valid key codes but can't be converted to characters with nr2char
-- ie: 
-- c = vim.fn.getchar()
-- c ~= vim.fn.char2nr(vim.fn.nr2char(c)) 
-- for example, this is true for the bcakspace key

-- if that's the case, they should be defined here
-- NOTE: if it CAN reliably be converted to a readable character
-- then it should not be defined in specialChars

-- use 
-- :lua print(string.byte(vim.fn.getchar(),1,-1))
-- to find the bytes for any valid key combo
M.specialChars = {
  ['\120\107\98'] = "<BS>",
  ['\128\252\2\13'] = "<S-Enter>",
  ['\128\252\8\13'] = "<M-Enter>",
  ['\128\252\8\48'] = "<M-0>",
  ['\128\252\10\48'] = "<M-(>",
}

M.bindings  = {
  ['a'] = mkEffectBind("a"),  
  ['b'] = mkEffectBind("b"),  
  ['c'] = mkEffectBind("c"),  
  ['d'] = mkEffectBind("d"),  
  ['e'] = mkEffectBind("e"),  
  ['f'] = mkEffectBind("f"),  
  ['g'] = mkEffectBind("g"),  
  ['h'] = mkEffectBind("h"),  
  ['i'] = mkEffectBind("i"),  
  ['j'] = mkEffectBind("j"),  
  ['k'] = mkEffectBind("k"),  
  ['l'] = mkEffectBind("l"),  
  ['m'] = mkEffectBind("m"),  
  ['n'] = mkEffectBind("n"),  
  ['o'] = mkEffectBind("o"),  
  ['p'] = mkEffectBind("p"),  
  ['q'] = mkEffectBind("q"),  
  ['r'] = mkEffectBind("r"),  
  ['s'] = mkEffectBind("s"),  
  ['t'] = mkEffectBind("t"),  
  ['u'] = mkEffectBind("u"),  
  ['v'] = mkEffectBind("v"),  
  ['w'] = mkEffectBind("w"),  
  ['x'] = mkEffectBind("x"),  
  ['y'] = mkEffectBind("y"),  
  ['z'] = mkEffectBind("z"),  
  ['A'] = mkEffectBind("A"),
  ['B'] = mkEffectBind("B"),
  ['C'] = mkEffectBind("C"),
  ['D'] = mkEffectBind("D"),
  ['E'] = mkEffectBind("E"),
  ['F'] = mkEffectBind("F"),
  ['G'] = mkEffectBind("G"),
  ['H'] = mkEffectBind("H"),
  ['I'] = mkEffectBind("I"),
  ['J'] = mkEffectBind("J"),
  ['K'] = mkEffectBind("K"),
  ['L'] = mkEffectBind("L"),
  ['M'] = mkEffectBind("M"),
  ['N'] = mkEffectBind("N"),
  ['O'] = mkEffectBind("O"),
  ['P'] = mkEffectBind("P"),
  ['Q'] = mkEffectBind("Q"),
  ['R'] = mkEffectBind("R"),
  ['S'] = mkEffectBind("S"),
  ['T'] = mkEffectBind("T"),
  ['U'] = mkEffectBind("U"),
  ['V'] = mkEffectBind("V"),
  ['W'] = mkEffectBind("W"),
  ['X'] = mkEffectBind("X"),  
  ['Y'] = mkEffectBind("Y"), 
  ['Z'] = mkEffectBind("Z"),  
  ["0"] = tidalSolo.TidalUnsoloAll,
  ["1"] = mkSoloBind(1),
  ["2"] = mkSoloBind(2),
  ["3"] = mkSoloBind(3),
  ["4"] = mkSoloBind(4),
  ["5"] = mkSoloBind(5),
  ["6"] = mkSoloBind(6),
  ["7"] = mkSoloBind(7),
  ["8"] = mkSoloBind(8),
  ["9"] = mkSoloBind(9),
  [")"] = TidalClearEffectsUnsolo,
  [" "] = TidalClearEffects,
  ['+'] = (function() tidalSend.TidalJumpSendBlock('do$') end) ,
  ['_'] = (function() tidalSend.TidalJumpSendBlock('do$','b') end),
  ['\t'] = "quit",
  [ret] = TidalResetEffects,
  ['`'] = TidalPopEffect,
  ['<BS>'] = TidalPopEffect,
  ['<S-Enter>'] = TidalResetEffects,
  [esc] = "quit",
}

return M

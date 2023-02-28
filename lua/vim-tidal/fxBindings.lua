-- NOTE: this file should be changed to suit the user's needs.
-- fxMode should be a state where every key somehow changes 
-- an internal data structure denoting a configuration of effects,
-- whatever that entails....

-- this file might balloon in complexity and warrent its own seperate 
-- directory, but the keyboard interface this implements is what I'm used to

local tidalSolo = require('vim-tidal.tidalSolo')
local tidalSend = require('vim-tidal.tidalSend')

local effectsChain = ''

local fxIndex = 0

local INDEXCHAR = '+'
local M = {}

local function insertAt(s,c,i)
	if ((i < 0) or (i > #s)) then
		print("invalid index passed to 'insertAt': ", i)
		return s
	end

	local headStr = string.sub(s,1,i)
	local tailStr = string.sub(s,i+1,-1)

	return headStr .. c .. tailStr
end


local function removeAt(s,i)
	if ((i < 0) or (i > #s)) then
		print("invalid index passed to 'removeAt': ", i)
		return s
	end

	local headStr = string.sub(s,1,i-1)
	local tailStr = string.sub(s,i+1,-1)

	return headStr .. tailStr
end

function M.GetFxStatus()
	if #effectsChain == 0
		then return INDEXCHAR
		else return insertAt(effectsChain,INDEXCHAR,fxIndex)
	end
end

local function TidalFxIndexStart()
	fxIndex = 0
end

local function TidalFxIndexEnd()
	fxIndex = #effectsChain
end

local function TidalFxIndexRight()
	fxIndex = math.min(fxIndex + 1,#effectsChain)
end

local function TidalFxIndexLeft()
	fxIndex = math.max(fxIndex - 1,0)
end

local function getFxString()
  local tosend = 'id'

  for c in effectsChain:gmatch"%g" do
    tosend = tosend .. '.eff_' .. c
  end

  return tosend
end

function M.FxStringToReg(reg)
  vim.fn.setreg(reg,getFxString())
end


local function SendFx()
  local tosend = 'all $ ' .. getFxString()

  tidalSend.TidalSend(tosend)
end

function TidalPushEffect(effect)
  effectsChain = insertAt(effectsChain,effect,fxIndex)
  fxIndex = fxIndex + 1

  SendFx()
end



function TidalRemoveEffect()
  if #effectsChain == 0 
    then 
		print('no effects to pop')
		return
  end
  if fxIndex == 0 
    then 
		print("can't remove nothing")
		return
  end
  effectsChain = removeAt(effectsChain,fxIndex)
  fxIndex = fxIndex - 1
  SendFx()
end

function TidalRemoveEffectRight()
  if #effectsChain == 0 
    then 
		print('no effects to pop')
		return
  end
  if fxIndex >= #effectsChain
    then 
		print("can't remove nothing")
		return
  end

  effectsChain = removeAt(effectsChain,fxIndex+1)
  
  SendFx()
end

function TidalDequeueEffect()
  if #effectsChain == 0 
    then 
		print('no effects to dequeue')
		return
  end

  effectsChain = effectsChain:sub(2)
  SendFx()

end

function TidalRestoreEffects()
  SendFx()
end

function TidalResetEffects()
  effectsChain = ""
  fxIndex = 0
  SendFx()
end

function TidalClearEffects()
  tidalSend.TidalSend('all $ id')
end

function TidalClearEffectsUnsolo()
  tidalSolo.TidalUnsoloAll()
  tidalSend.TidalSend('all $ id')
end

function TidalResetEffectsUnsolo()
  effectsChain = ""
  fxIndex = 0
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


local tab = '\9'
local esc = '\x1b'
local ret = '\13' -- return


-- NOTE:
-- any more complex combo of bindings
-- like <M-Del>
-- is defined manually in specialChars.lua
-- will probably either change this,
-- or find some way to fnagle neovim's keybinding system

-- a core design goal is to make sure you can distribute fxBindings.lua as a 
-- single file (or a single directory)
-- and have different users create and share their own bindings for fxMode

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
  ["1"] = mkSoloBind(1),
  ["2"] = mkSoloBind(2),
  ["3"] = mkSoloBind(3),
  ["4"] = mkSoloBind(4),
  ["5"] = mkSoloBind(5),
  ["6"] = mkSoloBind(6),
  ["7"] = mkSoloBind(7),
  ["8"] = mkSoloBind(8),
  ["9"] = mkSoloBind(9),
  ["0"] = tidalSolo.TidalUnsoloAll,
  [")"] = TidalClearEffectsUnsolo,
  -- [" "] = TidalToggleFront, -- TODO: find a good use of <space> in fxMode
  ['+'] = (function() tidalSend.TidalJumpSendBlock('do$') end) ,
  ['_'] = (function() tidalSend.TidalJumpSendBlock('do$','b') end),
  ['='] = (function() tidalSend.TidalJumpSendBlock('do$') end) ,
  ['-'] = (function() tidalSend.TidalJumpSendBlock('do$','b') end),
  ['\t'] = "quit",
  [ret] = TidalResetEffects,
  ['`'] = TidalRemoveEffect,
  ['<BS>'] = TidalRemoveEffect,
  ['<M-BS>'] = TidalRemoveEffect,
  ['<M-Del>'] = TidalRemoveEffectRight,
  ['<Del>'] = TidalRemoveEffectRight,
  ['<S-Enter>'] = TidalResetEffectsUnsolo,
  ['<M-h>'] = TidalFxIndexLeft,
  ['<M-H>'] = TidalFxIndexStart,
  ['<M-l>'] = TidalFxIndexRight,
  ['<M-L>'] = TidalFxIndexEnd,
  ['<LeftArrow>'] = TidalFxIndexLeft,
  ['<UpArrow>'] = mkEffectBind('»'),
  ['<RightArrow>'] = TidalFxIndexRight,
  [esc] = "quit"
}

return M

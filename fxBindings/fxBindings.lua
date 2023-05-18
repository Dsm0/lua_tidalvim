-- NOTE: this file should be changed to suit the user's needs.
-- fxMode should be a state where every key somehow changes 
-- an internal data structure denoting a configuration of effects,
-- whatever that entails....

-- this file might balloon in complexity and warrent its own seperate 
-- directory, but the keyboard interface this implements is what I'm used to

local queue = loadfile(vim.g.tidalvim_root .. '/fxBindings/queue.lua')()

local fxHistory = queue.new()

local tidalSolo = require('vim-tidal.tidalSolo')
local tidalSend = require('vim-tidal.tidalSend')

local setFxValueList = {0,1,2,3,4,5,6,7,8,9,10,11,12}
local setFxValueOffset = 0

local effectsChain = ''

local fxIndex = 0
local fxCount  = 0
local lastPush = nil

local incScale = 1

local valBar = false

local INDEXCHAR = '+'


local M = {}

local function toggleBar()
	valBar = not(valBar)
end

function M.GetBarStatus()
	if valBar
		then return "#̷̧̧̧̡̨̧̲͙̩̜̺̥͈̣̤̺̩̥̼̻̝̝̬̱̼̭̠̖̰̺͍̞̖͔̘͈̩̪̖̗̗̭̱̱̱͎͉̩̻̣̲̩͔̳̗̮͖̱͎̼̟̱̬̦̺͓̼̹̺̟̦̣͎͖͉̱̤͇̯̺͔̠̹͈̻̜̪̗̼̩̮̙̺͈̘̫̗͕̫̦̺̙̹͚̙̱̳̘̭̤́͛͒̋̈́̓̀̒͒̋̎̒̅̓̒̃̓̏̎̑͗͋̈̌̈́̅̔͆̑͐́͘͠͝͝ͅͅͅͅͅͅ#̵̡̢̨̨̡̡̡̨̨̛̭̩̺̪͖̯͖̠͔̹̹̮̭̟͈͎̮̣̳̼̯̣͔̙̩͓̭̼̥͙͍͇̹̰̰̫̰̝̹͓̰͔̮̠̱͇̥̬̭̦̦͓͖͕̫̫̤̘͍̭͕͕̠̦͈̝̹̺̦̬̣̼̜͉̜͍̰̘̲̤̮͇͚͐̂̎̍͒̔͌̂̊́̏͑̉̃̓̑̉̎̑̈͌̄͌͑̽̈́̅́̐̔́̈́̍̂̆͊͑͋̈̿͂͑͋̈́̍͆͛̉͊̓͘̕̕̚̕͜͜͜͝͝ͅͅͅ#̵̨̨̨̨̨̢̡̨̢̧̡̡̧̛̛̪̺͓̤̹̹̱̥͚̯̮̹̱̟̥͎͓̙̫̗̪̟̥̹̣̗͕̬̮͉̩̭̳͇̪̲͎̗̪̝͈̗̟͙̲̬̞̯̺̩̝͚̥̱͚̟̹͈͈̰̯̙̬̺̲͕̬̼̞̲̰̺͔͙͉͚̤̫̞̘͙͍̪̯͇̳͍̝̩̪̤̬̏̀̾̾̊̐̅̅̉̒̌͐̊̈́͛̆͂̎̌̀̋̆̅̇̌̈́̇͐̏̑̔̈́́̂̑̇͛̎̄̇̀͛̈̿̓̓̒̃̓͊̀̆̌̆͑͌̋͑͘̕̚̚̕͜͜͜͠͝͝ͅͅͅͅͅ"
		else return ""
	end
end

function M.getBar()
	return valBar
end


local function insertAt(s,c,i)
	if ((i < 0) or (i > #s)) then
		print("invalid index passed to 'insertAt': ", i)
		return s
	end

	local headStr = string.sub(s,1,i)
	local tailStr = string.sub(s,i+1,-1)

	return headStr .. c .. tailStr
end

local function insertFxAt(s,c,index)
	if ((fxIndex < 0) or (fxIndex > fxCount)) then
		print("invalid fxIndex passed to 'insertFxAt': ", index)
		return s
	end
	
	local i, _ = getNthMatchRange(',',s,index)

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


local function replaceBetween(s,ns,first,last)
	if ((first < 0) or (last > #s)) then
		print("invalid index passed to 'removeAt': ", i)
		return s
	end

	local headStr = string.sub(s,1,first-1)
	local tailStr = string.sub(s,last+1,-1)

	return headStr .. ns .. tailStr
end


function M.GetFxBarValues()
	-- return table.concat(setFxValueList,",") .. " off " .. setFxValueOffset
	return "incBy: " .. incScale .." off: " .. setFxValueOffset
end

function M.GetFxStatus()

	first, _ = getNthMatchRange('[_%a]',effectsChain,fxIndex)
	
	if #effectsChain == 0
		then return INDEXCHAR
		else return insertAt(effectsChain,INDEXCHAR,first)
	end

end



local function TidalFxIndexStart()
	fxIndex = 0
end

local function TidalFxIndexEnd()
	fxIndex = fxCount
end

local function TidalFxIndexRight()
	fxIndex = math.min(fxIndex + 1,fxCount)
end

local function TidalFxIndexLeft()
	fxIndex = math.max(fxIndex - 1,0)
end

local function getFxString()
  return 'effStr "' .. effectsChain .. '"'
end

function M.FxStringToReg(reg)
  vim.fn.setreg(reg,getFxString())
end


local function SendFx()
  queue.pushleft(fxHistory,{effectsChain,fxIndex})
  local tosend = 'all $ ' .. getFxString()

  tidalSend.TidalSend(tosend)
end


local function prevFx()
  if(not(queue.isEmpty(fxHistory)))
	then 
	  new_effectsChain, new_fxIndex = unpack(queue.popleft(fxHistory))
	  if(new_effectsChain == effectsChain)
	    then 
		  effectsChain, fxIndex = unpack(queue.popleft(fxHistory))
		else 
		  effectsChain, fxIndex = new_effectsChain, new_fxIndex
	  end
	  local tosend = 'all $ ' .. getFxString()
  	  tidalSend.TidalSend(tosend)
	else
	  print("fxHistory empty")
  end
end

function TidalPushEffect(effect)
  
  if fxIndex == lastFxIndex 
	  and lastPush == effect 
	  and fxCount > 0 then
	  TidalIncFxVal(incScale)
	  return
  end

  effectsChain = insertFxAt(effectsChain,effect,fxIndex)

  fxCount = fxCount + 1
  fxIndex = fxIndex + 1

  lastFxIndex = fxIndex
  lastPush = effect

  SendFx()
end


function getNthMatch(pat, str, n)
  local i = 1
  for match in string.gmatch(str, pat) do
	if i == n
		then return match
	end
	i = i + 1
  end
  return "no match :_:"
end

function getNthMatchRange(pat, str, n)
  local i = 1
  for match in string.gmatch(str, '()' .. pat) do
	if i == n
		then return str:find(pat,match)
	end
	i = i + 1
  end
  return 0
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

-- edge case: when the last character is negative

  first, last = getNthMatchRange('[_%a](-?%d+),',effectsChain,fxIndex)
  effectsChain = replaceBetween(effectsChain, '', first, last)

  fxCount = fxCount - 1
  fxIndex = fxIndex - 1
  SendFx()

end

local function shiftFxValueOffset(n)
	willShift = function()
		setFxValueOffset = setFxValueOffset + n
	end
	return willShift
end

local function resetFxValueOffset()
	willShift = function()
		setFxValueOffset = 0
	end
	return willShift
end

local function barToggleBind(f1, f2)
	return function()
		if valBar then return f2() else return f1() end
	end
end


function TidalRemoveEffectRight()
	TidalFxIndexRight()
	TidalRemoveEffect()
end

function TidalIncFxVal(i)
	if fxCount == 0 then 
		print("can't inc nothing")
		return
	end

	if fxIndex == 0 then 
		TidalFxIndexRight()
	end

	first, last = getNthMatchRange('(-?%d+),',effectsChain,fxIndex)
	val = tonumber(effectsChain:match('(-?%d+),',first-1))

	if val == nil then
		print(string.format('val was nil (???). first: %s last: %s fxIndex: %s fxChain: %s', first, last, fxIndex, effectsChain))
		return
	end

	val = val + i
	effectsChain = replaceBetween(effectsChain, val, first, last-1)
	SendFx()
end

function TidalSetFxVal(i)
	if fxCount == 0 then 
		print("can't inc nothing")
		return
	end

	if fxIndex == 0 then 
		TidalFxIndexRight()
	end

	first, last = getNthMatchRange('(-?%d+),',effectsChain,fxIndex)
	val = i

	if val == nil then
		print(string.format('val was nil (???). first: %s last: %s fxIndex: %s fxChain: %s', first, last, fxIndex, effectsChain))
		return
	end

	effectsChain = replaceBetween(effectsChain, val, first, last-1)
	SendFx()
end



function TidalMkMark(mark)
	vim.api.nvim_exec('normal!m' .. mark,{}) 
	print(string.format("mark %s set at %s", mark, vim.fn.line('.')))
end


function TidalResetEffects()
  effectsChain = ""
  fxIndex = 0
  fxCount = 0
  lastFxIndex = nil
  lastPush = nil
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
  fxCount = 0
  lastFxIndex = nil
  lastPush = nil
  tidalSolo.TidalUnsoloAll()
  tidalSend.TidalSend('all $ id')
end

function mkEffectBind(x)
  willPush = function()
    TidalPushEffect(x .. incScale .. ',')
  end
  return willPush
end

function mkSoloBind(x)
  willSolo = function()
    tidalSolo.TidalSoloToggle(x)
  end
  return willSolo
end


function incFxVal(i)
  willInc = function()
	  TidalIncFxVal(i*incScale)
  end
  return willInc
end

function incIncScale(i)
  willInc = function()
	  incScale = incScale + i
  end
  return willInc
end



function setFxVal(i)
  willSet = function()
	  TidalSetFxVal(i + setFxValueOffset)
  end
  return willSet
end


function id()
	willId = function ()
		return
	end
	return willId
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


  ["`"] = barToggleBind(TidalRemoveEffect,setFxVal(setFxValueList[1])),
  ["1"] = barToggleBind(mkSoloBind(1),setFxVal(setFxValueList[2])),
  ["2"] = barToggleBind(mkSoloBind(2),setFxVal(setFxValueList[3])),
  ["3"] = barToggleBind(mkSoloBind(3),setFxVal(setFxValueList[4])),
  ["4"] = barToggleBind(mkSoloBind(4),setFxVal(setFxValueList[5])),
  ["5"] = barToggleBind(mkSoloBind(5),setFxVal(setFxValueList[6])),
  ["6"] = barToggleBind(mkSoloBind(6),setFxVal(setFxValueList[7])),
  ["7"] = barToggleBind(mkSoloBind(7),setFxVal(setFxValueList[8])),
  ["8"] = barToggleBind(mkSoloBind(8),setFxVal(setFxValueList[9])),
  ["9"] = barToggleBind(mkSoloBind(9),setFxVal(setFxValueList[10])),
  ["0"] = barToggleBind(tidalSolo.TidalUnsoloAll,setFxVal(setFxValueList[10])),
  [")"] = TidalClearEffectsUnsolo,
  
  -- [" "] = TidalToggleFront, -- TODO: find a good use of <space> in fxMode
  
  ['-'] = barToggleBind(incFxVal(-1),setFxVal(setFxValueList[12])),
  ['='] = barToggleBind(incFxVal(1),setFxVal(setFxValueList[13])),

  ['['] = (function() tidalSend.TidalJumpSendBlock('do$','b') end),
  [']'] = (function() tidalSend.TidalJumpSendBlock('do$') end) ,

  ['\t'] = "quit",
  [ret] = TidalResetEffects,
  ['<BS>'] = TidalRemoveEffect,
  ['<Del>'] = TidalRemoveEffectRight,
  ['<S-Enter>'] = TidalResetEffectsUnsolo,

  ['<M-h>'] = TidalFxIndexLeft,
  ['<M-H>'] = TidalFxIndexStart,
  ['<M-l>'] = TidalFxIndexRight,
  ['<M-L>'] = TidalFxIndexEnd,

  [' '] = function() toggleBar() end,

  -- shift + num-keys
  -- play a val with the keyboard
  -- (key-bar)

  ['~'] = barToggleBind(setFxVal(setFxValueList[1]) ,TidalRemoveEffect) ,
  ['!'] = barToggleBind(setFxVal(setFxValueList[2]) ,mkSoloBind(1)),
  ['@'] = barToggleBind(setFxVal(setFxValueList[3]) ,mkSoloBind(2)),
  ['#'] = barToggleBind(setFxVal(setFxValueList[4]) ,mkSoloBind(3)),
  ['$'] = barToggleBind(setFxVal(setFxValueList[5]) ,mkSoloBind(4)),
  ['%'] = barToggleBind(setFxVal(setFxValueList[6]) ,mkSoloBind(5)),
  ['^'] = barToggleBind(setFxVal(setFxValueList[7]) ,mkSoloBind(6)),
  ['&'] = barToggleBind(setFxVal(setFxValueList[8]) ,mkSoloBind(7)),
  ['*'] = barToggleBind(setFxVal(setFxValueList[9]) ,mkSoloBind(8)),
  ['('] = barToggleBind(setFxVal(setFxValueList[10]),mkSoloBind(9)),
  [')'] = barToggleBind(setFxVal(setFxValueList[11]),id),
  ['_'] = barToggleBind(setFxVal(setFxValueList[12]),incFxVal(-1)),
  ['+'] = barToggleBind(setFxVal(setFxValueList[13]),incFxVal(1)),

  ['\\'] = (function() TidalClearEffects() end),

  ['<M-S-u>'] = (function() print("AHHHHHHHHHHHHHHHHHHHH") end),

  ['<M-_>'] = shiftFxValueOffset(-6),
  ['<M-+>'] = shiftFxValueOffset(6),
  ['<M-S-BS>'] = resetFxValueOffset(),


  ['<M-0>'] = (function() tidalSend.TidalMarkSendBlock('0') end),
  ['<M-1>'] = (function() tidalSend.TidalMarkSendBlock('1') end),
  ['<M-2>'] = (function() tidalSend.TidalMarkSendBlock('2') end),
  ['<M-3>'] = (function() tidalSend.TidalMarkSendBlock('3') end),
  ['<M-4>'] = (function() tidalSend.TidalMarkSendBlock('4') end),
  ['<M-5>'] = (function() tidalSend.TidalMarkSendBlock('5') end),
  ['<M-6>'] = (function() tidalSend.TidalMarkSendBlock('6') end),
  ['<M-7>'] = (function() tidalSend.TidalMarkSendBlock('7') end),
  ['<M-8>'] = (function() tidalSend.TidalMarkSendBlock('8') end),
  ['<M-9>'] = (function() tidalSend.TidalMarkSendBlock('9') end),

  ['<M-->'] = incIncScale(-1),
  ['<M-=>'] = incIncScale(1),
  ['<M-BS>'] = (function () incScale = 1 end),


  ['<M-S-0>'] = (function () TidalMkMark('0') end),
  ['<M-S-1>'] = (function () TidalMkMark('1') end),
  ['<M-S-2>'] = (function () TidalMkMark('2') end),
  ['<M-S-3>'] = (function () TidalMkMark('3') end),
  ['<M-S-4>'] = (function () TidalMkMark('4') end),
  ['<M-S-5>'] = (function () TidalMkMark('5') end),
  ['<M-S-6>'] = (function () TidalMkMark('6') end),
  ['<M-S-7>'] = (function () TidalMkMark('7') end),
  ['<M-S-8>'] = (function () TidalMkMark('8') end),
  ['<M-S-9>'] = (function () TidalMkMark('9') end),

  ['<Up>'] = (function () prevFx() end),

  [esc] = "quit",

}

return M

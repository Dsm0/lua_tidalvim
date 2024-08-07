local M = {}

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
--
--
--
--
-- this is fucking ridiculous, having to define your own table,
-- -- and having to update it each time you encounter a new binding, the system is fucking obvious
-- -- 
M.specialChars = {
  ['\x80kb'] = "<BS>",
  ['\128\107\68'] = "<Del>",
  ['\128\252\2\13'] = "<S-Enter>",
  ['\128\252\8\13'] = "<M-Enter>",
  ['\128\252\8\48'] = "<M-0>",
  ['\128\252\10\48'] = "<M-(>",
  ['\128\107\108'] = "<Left>",
  ['\128\107\114'] = "<Right>",
  ['\128\107\117'] = "<Up>",
  ['\128\107\100'] = "<Down>",
  ['\128\252\8\104'] = "<M-h>",
  ['\128\252\8\72'] = "<M-S-h>",
  ['\128\252\8\72'] = "<M-H>",
  ['\128\252\8\108'] = "<M-l>",
  ['\128\252\8\76'] = "<M-L>",
  ['\128\252\8\128\107\98'] = "<M-BS>",
  ['\128\252\2\128\107\98'] = "<S-BS>",
  ['\128\252\8\128\107\68'] = "<M-Del>",

  ['\128\252\8\48'] = "<M-0>",
  ['\128\252\8\49'] = "<M-1>",
  ['\128\252\8\50'] = "<M-2>",
  ['\128\252\8\51'] = "<M-3>",
  ['\128\252\8\52'] = "<M-4>",
  ['\128\252\8\53'] = "<M-5>",
  ['\128\252\8\53'] = "<M-5>",
  ['\128\252\8\54'] = "<M-6>",
  ['\128\252\8\55'] = "<M-7>",
  ['\128\252\8\56'] = "<M-8>",
  ['\128\252\8\57'] = "<M-9>",

  ['\128\252\8\45'] = "<M-->",
  ['\128\252\8\61'] = "<M-=>",

  ['\128\252\10\48'] = "<M-S-0>",
  ['\128\252\10\49'] = "<M-S-1>",
  ['\128\252\10\50'] = "<M-S-2>",
  ['\128\252\10\51'] = "<M-S-3>",
  ['\128\252\10\52'] = "<M-S-4>",
  ['\128\252\10\53'] = "<M-S-5>",
  ['\128\252\10\53'] = "<M-S-5>",
  ['\128\252\10\54'] = "<M-S-6>",
  ['\128\252\10\55'] = "<M-S-7>",
  ['\128\252\10\56'] = "<M-S-8>",
  ['\128\252\10\57'] = "<M-S-9>",

  ['\128\252\10\45'] = "<M-_>",
  ['\128\252\10\61'] = "<M-+>",
  ['\128\252\10\128\107\98'] = "<M-S-BS>",

  ['\128\252\8\82'] = "<M-R>",
  ['\128\252\8\114'] = "<M-r>",

  ['\51\50'] = '<Space>',
  ['\51\50'] = '<Space>',

}

M.showChar = function()
	print(string.byte(vim.fn.getchar(),1,-1))
end


return M

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
M.specialChars = {
  ['\x80kb'] = "<BS>",
  ['\128\107\68'] = "<Del>",
  ['\128\252\2\13'] = "<S-Enter>",
  ['\128\252\8\13'] = "<M-Enter>",
  ['\128\252\8\48'] = "<M-0>",
  ['\128\252\10\48'] = "<M-(>",
  ['\128\107\108'] = "<LeftArrow>",
  ['\128\107\114'] = "<RightArrow>",
  ['\128\107\117'] = "<UpArrow>",
  ['\128\107\100'] = "<DownArrow>",
  ['\128\252\8\104'] = "<M-h>",
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


-- ['\51\51'] = ['<S-0>'] 
-- ['\51\51'] = ['<S-1>'] 
-- ['\51\51'] = ['<S-2>'] 
-- ['\51\51'] = ['<S-3>'] 
-- ['\51\51'] = ['<S-4>'] 
-- ['\51\51'] = ['<S-5>'] 
-- ['\51\51'] = ['<S-6>'] 
-- ['\51\51'] = ['<S-7>'] 
-- ['\51\51'] = ['<S-8>'] 
-- ['\51\51'] = ['<S-9>'] 

}

M.showChar = function()
	print(string.byte(vim.fn.getchar(),1,-1))
end


return M

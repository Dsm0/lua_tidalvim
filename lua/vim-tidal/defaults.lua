-- default essential keybindings

local M = {}

function M.set_default_mappings()
  vim.api.nvim_set_keymap("n","<c-l>", ':TidalSendBlock<CR>',{})
  vim.api.nvim_set_keymap("n","<c-k>", ':TidalSendLine<CR>',{})
  -- default useful keybindings
  
  vim.api.nvim_set_keymap("",";",":",{noremap=true})
  vim.api.nvim_set_keymap("t","<Esc>","<C-\\><C-n>",{noremap=true})
end

return M

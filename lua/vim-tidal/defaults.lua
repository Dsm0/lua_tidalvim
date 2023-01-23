-- default essential keybindings

local M = {}

function M.set_default_mappings()
  vim.api.nvim_set_keymap("n","<c-l>", ':TidalSendBlock<CR>',{})
  vim.api.nvim_set_keymap("n","<c-k>", ':TidalSendLine<CR>',{})
  -- default useful keybindings
  
  vim.api.nvim_set_keymap("",";",":",{noremap=true})
  vim.api.nvim_set_keymap("t","<Esc>","<C-\\><C-n>",{noremap=true})
end

-- default launch options (what I use)
-- feel free to use this as a base for building a 
-- more specific configuration in /init.lua
function M.set_default_settings()
  
  -- https://github.com/brainfucksec/neovim-lua/blob/main/nvim/lua/core/options.lua
  vim.opt.expandtab = true        -- Use spaces instead of tabs
  vim.opt.shiftwidth = 2          -- Shift 2 spaces when tab
  vim.opt.tabstop = 2             -- 1 tab == 2 spaces
  vim.opt.smartindent = true      -- Autoindent new lines
  vim.opt.lazyredraw = true

  local new_tidal_file = function()
    vim.cmd('setfiletype tidal')
    vim.cmd('setlocal syntax=haskell')
  end

  vim.api.nvim_create_autocmd(
      {"BufRead","BufNewFile"},
        {pattern = "*.tidal",
        callback = new_tidal_file
        }
    )

end


return M

tidalSolo = require("vim-tidal.tidalSolo")

vim.api.nvim_set_hl(0, "ActiveLine", {ctermbg='lightgray', ctermfg='black'})
vim.api.nvim_set_hl(0, "InactiveLine", {ctermbg='black', ctermfg='black'})

-- TODO/NOTE: this is mostly just a reimplementation 
-- of my previous statusline, but it might be nicer
-- to be able to distribute tidal info across two different status lines 
-- (the line for the buffer, and the line for the tidal process)

local M = {}

local function ActiveLine()

  local hl = '%#ActiveLine#'

  local mode = '%{mode()}' -- simpler to use mode()

  local soloed = '%{v:lua.tidalSolo.TidalSoloedAsString()}'


  local align_right = '%='

  local fxchain = ': %{v:lua.fxBindings.GetFxStatus()}'

  local barStatus = ': %{v:lua.fxBindings.GetBarStatus()}'

  local fxSetterValues = ': %{v:lua.fxBindings.GetFxBarValues()}'

  local rowcol = " %l,%c"

  local filename = ' %f'

  local modified = "%m" -- if buffer has unsaved modifications, will show [+]

  local status = table.concat({hl, mode, soloed, align_right, fxchain, 
				barStatus, fxSetterValues, rowcol, 
				filename, modified},' ')

  return status
end


local function InactiveLine()

  local hl = '%#InactiveLine#'

  -- local soloed = '%{v:lua.tidalSolo.TidalSoloedAsString()}'
  -- -- NOTE: InactiveLine() won't update when channels are soloed/unsoloed,
  -- -- so I decided not to show it

  local modified = "%m" -- if buffer has unsaved modifications, will show [+]

  local status = table.concat({hl, modified},' ')

  return status
end


statusLineGroup = vim.api.nvim_create_augroup("StatusLine", { clear = true })

vim.api.nvim_create_autocmd(
  { "WinEnter", "BufEnter"},
  { pattern = "*.tidal",
    callback = function()
      vim.opt_local.statusline = ActiveLine()
    end,
    group = statusLineGroup,
    desc = "show tidal status info if buffer is active",
  }
)

vim.api.nvim_create_autocmd(
  { "WinLeave", "BufLeave"},
  { pattern = "*.tidal",
    callback = function()
      vim.opt_local.statusline = InactiveLine()
    end,
    group = statusLineGroup,
    desc = "change status line when de-selecting leaving",
  }
)

return M

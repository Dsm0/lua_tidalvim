-- NOTE: run `make` and ensure lua_tidalvim is linked to "~/.local/share/lua_tidalvim"

-- https://stackoverflow.com/a/69142336
local function tc(str)
    return vim.api.nvim_replace_termcodes(str, true, false, true)
end

-- vim.g.tidalvim_root = os.getenv("TIDALVIM_ROOT") .. 
vim.g.tidalvim_root = 
  os.getenv("HOME") .. '/.local/share/lua_tidalvim'

vim.o.runtimepath = vim.o.runtimepath .. ", " 
            .. vim.g.tidalvim_root .. ", "

local vimTidal = require('vim-tidal')

vimTidal.defaults.set_default_mappings()
vimTidal.defaults.set_default_settings()
vimTidal.defaults.load_default_plugins()

fxBindings = loadfile(vim.g.tidalvim_root .. '/fxBindings/fxBindings.lua')()
statusLine = loadfile(vim.g.tidalvim_root .. '/fxBindings/statusLine.lua')()
vimTidal.fxMode.setFxBindings(fxBindings)


-- anything past this line I consider my own configuration

local ls = require('luasnip')
require('luasnip.loaders.from_snipmate')
                  .load({path = 'snippets'})

local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node

local function insertRange(args,parent,user_args)
   local n = tonumber(args[1][1])
   if n==nil -- didn't pass a number >:[
     then return ""
     else return vim.fn.system(table.concat({'echo -n \\[{0..', n-1, '}\\]'}))
   end
end

-- inserts range
ls.add_snippets("all",
  {s("I", { f(insertRange, {1}, {}) , t ' [', i(1), t ']' }) }
)

local expandSnippet = function(binding)
  return function()
    if ls.expand_or_jumpable() 
      then
        ls.expand_or_jump()
      else
        vim.cmd(tc(binding))
    end
  end
end

local jumpBackwards = function(binding)
  return function() 
    if ls.jumpable(-1) 
      then ls.jump(-1)
      else vim.api.nvim_feedkeys(tc(binding), "n", false)
    end
  end
end

-- NOTE: this lets me create abbreviations for snippets
-- if I have the snippet: orbit -> (# orbit ($1/8))
-- I can abbreviate it with just o, then try to expand it twice
-- o -> orbit -> (# orbit ($1/8))
-- ...
-- This decision might come back to haunt me but there are not implementing
-- snippet aliases and I'm not going to lol https://github.com/garbas/vim-snipmate/issues/124
local doubleExpandSnippet = function(binding)
  return function()
    if ls.expand_or_locally_jumpable() 
      then
        ls.expand_or_jump()
        if ls.expandable() then 
          ls.expand()
        end
      else
		vim.api.nvim_feedkeys(tc(binding), "n", false)
    end
  end
end

vim.keymap.set({"i","s"}, "<tab>", doubleExpandSnippet("<tab>"), {})
vim.keymap.set({"i","s"}, "<S-Tab>", jumpBackwards(""), { silent = true })
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.cmd("highlight CursorLine ctermbg=none ctermfg=none cterm=nocombine,bold")
vim.cmd("highlight CursorColumn ctermbg=none ctermfg=none cterm=italic,bold")


vim.keymap.set({"i"}, "<M-BS>", "<BS><BS>", { silent = true })
vim.keymap.set({"i"}, "<M-`>", " ~", { silent = true })
vim.keymap.set({"i"}, "<M-1>", " 1", { silent = true })
vim.keymap.set({"i"}, "<M-2>", " 2", { silent = true })
vim.keymap.set({"i"}, "<M-3>", " 3", { silent = true })
vim.keymap.set({"i"}, "<M-4>", " 4", { silent = true })
vim.keymap.set({"i"}, "<M-4>", " 4", { silent = true })
vim.keymap.set({"i"}, "<M-5>", " 5", { silent = true })
vim.keymap.set({"i"}, "<M-5>", " 5", { silent = true })
vim.keymap.set({"i"}, "<M-6>", " 6", { silent = true })
vim.keymap.set({"i"}, "<M-7>", " 7", { silent = true })
vim.keymap.set({"i"}, "<M-8>", " 8", { silent = true })
vim.keymap.set({"i"}, "<M-9>", " 9", { silent = true })
vim.keymap.set({"i"}, "<M-0>", " 0", { silent = true })
vim.keymap.set({"i"}, "<M-->", " 11", { silent = true })
vim.keymap.set({"i"}, "<M-=>", " 12", { silent = true })

-- courtesy 
-- https://www.reddit.com/r/neovim/comments/psux8f/comment/hdsfi9s/
vim.keymap.set({"i"}, "<M-S-R>", function()
		vimTidal.fxBindings.FxStringToReg('x')
		local pos = vim.api.nvim_win_get_cursor(0)[2]
		local line = vim.api.nvim_get_current_line()
  		local nline = line:sub(0, pos) .. "$ " .. vim.fn.getreg('x') .. " " .. line:sub(pos + 1)
		vim.api.nvim_set_current_line(nline)
	end, { silent = true })


vim.cmd("set scrollback=100") -- I think that 
-- vim.keymap.set({"i"}, "<M-[>", "[", { silent = true })
-- vim.keymap.set({"i"}, "<M-[", "]", { silent = true })
-- vim.keymap.set({"i"}, "<M-1>", " 1", { silent = true })

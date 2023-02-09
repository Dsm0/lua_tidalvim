-- https://stackoverflow.com/questions/73358168/where-can-i-check-my-neovim-lua-runtimepath
-- ^^^^ check out to resolve path lua plugin issues

-- NOTE: needs to be the root directory of lua_tidalvim



-- https://stackoverflow.com/a/69142336
local function tc(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
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
      else vim.cmd(tc(binding))
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
    if ls.expand_or_jumpable() 
      then
        ls.expand_or_jump()
        if ls.expandable() then 
          ls.expand()
        end
      else
        vim.cmd(tc(binding))
    end
  end
end

vim.keymap.set({"i","s"}, "<Tab>", doubleExpandSnippet("<Tab>"), { silent = true })
vim.keymap.set({"i","s"}, "<S-Tab>", jumpBackwards("<S-Tab>"), { silent = true })

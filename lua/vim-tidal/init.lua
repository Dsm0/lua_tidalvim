local M = {}

M.ftplugin = require("vim-tidal.ftplugin")
M.tidalSend = require("vim-tidal.tidalSend")
M.syntax = require("vim-tidal.syntax")
M.tidalSolo = require("vim-tidal.tidalSolo")
M.fxBindings = require("vim-tidal.fxBindings")
M.fxMode = require("vim-tidal.fxMode")

M.statusLine = require("vim-tidal.statusLine")
M.defaults = require("vim-tidal.defaults")

M.defaults.set_default_mappings()
M.defaults.set_default_settings()
M.defaults.load_default_plugins()

return M

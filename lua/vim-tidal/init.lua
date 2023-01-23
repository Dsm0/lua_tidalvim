local M = {}

M.ftplugin = require("vim-tidal.ftplugin")
M.tidalSend = require("vim-tidal.tidalSend")
M.syntax = require("vim-tidal.syntax")
M.tidalSolo = require("vim-tidal.tidalSolo")
M.defaults = require("vim-tidal.defaults")


M.defaults.set_default_mappings()
M.defaults.set_default_settings()

return M

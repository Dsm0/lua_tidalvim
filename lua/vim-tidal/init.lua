local ftplugin = require("vim-tidal.ftplugin")
local send = require("vim-tidal.tidalSend")
local syntax = require("vim-tidal.syntax")
local defaults = require("vim-tidal.defaults")

defaults.set_default_mappings()

return {ftplugin, send, syntax, defaults}

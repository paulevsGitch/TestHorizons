UILibrary = {}

local mod_name = core.get_current_modname()
local path = core.get_modpath(mod_name)

dofile(path .. "/scripts/formspecs.lua")
dofile(path .. "/scripts/field_handler.lua")
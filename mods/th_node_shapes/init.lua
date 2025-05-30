local mod_name = core.get_current_modname()
local path = core.get_modpath(mod_name)

NodeShapes = {
	protected = {
		translate = core.get_translator(mod_name)
	}
}

dofile(path .. "/scripts/node_shapes.lua")
dofile(path .. "/scripts/gui.lua")
dofile(path .. "/scripts/api.lua")

NodeShapes.protected = nil
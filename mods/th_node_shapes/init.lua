NodeShapes = {
	protected = {
		translate = core.get_translator("th_node_shapes")
	}
}

local path = core.get_modpath("th_node_shapes")

dofile(path .. "/scripts/node_shapes.lua")
dofile(path .. "/scripts/gui.lua")
dofile(path .. "/scripts/api.lua")

NodeShapes.protected = nil
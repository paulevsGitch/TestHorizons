NODE_SHAPES = {
	PROTECTED = {}
}

local path = core.get_modpath("th_node_shapes")

dofile(path .. "/scripts/node_shapes.lua")
dofile(path .. "/scripts/gui.lua")
dofile(path .. "/scripts/api.lua")

NODE_SHAPES.PROTECTED = nil
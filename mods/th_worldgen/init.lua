THWorldgen = {}

local path = core.get_modpath("th_worldgen")

dofile(path .. "/scripts/layers.lua")
core.register_mapgen_script(path .. "/scripts/generator.lua")

core.register_on_generated(function(minp, maxp, blockseed)
	local _, emin, emax = core.get_mapgen_object("voxelmanip")
	core.fix_light(emin, emax)
end)
THWorldgen = {}

local path = core.get_modpath("th_worldgen")

dofile(path .. "/scripts/layers.lua")
core.register_mapgen_script(path .. "/scripts/generator.lua")

minetest.register_on_generated(function(minp, maxp, blockseed)
	local _, emin, emax = minetest.get_mapgen_object("voxelmanip")
	minetest.fix_light(emin, emax)
end)
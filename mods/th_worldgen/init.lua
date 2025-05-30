local mod_name = core.get_current_modname()
local path = core.get_modpath(mod_name)

THWorldgen = {}

dofile(path .. "/scripts/layers.lua")
core.register_mapgen_script(path .. "/scripts/generator.lua")

core.register_on_generated(function(minp, maxp, blockseed)
	local _, emin, emax = core.get_mapgen_object("voxelmanip")
	core.fix_light(emin, emax)
end)
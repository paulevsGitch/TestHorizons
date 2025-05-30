local mod_name = core.get_current_modname()
local path = core.get_modpath(mod_name)

THUtilities = {}

local scripts = {
	path .. "/scripts/tables.lua",
	path .. "/scripts/vectors.lua",
	path .. "/scripts/math.lua",
	path .. "/scripts/perlin.lua",
	path .. "/scripts/voronoi.lua",
	path .. "/scripts/strings.lua"
}

for _, script in ipairs(scripts) do
	dofile(script)
	core.register_mapgen_script(script)
end
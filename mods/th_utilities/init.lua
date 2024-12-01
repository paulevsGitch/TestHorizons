local path = core.get_modpath("th_utilities")

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
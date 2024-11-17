TH_WORLDGEN = {}

local path = core.get_modpath("th_worldgen")

dofile(path .. "/scripts/layers.lua")
--dofile(path .. "/scripts/generator.lua")

--core.register_mapgen_script(path .. "/scripts/layers.lua")
core.register_mapgen_script(path .. "/scripts/generator.lua")
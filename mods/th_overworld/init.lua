THOverworld = {}

local path = core.get_modpath("th_overworld")
THOverworld.translate = core.get_translator("th_overworld")

dofile(path .. "/scripts/stones.lua")
dofile(path .. "/scripts/fluids.lua")
dofile(path .. "/scripts/bricks.lua")
dofile(path .. "/scripts/soils.lua")
dofile(path .. "/scripts/world.lua")
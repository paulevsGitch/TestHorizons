TH_OVERWORLD = {}

local path = core.get_modpath("th_overworld")
TH_OVERWORLD.TRANSLATOR = core.get_translator("th_overworld")

dofile(path .. "/scripts/stones.lua")
dofile(path .. "/scripts/world.lua")
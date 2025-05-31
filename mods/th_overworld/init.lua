local mod_name = core.get_current_modname()
local path = core.get_modpath(mod_name)

THOverworld = {
	protected = {
		translate = core.get_translator(mod_name)
	}
}

dofile(path .. "/scripts/sounds.lua")
dofile(path .. "/scripts/stones.lua")
dofile(path .. "/scripts/fluids.lua")
dofile(path .. "/scripts/bricks.lua")
dofile(path .. "/scripts/soils.lua")
dofile(path .. "/scripts/glass.lua")
dofile(path .. "/scripts/plants/cactuses.lua")
dofile(path .. "/scripts/world.lua")

THOverworld.protected = nil
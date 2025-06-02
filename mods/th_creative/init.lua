local mod_name = core.get_current_modname()
local path = core.get_modpath(mod_name)

THCreative = {}

THCreative.is_in_creative = function (player)
	local name = player:get_player_name()
	return core.is_creative_enabled(name)
end

dofile(path .. "/scripts/inventory.lua")
dofile(path .. "/scripts/node_breaking.lua")
PlacementRules = {
	protected = {
		translate = core.get_translator("th_placement_rules")
	}
}

local path = core.get_modpath("th_placement_rules")

dofile(path .. "/scripts/soil_requirements.lua")

PlacementRules.protected = nil
local translate = THOverworld.translate

local name = "small_cactus"
local node_name = "th_overworld:" .. name

core.register_node(node_name, {
	drawtype = "plantlike",
	on_place = PlacementRules.sand_requirement,
	description = translate(string.snake_to_title(name)),
	tiles = {"th_" .. name .. ".png"},
	paramtype = "light",
	groups = { plant = 1 }
})

local translate = THOverworld.protected.translate

local function register_stone(name)
	NodeShapes.register_simple_stone_set("th_overworld:" .. name, {
		description = translate(string.snake_to_title(name)),
		tiles = {"th_" .. name .. ".png"},
		groups = { stone = 1, solid = 1 },
		_node_sounds = THOverworld.sounds.stone
	})
end

register_stone("stone")
register_stone("sandstone")
register_stone("dark_sandstone")
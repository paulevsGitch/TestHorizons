local translate = THOverworld.protected.translate

local function register_bricks(name, sounds)
	local item_id = "th_overworld:" .. name
	NodeShapes.register_fancy_stone_set(item_id, {
		description = translate(string.snake_to_title(name)),
		tiles = {"th_" .. name .. ".png"},
		groups = { bricks = 1, solid = 1 },
		_node_sounds = sounds
	})
	THCreative.add_item("Stone", item_id)
end

register_bricks("bricks", THOverworld.sounds.bricks)
register_bricks("large_bricks", THOverworld.sounds.bricks)
register_bricks("stone_bricks", THOverworld.sounds.stone)
register_bricks("sandstone_bricks", THOverworld.sounds.stone)
register_bricks("dark_sandstone_bricks", THOverworld.sounds.stone)
local translate = THOverworld.translate

local function register_bricks(name)
	NodeShapes.register_fancy_stone_set("th_overworld:" .. name, {
		description = translate(string.snake_to_title(name)),
		tiles = {"th_" .. name .. ".png"},
		groups = { bricks = 1, solid = 1 }
	})
end

register_bricks("bricks")
register_bricks("large_bricks")
register_bricks("stone_bricks")
register_bricks("sandstone_bricks")
register_bricks("dark_sandstone_bricks")
local translate = THOverworld.translate

local function register_falling(name)
	NodeShapes.register_layers_set("th_overworld:" .. name, {
		description = translate(string.snake_to_title(name)),
		tiles = { "th_" .. name .. ".png" },
		groups = { falling_node = 1, solid = 1, soil = 1 }
	})
end

local function register_soil(name)
	NodeShapes.register_shapes_set("th_overworld:" .. name, {
		description = translate(string.snake_to_title(name)),
		tiles = { "th_" .. name .. ".png" },
		groups = { solid = 1, soil = 2 }
	}, {
		{ type = "cube" },
		{ type = "slab" }
	})
end

local function register_grass(name, color)
	core.register_node("th_overworld:" .. name .. "_with_grass", {
		description = translate(string.snake_to_title(name) .. " With Grass"),
		tiles = {
			"th_grass_top.png",
			{ name = "th_" .. name .. ".png", color = "white" },
			{ name = "th_" .. name .. "_with_grass_side.png", color = "white" }
		},
		overlay_tiles = { "", "", "th_grass_side.png" },
		groups = { solid = 1, soil = 2 },
		color = color,
	})
end

register_falling("sand")
register_falling("gravel")
register_soil("soil")
register_grass("soil", "#aee170")
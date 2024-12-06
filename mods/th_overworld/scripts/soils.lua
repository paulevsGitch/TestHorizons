local translate = THOverworld.translate

local function register_falling(name)
	NodeShapes.register_layers_set("th_overworld:" .. name, {
		description = translate(string.snake_to_title(name)),
		tiles = {"th_" .. name .. ".png"},
		groups = { falling_node = 1, solid = 1, soil = 1 }
	})
end

register_falling("sand")
register_falling("gravel")
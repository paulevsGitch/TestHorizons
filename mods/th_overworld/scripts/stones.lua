local translate = THOverworld.translate

local function register_stone(name)
	local node_name = "th_overworld:" .. name

	core.register_node(node_name, {
		description = translate(string.snake_to_title(name)),
		tiles = {"th_" .. name .. ".png"},
		groups = { stone = 1, solid = 1 }
	})
	
	NodeShapes.register_stone_set(node_name)
end

register_stone("stone")
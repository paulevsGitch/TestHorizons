local translate = THOverworld.translate

local function register_small_cactus(name)
	local node_name = "th_overworld:" .. name

	core.register_node(node_name, {
        drawtype = "plantlike",
		description = translate(string.snake_to_title(name)),
		tiles = {"th_" .. name .. ".png"},
        paramtype = "light",
		groups = { plant = 1, soil = 1 }
	})
end

register_small_cactus("small_cactus")
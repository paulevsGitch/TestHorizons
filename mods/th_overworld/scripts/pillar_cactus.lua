local translate = THOverworld.translate

local function register_pillar_cactus(name)
	local node_name = "th_overworld:" .. name

	core.register_node(node_name, {
        drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = { -0.25, -0.75, -0.25, 0.25, 0.25, 0.25 }
		},
        on_place = PlacementRules.sand_requirement,
		description = translate(string.snake_to_title(name)),
		tiles = {"th_" .. name .. ".png"},
        paramtype = "light",
		groups = { plant = 1 }
	})
end

register_pillar_cactus("pillar_cactus")
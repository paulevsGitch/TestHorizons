local translate = THOverworld.translate

local function register_falling(name, sounds)
	local check_name = "th_overworld:" .. name .. "_layer"
	NodeShapes.register_layers_set("th_overworld:" .. name, {
		description = translate(string.snake_to_title(name)),
		tiles = { "th_" .. name .. ".png" },
		groups = { falling_node = 1, solid = 1, soil = 1 },
		_node_sounds = sounds,
		on_construct = function(pos)
			local node = core.get_node(pos)
			local layer = core.get_item_group(node.name, "layer")

			if layer == 0 then
				return
			end

			local pos_below = vector.new(pos.x, pos.y - 1, pos.z)
			local node_below = core.get_node(pos_below)
			local layer_below = core.get_item_group(node_below.name, "layer")

			if layer_below > 0 and string.starts_with(node_below.name, check_name) then
				local new_layer_below = layer + layer_below - 1
				local new_layer = new_layer_below - 4
				new_layer_below = math.min(new_layer_below, 3)

				if new_layer_below == 3 then
					node_below.name = string.remove_last(node_below.name, string.len("_layer_n"))
				else
					node_below.name = string.remove_last(node_below.name, 1) .. new_layer_below
				end
				core.swap_node(pos_below, node_below)

				if new_layer < 1 then
					node.name = "air"
				else
					node.name = string.remove_last(node.name, 1) .. new_layer
				end
				core.swap_node(pos, node)
			end
		end
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
register_falling("gravel", THOverworld.sounds.gravel)
register_soil("soil")
register_grass("soil", "#aee170")
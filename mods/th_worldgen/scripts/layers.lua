local LAYERS = {}

local DEFAULT_LAYER = {
	min_height = -32000,
	max_height = 32000,
	get_density = function(layer, world_pos)
		return -1.0
	end
}

core.ipc_set("th_worldgen:default_layer", DEFAULT_LAYER)

-- Function to register layer
-- def table parameters:
--     min_height - minimal height of the layer (should be devisor of 80 nodes)
--     max_height - maximum height of the layer (should be devisor of 80 nodes)
function THWorldgen.register_layer(def)
	table.insert(LAYERS, def)
	core.ipc_set("th_worldgen:layers", LAYERS)
end

-- Function that will get a layer (table) or default
function THWorldgen.get_layer(height)
	for _, layer in ipairs(LAYERS) do
		if layer.min_height <= height and layer.max_height >= height then
			return layer
		end
	end
	return DEFAULT_LAYER
end
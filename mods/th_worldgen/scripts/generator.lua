local GRID_SIZE = 8
local GRID_OFFSET = math.floor(GRID_SIZE * 0.5)
local LAYERS = core.ipc_get("th_worldgen:layers")
local DEFAULT_LAYER = core.ipc_get("th_worldgen:default_layer")

local interpolation_cell_1 = {}
local interpolation_cell_2 = {}
local density_pos = vector.new()
local terrain_layers = {}
local index_table = {}
local node_data = {}
local param2_data = {}
local array_side_dy
local array_side_dz
local vm, emin, emax

local function init_generator_values()
	if #index_table > 0 then
		return
	end

	local side = emax.x - emin.x
	local min_side = 16
	local max_side = side - 16

	array_side_dy = side + 1
	array_side_dz = array_side_dy * array_side_dy
	local size = array_side_dy * array_side_dz

	for index = 1, size do
		local index_dec = index - 1

		local x = index_dec % array_side_dy
		if x < min_side or x > max_side then goto index_end end

		local y = math.floor(index_dec / array_side_dy) % array_side_dy
		if y < min_side or y > max_side then goto index_end end

		local z = math.floor(index_dec / array_side_dz)
		if z < min_side or z > max_side then goto index_end end

		table.insert(index_table, index)

		::index_end::
	end
end

local function get_layer(height)
	for _, layer in ipairs(LAYERS) do
		if layer.min_height <= height and layer.max_height >= height then
			return layer
		end
	end
	return DEFAULT_LAYER
end

local function fill_cell()
	local side = math.floor((emax.x - emin.x) / GRID_SIZE)

	for i = 1, side do
		local wy = emin.y + i * GRID_SIZE
		terrain_layers[i] = get_layer(wy)
	end
	
	for dx = 1, side do
		local slise_yz = interpolation_cell_1[dx]
		if not slise_yz then
			slise_yz = {}
			interpolation_cell_1[dx] = slise_yz
		end
		density_pos.x = emin.x + dx * GRID_SIZE
		for dy = 1, side do
			local slise_y = slise_yz[dy]
			if not slise_y then
				slise_y = {}
				slise_yz[dy] = slise_y
			end
			density_pos.y = emin.y + dy * GRID_SIZE
			for dz = 1, side do
				density_pos.z = emin.z + dz * GRID_SIZE
				local layer = terrain_layers[dy]
				slise_y[dz] = layer:get_density(density_pos)
			end
		end
	end

	side = side + 1

	for i = 1, side do
		local wy = emin.y + i * GRID_SIZE - GRID_OFFSET
		terrain_layers[i] = get_layer(wy)
	end

	for dx = 1, side do
		local slise_yz = interpolation_cell_2[dx]
		if not slise_yz then
			slise_yz = {}
			interpolation_cell_2[dx] = slise_yz
		end
		density_pos.x = emin.x + dx * GRID_SIZE - GRID_OFFSET
		for dy = 1, side do
			local slise_y = slise_yz[dy]
			if not slise_y then
				slise_y = {}
				slise_yz[dy] = slise_y
			end
			density_pos.y = emin.y + dy * GRID_SIZE - GRID_OFFSET
			for dz = 1, side do
				density_pos.z = emin.z + dz * GRID_SIZE - GRID_OFFSET
				local layer = terrain_layers[dy]
				slise_y[dz] = layer:get_density(density_pos)
			end
		end
	end
end

local function interpolate_cell(cell, x, y, z)
	local dx = x / GRID_SIZE
	local dy = y / GRID_SIZE
	local dz = z / GRID_SIZE

	local x1 = math.floor(dx)
	local y1 = math.floor(dy)
	local z1 = math.floor(dz)

	dx = dx - x1
	dy = dy - y1
	dz = dz - z1

	local x2 = x1 + 1
	local y2 = y1 + 1
	local z2 = z1 + 1
	
	local a = cell[x1][y1][z1]
	local b = cell[x2][y1][z1]
	local c = cell[x1][y2][z1]
	local d = cell[x2][y2][z1]
	local e = cell[x1][y1][z2]
	local f = cell[x2][y1][z2]
	local g = cell[x1][y2][z2]
	local h = cell[x2][y2][z2]
	
	a = math.lerp(a, b, dx)
	b = math.lerp(c, d, dx)
	c = math.lerp(e, f, dx)
	d = math.lerp(g, h, dx)
	
	a = math.lerp(a, b, dy)
	b = math.lerp(c, d, dy)
	
	return math.lerp(a, b, dz)
end

local function generate_terrain()
	local stone_id = core.get_content_id("th_overworld:stone")
	local water_id = core.get_content_id("th_overworld:water_source")

	for _, index in ipairs(index_table) do
		local index_dec = index - 1

		local x = index_dec % array_side_dy
		local y = math.floor(index_dec / array_side_dy) % array_side_dy
		local z = math.floor(index_dec / array_side_dz)

		local cell_1 = interpolate_cell(interpolation_cell_1, x, y, z)
		local cell_2 = interpolate_cell(interpolation_cell_2, x + GRID_OFFSET, y + GRID_OFFSET, z + GRID_OFFSET)

		if (cell_1 + cell_2) * 0.5 > 0.0 then
			node_data[index] = stone_id
		elseif y + emin.y < 0 then
			node_data[index] = water_id
		end
	end
end

core.register_on_generated(function(minp, maxp, blockseed)
	vm, emin, emax = core.get_mapgen_object("voxelmanip")
	vm:get_data(node_data)
	vm:get_param2_data(param2_data)
	init_generator_values()
	fill_cell()
	generate_terrain()
	vm:set_data(node_data)
	vm:set_param2_data(param2_data)
	vm:calc_lighting()
end)
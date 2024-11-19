THWorldgen.register_layer({
	min_height = -320,
	max_height = 320,
	get_density = function(layer, world_pos)
		if not layer.land_mass_noise_1 then
			local world_seed = core.get_mapgen_setting("seed") or 0
			layer.continents = Voronoi.new(world_seed)
			layer.land_mass_noise = Perlin.new(world_seed + 1)
		end

		local land_mass = 0.5 - layer.continents.get_2d(world_pos.x * 0.001, world_pos.z * 0.001)
		land_mass = land_mass + layer.land_mass_noise.get(world_pos.x * 0.003, 0.0, world_pos.z * 0.003) * 0.2
		land_mass = math.clamp(land_mass * 80.0, -1.0, 1.0) * 0.1
		local density = -world_pos.y * 0.01 + land_mass

		return density
	end
})
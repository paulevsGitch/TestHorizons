TH_WORLDGEN.register_layer({
	min_height = -320,
	max_height = 320,
	get_density = function(layer, world_pos)
		if not layer.land_mass_noise_1 then
			local world_seed = core.get_mapgen_setting("seed") or 0
			layer.land_mass_noise_1 = perlin.new(world_seed)
			layer.land_mass_noise_2 = perlin.new(world_seed + 1)
		end

		local land_mass = layer.land_mass_noise_1.get(world_pos.x * 0.01, 0.0, world_pos.z * 0.01)
		land_mass = land_mass + layer.land_mass_noise_2.get(world_pos.x * 0.03, 0.0, world_pos.z * 0.03)
		land_mass = math.clamp(land_mass * 8.0, -1.0, 1.0) * 0.1
		local density = -world_pos.y * 0.01 + land_mass

		return density
	end
})
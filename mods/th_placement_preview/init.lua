local PLAYER_ENTITIES = {}

core.register_entity("th_placement_preview:preview_entity", {
	initial_properties = {
		visual = "node",
		node = { name = "air", param2 = 0 },
		visual_size = vector.new(0.75, 0.75, 0.75),
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		pointable = false,
		static_save = false,
		visible = false,
		shaded = false
	}
})

core.register_on_leaveplayer(function(player, timed_out)
	local player_name = player:get_player_name()
	local entity = PLAYER_ENTITIES[player_name]
	if entity then
		PLAYER_ENTITIES[player_name] = nil
		entity:remove()
	end
end)

core.register_globalstep(function(dtime)
	for _, player in ipairs(core.get_connected_players()) do
		local player_name = player:get_player_name()
		local entity = PLAYER_ENTITIES[player_name]

		if not entity then
			entity = core.add_entity(player:get_pos(), "th_placement_preview:preview_entity")
			PLAYER_ENTITIES[player_name] = entity
		end

		local item = player:get_wielded_item()
		local name = item:get_name()
		local def = core.registered_nodes[name]
		local player_pos = player:get_pos()
		local node = { name = name, param2 = 0 }

		if def then
			local range = def.range or 4.0
			local start_pos = vector.add(player_pos, player:get_eye_offset())
			start_pos.y = start_pos.y + (player:get_properties().eye_height or 0.0)
			local end_pos = vector.add(start_pos, vector.multiply(player:get_look_dir(), range))
			local ray = core.raycast(start_pos, end_pos)
			local visible = false
			
			for pointed_thing in ray do
				if pointed_thing.type == "node" then
					local world_node = core.get_node(pointed_thing.above)
					local buildable_to = world_node.name == "air"

					if not buildable_to then
						local world_def = core.registered_nodes[world_node.name]
						buildable_to = world_def and world_def.buildable_to
					end
					
					if not buildable_to then
						goto break_loop
					end

					entity:set_pos(pointed_thing.above)
					visible = true
					if def._get_place_preview then
						node = def._get_place_preview(item, player, pointed_thing)
					elseif def.place_param2 then
						node.param2 = def.place_param2
					end

					goto break_loop
				end
			end

			::break_loop::

			entity:set_properties({
				is_visible = visible,
				node = node
			})
		else
			entity:set_properties({
				is_visible = false,
				pos = player_pos
			})
		end
	end
end)
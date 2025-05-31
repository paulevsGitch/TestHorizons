local global_step_time = 0.0
local player_steps = {}
local last_dig_time = 0.0

local function play_sound(name, pos)
	local gain = math.random() * 0.2 + 0.9
	local pitch = math.random() * 0.4 + 0.8
	core.sound_play(name, {
		pos = pos,
		max_hear_distance = 8,
		gain = gain,
		pitch = pitch
	})
end

core.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	local def = core.registered_nodes[newnode.name]
	if not def or not def._node_sounds then return end
	if def._node_sounds.place then play_sound(def._node_sounds.place, pos)
		play_sound(def._node_sounds.place, pos)
	end
end)

core.register_on_punchnode(function(pos, node, player, pointed_thing)
	local time = os.clock()
	if time < last_dig_time then return end
	last_dig_time = time + 0.1

	local def = core.registered_nodes[node.name]
	if not def or not def._node_sounds then return end

	local sound = def._node_sounds.dig
	if core.is_creative_enabled(player:get_player_name()) then
		sound = def._node_sounds.dug
	end

	if sound then
		play_sound(sound, pos)
	end
end)

core.register_on_dignode(function(pos, node, digger)
	core.chat_send_all(node.name)
	local def = core.registered_nodes[node.name]
	if not def or not def._node_sounds then return end
	if def._node_sounds.dug then
		play_sound(def._node_sounds.dug, pos)
	end
end)

core.register_on_joinplayer(function(player, last_login)
	player_steps[player:get_player_name()] = {
		last_step_time = 0.0,
		step_delta = 0.2
	}
end)

core.register_on_leaveplayer(function(player, timed_out)
	player_steps[player:get_player_name()] = nil
end)

core.register_globalstep(function(dtime)
	global_step_time = global_step_time + dtime
	for _, obj in ipairs(core.object_refs) do
		local velocity = obj:get_velocity()
		if not velocity then goto continue_iteration end
		velocity.y = 0

		local speed = vector.length(velocity)
		if math.abs(speed) < 0.001 then goto continue_iteration end

		if obj:is_player() then
			local data = player_steps[obj:get_player_name()]
			if not data then goto continue_iteration end

			local step_time = data.last_step_time + 1.5 / speed
			if step_time > global_step_time then goto continue_iteration end

			local pos = obj:get_pos()
			pos.y = math.round(pos.y - 0.001)

			local node = core.get_node(pos)
			local def = core.registered_nodes[node.name]

			if not def then goto continue_iteration end
			if not def._node_sounds then goto continue_iteration end
			if not def._node_sounds.footstep then goto continue_iteration end

			local step_delta = data.step_delta
			data.step_delta = -step_delta

			local side = vector.new(velocity.z, 0.0, -velocity.x)
			side = vector.normalize(side)

			pos.x = pos.x + side.x * step_delta
			pos.z = pos.z + side.z * step_delta

			data.last_step_time = global_step_time
			play_sound(def._node_sounds.footstep, pos)
		else
			--local entity = obj:get_luaentity()
			--if entity then
			--	core.chat_send_all(dump(entity))
			--end
		end

		::continue_iteration::
	end
end)
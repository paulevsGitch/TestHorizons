local PLAYERS = {}
local DELAY = 100000 -- Delay in microseconds

local function is_creative(player)
	local name = player:get_player_name()
	return core.is_creative_enabled(name)
end

core.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if is_creative(placer) then
		return true
	end
end)

core.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	if is_creative(puncher) then
		local name = puncher:get_player_name()
		local cacheTime = PLAYERS[name] or 0
		local time = core.get_us_time()
		if time > cacheTime then
			local node = core.get_node(pos)
			core.remove_node(pos)
			local def = core.registered_nodes[node.name]
			if def and def.after_dig_node then
				local meta = core.get_meta(pos)
				def.after_dig_node(pos, node, meta, puncher)
			end
		end
		PLAYERS[name] = time + DELAY
	end
end)

core.register_on_leaveplayer(function(player, timed_out)
	PLAYERS[player:get_player_name()] = nil
end)
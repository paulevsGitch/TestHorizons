core.register_on_player_receive_fields(function(player, formname, fields)
	for name, _ in pairs(fields) do
		if string.find(name, "_button_", 0, true) then
			local last_index = string.last_index_of(name, "_")
			local button_index = tonumber(string.sub(name, last_index + 1))
			last_index = string.last_index_of(string.sub(name, 1, last_index - 1), "_")
			local list_name = string.sub(name, 1, last_index - 1)
			core.chat_send_all(list_name .. " " .. dump(button_index))
		end
	end
end)

--core.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
--	core.chat_send_all(action)
--	return 0
--end)
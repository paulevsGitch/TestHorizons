local RADIAL_MENU_ID = "th_node_shapes:menu"
local PLAYER_SELECTED = {}

function NodeShapes.protected.make_formscpec(selected_node, node_list)
	local formspec_table = {
		"formspec_version[7]",
		"size[10,8]",
		"bgcolor[;neither;]",
		"no_prepend[]",
		"image[1,0;8,8;th_gui_shapes_circle.png;false]"
	}
	
	table.insert(formspec_table, "item_image[4,3;2,2;" .. selected_node .. "]")
	
	local count = #node_list
	
	for i = 1, count do
		local angle = (i - 1) * 2.0 * math.pi / count
		local px = 4.5 + math.sin(angle) * 3.0
		local py = 3.5 - math.cos(angle) * 3.0
		local desc = core.formspec_escape(core.registered_items[node_list[i]].description)
		table.insert(formspec_table, "image_button[" .. px .. "," .. py .. ";1,1;blank.png;button_" .. i .. ";;false;false]")
		table.insert(formspec_table, "item_image[" .. px .. "," .. py .. ";1,1;" .. node_list[i] .. "]")
		table.insert(formspec_table, "tooltip[" .. px .. "," .. py .. ";1,1;" .. desc .. ";#00000033;#FFFFFFFF]")
	end
	
	return table.concat(formspec_table)
end

function NodeShapes.protected.show_formspec(player, node_list, formspec)
	PLAYER_SELECTED[player:get_player_name()] = node_list
	core.show_formspec(player:get_player_name(), RADIAL_MENU_ID, formspec)
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= RADIAL_MENU_ID then return end
	
	local name = player:get_player_name()
	local node_list = PLAYER_SELECTED[name]
	local button_index = 0

	for k, _ in pairs(fields) do
		if string.sub(k, 1, 6) == "button" then
			button_index = tonumber(string.sub(k, 8, -1), 10)
		end
	end

	if button_index > 0 then
		local inventory = player:get_inventory()
		local index = player:get_wield_index()
		local stack = inventory:get_stack("main", index)
		stack:set_name(node_list[button_index])
		inventory:set_stack("main", index, stack)
		core.close_formspec(name, formname)
	end
end)

core.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
	if action == "move" then
		local list_from = inventory:get_list(inventory_info.from_list)
		local list_to = inventory:get_list(inventory_info.to_list)
		local index_from = inventory_info.from_index
		local index_to = inventory_info.to_index
		local stack_from = list_from[index_from]
		local stack_to = list_to[index_to]

		stack_to:set_name(stack_from:get_name())
		inventory:set_list(inventory_info.to_list, list_to)

		return 100
	end

	--if action == "put" then
	--	core.chat_send_all(dump(inventory_info))
	--	local list_to = inventory:get_list(inventory_info.listname)
	--	local index = inventory_info.index
	--	--local stack_from = inventory_info.stack
	--	--local stack_to = list_to[index]

	--	--stack_to:set_name(stack_from:get_name())
	--	list_to[index] = nil
	--	inventory:set_list(inventory_info.listname, list_to)

	--	return 100
	--end
end)
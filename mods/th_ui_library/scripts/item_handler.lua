local BUTTON_ACTIONS = {}
local LIST_BUTTON_ACTIONS = {}

---Register action on button press in UI.
---@param button_name string Name of the button.
---@param action fun(player:table) Action called on button click.
UILibrary.register_button_action = function(button_name, action)
	local actions = BUTTON_ACTIONS[button_name]
	if not actions then
		actions = {}
		BUTTON_ACTIONS[button_name] = actions
	end
	table.insert(actions, action)
end

---Register action on list button press in UI.
---@param list_name string Name of the list.
---@param action fun(player:table,button_index:integer) Action called on button click. Button index starts from 1.
UILibrary.register_list_button_action = function(list_name, action)
	local actions = LIST_BUTTON_ACTIONS[list_name]
	if not actions then
		actions = {}
		LIST_BUTTON_ACTIONS[list_name] = actions
	end
	table.insert(actions, action)
end

core.register_on_player_receive_fields(function(player, formname, fields)
	for button_name, _ in pairs(fields) do
		local actions = BUTTON_ACTIONS[button_name]
		if actions then
			for _, action in ipairs(actions) do
				action(player)
			end
		end
		if string.find(button_name, "_button_", 0, true) then
			local last_index = string.last_index_of(button_name, "_")
			local button_index = tonumber(string.sub(button_name, last_index + 1))
			last_index = string.last_index_of(string.sub(button_name, 1, last_index - 1), "_")
			local list_name = string.sub(button_name, 1, last_index - 1)
			actions = LIST_BUTTON_ACTIONS[list_name]
			if actions then
				for _, action in ipairs(actions) do
					action(player, button_index)
				end
			end
		end
	end
end)
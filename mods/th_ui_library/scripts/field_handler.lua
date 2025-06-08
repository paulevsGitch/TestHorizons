local BUTTON_ACTIONS = {}
local LIST_BUTTON_ACTIONS = {}
local FIELD_ACTIONS = {}

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

---Register action on field value change.
---@param field_name string Name of the list.
---@param action fun(player:table,field_value:string) Action called on field value change.
UILibrary.register_field_action = function (field_name, action)
	local actions = FIELD_ACTIONS[field_name]
	if not actions then
		actions = {}
		FIELD_ACTIONS[field_name] = actions
	end
	table.insert(actions, action)
end

core.register_on_player_receive_fields(function(player, formname, fields)
	for field_name, field_value in pairs(fields) do
		--core.chat_send_all(field_name .. " " .. field_value)
		local actions = BUTTON_ACTIONS[field_name]
		if actions then
			for _, action in ipairs(actions) do
				action(player)
			end
		end

		actions = FIELD_ACTIONS[field_name]
		if actions then
			for _, action in ipairs(actions) do
				action(player, field_value)
			end
		end

		if string.find(field_name, "_button_", 0, true) then
			local last_index = string.last_index_of(field_name, "_")
			local button_index = tonumber(string.sub(field_name, last_index + 1))
			last_index = string.last_index_of(string.sub(field_name, 1, last_index - 1), "_")
			local list_name = string.sub(field_name, 1, last_index - 1)
			actions = LIST_BUTTON_ACTIONS[list_name]
			if actions then
				for _, action in ipairs(actions) do
					action(player, button_index)
				end
			end
		end
	end
end)
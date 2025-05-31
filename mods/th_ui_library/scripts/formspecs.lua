UILibrary.formspec_builder = {}

local formspec_str = ""

-- Defined in a specific order
local formspec_size = ""
local formspec_pos = ""
local formspec_anchor = ""

---Start formspec building process and returns builder.
---@return table UILibrary.formspec_builder
UILibrary.formspec_builder.start = function ()
	formspec_str = ""
	formspec_size = ""
	formspec_pos = ""
	formspec_anchor = ""
	return UILibrary.formspec_builder
end

---End formspec building and returns formspec string.
---@return string
UILibrary.formspec_builder.build = function ()
	return formspec_size .. formspec_pos .. formspec_anchor .. formspec_str
end

---Set size of the formspec and returns builder. Size is in units that are equal to inventory cell size.
---@param width number Width of the formspec in units.
---@param height number Height of the formspec in units.
---@param fixed_size boolean Fixed size (Optional)
---@return table UILibrary.formspec_builder
UILibrary.formspec_builder.set_size = function (width, height, fixed_size)
	formspec_size = "size[" .. tostring(width) .. "," .. tostring(height)
	if fixed_size then
		formspec_size = formspec_size  .. ",<fixed_size>]"
	else
		formspec_size = formspec_size  .. "]"
	end
	return UILibrary.formspec_builder
end

---Set formspec position and returns builder. Position is in units that are equal to inventory cell size.
---Position is relative to formspec anchor point, default is center on the screen.
---@param x number Horizontal formspec position.
---@param y number Vertical formspec position.
---@return table
UILibrary.formspec_builder.set_pos = function (x, y)
	formspec_pos = "position[" .. tostring(x) .. "," .. tostring(y) .. "]"
	return UILibrary.formspec_builder
end

---Set formspec anchor and returns builder. Anchor is in relative coordinates from 0.0 to 1.0 relative to the size of parent formspec or screen.
---@param x number Horizontal formspec anchor.
---@param y number Vertical formspec anchor.
---@return table UILibrary.formspec_builder
UILibrary.formspec_builder.set_anchor = function (x, y)
	formspec_anchor = "anchor[" .. tostring(x) .. "," .. tostring(y) .. "]"
	return UILibrary.formspec_builder
end

---Add list of inventory items to the formspec and returns builder.
---@param inventory_location string Inventory location name, see https://github.com/luanti-org/luanti/blob/master/doc/lua_api.md#inventory-locations
---@param list_name string Name of list inside inventory.
---@param x number X position inside formspec.
---@param y number Y position inside formspec.
---@param width integer Width of the list in items count.
---@param height integer Height of the list in items count.
---@param starting_index integer Item starting index (Optional)
---@return table UILibrary.formspec_builder
UILibrary.formspec_builder.list = function (inventory_location, list_name, x, y, width, height, starting_index)
	formspec_str = formspec_str .. "list["
		.. inventory_location .. ";" .. list_name .. ";"
		.. tostring(x) .. "," .. tostring(y) .. ";"
		.. tostring(width) .. "," .. tostring(height)
	if starting_index then
		formspec_str = formspec_str .. ";" .. starting_index .. "]"
	else
		formspec_str = formspec_str .. "]"
	end
	return UILibrary.formspec_builder
end

---Add image button to the formspec and returns builder. Position and size are in units that are equal to inventory cell size.
---@param x number X position of the button in units.
---@param y number Y position of the button in units.
---@param width number Width of the button in units.
---@param height number Height of the button in units.
---@param texture_name string Name of the texture to cover the button.
---@param name string Button name to use in handle events.
---@param label string Displayed button label.
---@param noclip boolean Clip texture to button size or not.
---@param drawborder boolean Draw button borders or not.
---@param pressed_texture_name string Name of the texture to cover the button when it is pressed.
---@return table UILibrary.formspec_builder
UILibrary.formspec_builder.image_button = function (x, y, width, height, texture_name, name, label, noclip, drawborder, pressed_texture_name)
	if not pressed_texture_name then
		pressed_texture_name = texture_name
	end

	drawborder = drawborder or false
	noclip = noclip or false
	label = label or ""

	formspec_str = formspec_str .. "image_button["
		.. tostring(x) .. "," .. tostring(y)
		.. ";" .. tostring(width) .. "," .. tostring(height)
		.. ";" .. texture_name .. ";"
		.. name .. ";" .. label ..
		";" .. tostring(noclip) .. ";"
		.. tostring(drawborder) .. ";"
		.. pressed_texture_name .. "]"
	return UILibrary.formspec_builder
end

---Add invisible button to the formspec and returns builder.
---@param x number X position of the button in units.
---@param y number Y position of the button in units.
---@param width number Width of the button in units.
---@param height number Height of the button in units.
---@param name string Button name to use in handle events.
---@return table UILibrary.formspec_builder
UILibrary.formspec_builder.transparent_button = function (x, y, width, height, name)
	return UILibrary.formspec_builder.image_button(x, y, width, height, "blank.png", name, "", false, false, "")
end

---Add list of inventory items with transparent buttons to the formspec and returns builder.
---@param inventory_location string Inventory location name, see https://github.com/luanti-org/luanti/blob/master/doc/lua_api.md#inventory-locations
---@param list_name string Name of list inside inventory.
---@param x number X position inside formspec.
---@param y number Y position inside formspec.
---@param width integer Width of the list in items count.
---@param height integer Height of the list in items count.
---@param start_index integer Item start index (inclusive).
---@param end_index integer Item end index (inclusive).
---@return table UILibrary.formspec_builder
UILibrary.formspec_builder.list_with_buttons = function (inventory_location, list_name, x, y, width, height, start_index, end_index)
	UILibrary.formspec_builder.list(inventory_location, list_name, x, y, width, height, start_index)

	local pos_index = 0
	for index = start_index, end_index do
		local dy = math.floor(pos_index / width)
		local dx = (pos_index - dy * width) + x
		dy = dy + y
		pos_index = pos_index + 1
		UILibrary.formspec_builder.transparent_button(dx, dy, 1, 1, list_name .. "_button_" .. tostring(index))
		--formspec_str = formspec_str .. "set_focus[" .. list_name .. "_button_" .. tostring(index) .. ";true]"
	end

	return UILibrary.formspec_builder
end
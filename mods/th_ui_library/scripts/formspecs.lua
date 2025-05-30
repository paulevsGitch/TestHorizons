UILibrary.formspec_builder = {}

local formspec_str = ""

-- Defined in a specific order
local formspec_size = ""
local formspec_pos = ""
local formspec_anchor = ""

---Start formspec building process and returns builder.
---@return table
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
---@return table
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
---@return table
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
---@return table
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
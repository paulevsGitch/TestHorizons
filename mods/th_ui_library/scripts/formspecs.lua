UILibrary.formspec_builder = {}

local SLOT_SPACING = 2.0 / 18.0
local SLOT_OFFSET = SLOT_SPACING * 0.5
local SLOT_SIZE = 1.0 - SLOT_SPACING
local DEF_STYLE = "style_type[list;spacing=" .. tostring(SLOT_SPACING) .. ";size=" .. tostring(SLOT_SIZE) .. "]"
	.. "listcolors[#0000;#41444a]"
	.. "style_type[button;bgcolor=#0000;hovered=#FF41444a;border=false]"
	.. "style_type[label;font_size=24]"
	.. "style_type[field;border=false]"

local formspec_str = ""

-- Defined in a specific order
local formspec_size = ""
local formspec_pos = ""
local formspec_anchor = ""

local scrollbar = ""
local scrollbar_index = 0
local background_size = ""

---Start formspec building process and returns builder.
---@param width number Width of the formspec in units.
---@param height number Height of the formspec in units.
---@param fixed_size? boolean Fixed size (Optional).
---@return table
UILibrary.formspec_builder.start = function (width, height, fixed_size)
	formspec_str = ""
	formspec_pos = ""
	formspec_anchor = ""

	background_size = tostring(width) .. "," .. tostring(height)
	formspec_size = "size[" .. background_size
	if fixed_size then
		formspec_size = formspec_size  .. ",<fixed_size>]"
	else
		formspec_size = formspec_size  .. "]"
	end

	return UILibrary.formspec_builder
end

---End formspec building and returns formspec string.
---@return string
UILibrary.formspec_builder.build = function ()
	return "formspec_version[9]" .. formspec_size .. formspec_pos .. formspec_anchor .. DEF_STYLE .. formspec_str
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
---@param starting_index? integer Item starting index (Optional)
---@return table
UILibrary.formspec_builder.list = function (inventory_location, list_name, x, y, width, height, starting_index)
	local pos_index = 0
	local last_index = width * height - 1
	for _ = 0, last_index do
		local dy = math.floor(pos_index / width)
		local dx = (pos_index - dy * width) + x
		dy = dy + y
		pos_index = pos_index + 1
		formspec_str = formspec_str .. "image[" .. tostring(dx) .. "," .. tostring(dy) .. ";1,1;th_ui_slot.png]"
	end

	formspec_str = formspec_str .. "list["
		.. inventory_location .. ";" .. list_name .. ";"
		.. tostring(x + SLOT_OFFSET) .. "," .. tostring(y + SLOT_OFFSET) .. ";"
		.. tostring(width) .. "," .. tostring(height)
	
	if starting_index then
		formspec_str = formspec_str .. ";" .. starting_index .. "]"
	else
		formspec_str = formspec_str .. "]"
	end

	return UILibrary.formspec_builder
end

---Add button to the formspec and returns builder.
---@param x number X position of the button in units.
---@param y number Y position of the button in units.
---@param width number Width of the button in units.
---@param height number Height of the button in units.
---@param button_name string Button name to use in handle events.
---@param label? string Displayed button label (Optional).
---@return table
UILibrary.formspec_builder.button = function (x, y, width, height, button_name, label)
	label = label or ""
	formspec_str = formspec_str .. "button["
		.. tostring(x) .. "," .. tostring(y)
		.. ";" .. tostring(width) .. "," .. tostring(height)
		.. ";" .. button_name .. ";" .. label .. "]"
	return UILibrary.formspec_builder
end

---Add image button to the formspec and returns builder. Position and size are in units that are equal to inventory cell size.
---@param x number X position of the button in units.
---@param y number Y position of the button in units.
---@param width number Width of the button in units.
---@param height number Height of the button in units.
---@param texture_name string Name of the texture to cover the button.
---@param button_name string Button name to use in handle events.
---@param label? string Displayed button label (Optional).
---@param noclip? boolean Clip texture to button size or not (Optional).
---@param drawborder? boolean Draw button borders or not (Optional).
---@param pressed_texture_name? string Name of the texture to cover the button when it is pressed (Optional).
---@return table
UILibrary.formspec_builder.image_button = function (x, y, width, height, texture_name, button_name, label, noclip, drawborder, pressed_texture_name)
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
		.. button_name .. ";" .. label ..
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
---@param button_name string Button name to use in handle events.
---@return table
UILibrary.formspec_builder.transparent_button = function (x, y, width, height, button_name)
	return UILibrary.formspec_builder.image_button(x, y, width, height, "blank.png", button_name, "", false, false, "")
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
---@return table
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

---Add image to the formspec and returns builder.
---@param x number X position inside formspec.
---@param y number Y position inside formspec.
---@param width number Width of the image in units.
---@param height number Height of the image in units.
---@param texture string Image texture.
---@return table
UILibrary.formspec_builder.image = function (x, y, width, height, texture)
	formspec_str = formspec_str .. "image[" .. x .. "," .. y .. ";" .. width .. "," .. height .. ";" .. texture .. "]"
	return UILibrary.formspec_builder
end

---Add item image to the formspec and returns builder.
---@param x number X position inside formspec.
---@param y number Y position inside formspec.
---@param width number Width of the button in units.
---@param height number Height of the button in units.
---@param item_id string Item ID to display on button.
---@return table
UILibrary.formspec_builder.item_image = function (x, y, width, height, item_id)
	formspec_str = formspec_str .. "item_image[" .. x .. "," .. y .. ";" .. width .. "," .. height .. ";" .. item_id .. "]"
	return UILibrary.formspec_builder
end

---Add button with item image to the formspec and returns builder.
---@param x number X position inside formspec.
---@param y number Y position inside formspec.
---@param width number Width of the button in units.
---@param height number Height of the button in units.
---@param button_name string Button name to use in handle events.
---@param item_id string Item ID to display on button.
---@return table
UILibrary.formspec_builder.item_button = function (x, y, width, height, button_name, item_id)
	UILibrary.formspec_builder.transparent_button(x, y, width, height, button_name)
	UILibrary.formspec_builder.item_image(x, y, width, height, item_id)
	return UILibrary.formspec_builder
end

---Add button list with item images to the formspec and returns builder.
---@param list_name any
---@param x number X position inside formspec.
---@param y number Y position inside formspec.
---@param width integer Width of the list, items count.
---@param items_id_list table Array of item Ids.
---@return table
UILibrary.formspec_builder.item_button_list = function (list_name, x, y, width, items_id_list, cell_count)
	if not cell_count then
		cell_count = #items_id_list--math.ceil(#items_id_list / width) * width
	end
	for index = 0, cell_count - 1 do
		local dy = math.floor(index / width)
		local dx = (index - dy * width) + x
		dy = dy + y
		formspec_str = formspec_str .. "image[" .. tostring(dx) .. "," .. tostring(dy) .. ";1,1;th_ui_slot.png]"
	end

	local pos_index = 0
	for _, item_id in ipairs(items_id_list) do
		local dy = math.floor(pos_index / width)
		local dx = (pos_index - dy * width) + x
		dy = dy + y
		pos_index = pos_index + 1
		local button_name = list_name .. "_button_" .. tostring(pos_index)
		local tooltip_text = core.formspec_escape(minetest.registered_items[item_id].description or "")
		formspec_str = formspec_str .. "tooltip[" .. button_name .. ";" .. tooltip_text .. "]"
		UILibrary.formspec_builder.button(dx, dy, 1, 1, list_name .. "_button_" .. tostring(pos_index))
		UILibrary.formspec_builder.item_image(
			dx + SLOT_OFFSET,
			dy + SLOT_OFFSET,
			SLOT_SIZE,
			SLOT_SIZE,
			item_id
		)
	end

	return UILibrary.formspec_builder
end

---Start scroll container block in the formspec and returns builder.
---@param x number X position inside formspec.
---@param y number Y position inside formspec.
---@param width number Width of the button in units.
---@param height number Height of the button in units.
---@param orientation string Scroll bar orientation, "vertical" or "horizontal". Optional, default is "vertical"
---@param scroll_factor number Scroll bar speed. Optional, default is 0.1.
---@param content_padding number Padding between items. Optional, default is 0.0.
---@return table
UILibrary.formspec_builder.start_scroll_container = function (x, y, width, height, orientation, scroll_factor, content_padding)
	orientation = orientation or "vertical"
	scroll_factor = scroll_factor or 0.1
	content_padding = content_padding or 0.0
	
	local scrollbar_name = "scrollbar_" .. tostring(scrollbar_index)
	scrollbar_index = scrollbar_index + 1

	local scx = x
	local scy = y
	local scw = 0.5
	local sch = 0.5
	if orientation == "vertical" then
		scx = scx + width
		sch = height
	else
		scy = scy + height
		scw = width
	end
	
	scrollbar = "scrollbar["
		.. tostring(scx) .. "," .. tostring(scy) .. ";"
		.. tostring(scw) .. "," .. tostring(sch) .. ";"
		.. orientation .. ";"
		.. scrollbar_name .. ";0]"

	formspec_str = formspec_str .. "scroll_container["
		.. tostring(x) .. "," .. tostring(y) .. ";"
		.. tostring(width) .. "," .. tostring(height) .. ";"
		.. scrollbar_name .. ";"
		.. orientation .. ";"
		.. tostring(scroll_factor) .. ";"
		.. tostring(content_padding) .. "]"
	
	return UILibrary.formspec_builder
end

---End scroll container block in the formspec and returns builder.
---@return table
UILibrary.formspec_builder.end_scroll_container = function ()
	formspec_str = formspec_str .. "scroll_container_end[]" .. scrollbar
	return UILibrary.formspec_builder
end

---Set default formspec background and returns builder.
---@param x? number X position inside formspec (Optional).
---@param y? number Y position inside formspec (Optional).
---@param width? number Width in units (Optional).
---@param height? number Height in units (Optional).
---@return table
UILibrary.formspec_builder.default_background = function (x, y, width, height)
	x = x or 0
	y = y or 0
	local size = background_size
	if width and height then
		size = tostring(width) .. "," .. tostring(height)
	end

	formspec_str = formspec_str .. "bgcolor[;neither;]background9["
		.. tostring(x) .. "," .. tostring(y)
		.. ";" .. size .. ";th_ui_back.png;false;12]"
	
	return UILibrary.formspec_builder
end

---Append inventory list to internal inventory ring for shift-click item transfer and returns builder.
---@param inventory_location string Target location, possible values: "context" (node metadata), "current_player", "player:<name>" (any player), "nodemeta:<X>,<Y>,<Z>" (any node meta), "detached:<name>" (detached inventory)
---@param list_name string List name.
---@return table
UILibrary.formspec_builder.list_ring = function (inventory_location, list_name)
	formspec_str = formspec_str .. "listring[" .. inventory_location .. ";" .. list_name .. "]"
	return UILibrary.formspec_builder
end

---Add label on specified position inside formspec and returns builder.
---@param x number X position inside formspec.
---@param y number Y position inside formspec.
---@param text string Label text.
---@return table
UILibrary.formspec_builder.label = function (x, y, text)
	formspec_str = formspec_str .. "label[" .. tostring(x) .. "," .. tostring(y) .. ";" .. text .. "]"
	return UILibrary.formspec_builder
end

---Add text field to the formspec and returns builder.
---@param x number X position inside formspec.
---@param y number Y position inside formspec.
---@param width number Width in units.
---@param name string Name of the field.
---@param default_value? string Default value in the field (Optional).
---@return table
UILibrary.formspec_builder.field = function (x, y, width, name, default_value)
	default_value = default_value or ""
	formspec_str = formspec_str .. "image[" .. tostring(x) .. "," .. tostring(y) .. ";" .. tostring(width) .. ",0.5;th_ui_input.png;4]"
	formspec_str = formspec_str .. "field["
		.. tostring(x + 0.0625) .. "," .. tostring(y) .. ";"
		.. tostring(width - 0.125) .. ",0.5;" .. name .. ";;" .. default_value .. "]"
	formspec_str = formspec_str .. "field_close_on_enter[" .. name .. ";false]"
	return UILibrary.formspec_builder
end
local translate = core.get_translator(core.get_current_modname())
local ALL_ITEMS_NAME = translate("All Items")
local ALL_ITEMS = { name = ALL_ITEMS_NAME, key = "All Items", items = {}, icon = "th_search_icon.png" }
local CREATIVE_TABS = { [ALL_ITEMS_NAME] = ALL_ITEMS }
local CREATIVE_TABS_ORDER = { ALL_ITEMS }
local FILTERED_ITEMS = {}
local KEY_CREATIVE_PAGE_INDEX = "creative_page_index"
local KEY_CREATIVE_TAB_INDEX = "creative_tab_index"
local KEY_CREATIVE_TAB_FILTER = "creative_tab_item_filter"
local creative_pages

THCreative.add_item = function (tab_name, item_id)
	local tab = CREATIVE_TABS[tab_name]
	if not tab then
		tab = { name = translate(tab_name), key = tab_name, items = {} }
		CREATIVE_TABS[tab_name] = tab
		table.insert(CREATIVE_TABS_ORDER, tab)
	end
	table.insert(tab.items, item_id)
end

local function init_pages()
	if creative_pages then
		return
	end

	creative_pages = {}

	for index, tab in ipairs(CREATIVE_TABS_ORDER) do
		local page_index = math.floor((index - 1) / 7) + 1
		local page = creative_pages[page_index]
		if not page then
			page = {}
			creative_pages[page_index] = page
		end
		table.insert(page, tab)
	end
end

local function get_tab_formspec(player)
	local meta = player:get_meta()
	local page_index = math.clamp(meta:get_int(KEY_CREATIVE_PAGE_INDEX), 1, #creative_pages)
	local page = creative_pages[page_index]
	local tab_index = math.clamp(meta:get_int(KEY_CREATIVE_TAB_INDEX), 1, #page)
	local item_filter = meta:get_string(KEY_CREATIVE_TAB_FILTER)

	local builder = UILibrary.formspec_builder.start(10.5, 12.75)
	local tab = page[tab_index]

	for index = 1, 7 do
		local icon_tab = page[index]
		if icon_tab then
			local px = (index - 1) * 1.49857
			if index == tab_index then
				builder.image(px, 0, 1.51, 1.63, "th_tab.png")
			else
				builder.default_background(px, 0, 1.51, 2)
			end

			if index ~= tab_index then
				builder.transparent_button(px + 0.25, 0.25, 1, 1, "button_tab_" .. tostring(index))
			end

			if icon_tab.icon then
				if string.ends_with(icon_tab.icon, ".png") then
					builder.image(px + 0.25, 0.25, 1, 1, icon_tab.icon)
				end
			elseif icon_tab.items[1] then
				builder.item_image(px + 0.25, 0.25, 1, 1, icon_tab.items[1])
			end
		end
	end

	tab = page[tab_index]
	builder.default_background(0, 1.5, 10.5, 12.75 - 1.5)

	builder.label(0.25, 1.95, tab.name)
	builder.field(5.25, 1.7, 4.5, "creative_tab_search", item_filter or "")

	local items = tab.items
	if item_filter and item_filter ~= "" then
		items = {}
		for _, item in ipairs(tab.items) do
			if string.find(item, item_filter, 1, true) then
				table.insert(items, item)
			end
		end
		FILTERED_ITEMS[player:get_player_name()] = items
	else
		FILTERED_ITEMS[player:get_player_name()] = nil
	end

	local count = math.max(81, math.ceil(#items / 9) * 9)
	if #items > 81 then
		builder.start_scroll_container(0.25, 2.25, 9, 9)
		builder.item_button_list(tab.key, 0.0, 0.0, 9, items, count)
		builder.end_scroll_container()
	else
		builder.item_button_list(tab.key, 0.25, 2.25, 9, items, count)
	end
	builder.list("current_player", "main", 0.25, 11.5, 9, 1) -- hotbar
	
	builder.list_ring("current_player", "main")
	builder.list_ring("current_player", "trash")

	return builder.build()
end

THCreative.get_formspec = function (player)
	init_pages()
	return get_tab_formspec(player)
end

core.register_on_mods_loaded(function()
	local names = {}

	for name, def in pairs(core.registered_nodes) do
		if not def.groups or not def.groups.not_in_creative_inventory then
			table.insert(names, name)
		end
	end

	table.sort(names)

	for _, name in ipairs(names) do
		table.insert(ALL_ITEMS.items, name)
	end
end)

UILibrary.register_list_button_action("All Items", function (player, button_index)
	local items = ALL_ITEMS.items
	local filtered = FILTERED_ITEMS[player:get_player_name()]
	if filtered then
		items = filtered
	end
	local item_id = items[button_index]
	local inventory = player:get_inventory()
	inventory:add_item("main", ItemStack(item_id))
end)

for i = 1, 7 do
	local index = i
	UILibrary.register_button_action("button_tab_" .. tostring(index), function (player)
		local meta = player:get_meta()
		meta:set_int(KEY_CREATIVE_TAB_INDEX, index)
		player:set_inventory_formspec(get_tab_formspec(player))
	end)
end

UILibrary.register_field_action("creative_tab_search", function (player, field_value)
	local meta = player:get_meta()
	local old_search = meta:get_string(KEY_CREATIVE_TAB_FILTER)
	if old_search ~= field_value then
		meta:set_string(KEY_CREATIVE_TAB_FILTER, field_value)
		player:set_inventory_formspec(get_tab_formspec(player))
	end
end)
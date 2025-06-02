local ALL_ITEMS = { name = "all_items", items = {} }
local CREATIVE_TABS = { ["all_items"] = ALL_ITEMS }
local CREATIVE_TABS_ORDER = { ALL_ITEMS }
local creative_pages

THCreative.add_item = function (tab_name, item_id)
	local tab = CREATIVE_TABS[tab_name]
	if not tab then
		tab = { name = tab_name, items = {} }
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
		local page_index = math.floor((index - 1) / 9) + 1
		local page = creative_pages[page_index]
		if not page then
			page = {}
			creative_pages[page_index] = page
		end
		table.insert(page, tab)
	end
end

THCreative.get_formspec = function (player)
	init_pages()

	local page = creative_pages[1]
	local tab = page[1]
	local builder = UILibrary.formspec_builder.start(10, 10.75).default_background()

	builder.start_scroll_container(0.25, 0.25, 9, 9)
	builder.item_button_list(tab.name, 0.0, 0.0, 9, tab.items)
	builder.end_scroll_container()
	builder.list("current_player", "main", 0.25, 9.5, 9, 1) -- hotbar
	
	builder.list_ring("current_player", "main")
	builder.list_ring("current_player", "trash")

	return builder.build()
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

UILibrary.register_list_button_action("all_items", function (player, button_index)
	local item_id = ALL_ITEMS.items[button_index]
	local inventory = player:get_inventory()
	inventory:add_item("main", ItemStack(item_id))
end)
local SURVIVAL_FORMSPEC = UILibrary.formspec_builder.start(9.5, 4.75)
	.default_background()
	.list("current_player", "main", 0.25, 0.25, 9, 3, 9) -- main inventory
	.list("current_player", "main", 0.25, 3.5, 9, 1) -- hotbar
	.build()

local EMPTY_STACK = ItemStack(nil)

core.register_on_joinplayer(function(player, last_login)
	local inventory = player:get_inventory()
	inventory:set_size("main", 9 * 4)
	inventory:set_size("trash", 1)
	player:hud_set_hotbar_itemcount(9)
	player:hud_set_hotbar_image("th_hotbar.png")
	player:hud_set_hotbar_selected_image("th_hotbar_selection.png")

	local spec = SURVIVAL_FORMSPEC
	if THCreative.is_in_creative(player) then
		spec = THCreative.get_formspec(player)
	end
	player:set_inventory_formspec(spec)
end)

core.register_on_player_inventory_action(function(player, action, inventory, inventory_info)
	player:get_inventory():set_stack("trash", 1, EMPTY_STACK)
end)
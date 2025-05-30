local SURVIVAL_FORMSPEC = UILibrary.formspec_builder.start()
	.set_size(9, 4)
	.list("current_player", "main", 0, 0, 9, 3, 9) -- main inventory
	.list("current_player", "main", 0, 3.25, 9, 1, 0) -- hotbar
	.build()

core.register_on_joinplayer(function(player, last_login)
	local inventory = player:get_inventory()
	inventory:set_size("main", 9 * 4)
	player:hud_set_hotbar_itemcount(9)
	player:set_inventory_formspec(SURVIVAL_FORMSPEC)
	player:hud_set_hotbar_image("th_hotbar.png")
end)
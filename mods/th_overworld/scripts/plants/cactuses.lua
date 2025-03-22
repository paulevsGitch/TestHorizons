local translate = THOverworld.translate

core.register_node("th_overworld:small_cactus", {
	drawtype = "plantlike",
	on_place = PlacementRules.sand_requirement,
	description = translate("Small Cactus"),
	inventory_image = "th_small_cactus.png",
	wield_image = "th_small_cactus.png",
	tiles = { "th_small_cactus.png" },
	paramtype = "light",
	groups = { plant = 1, cactus = 1 }
})

core.register_node("th_overworld:pillar_cactus", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = { -0.25, -0.75, -0.25, 0.25, 0.25, 0.25 }
	},
	on_place = PlacementRules.sand_requirement,
	description = translate("Pillar Cactus"),
	tiles = { "th_pillar_cactus.png" },
	paramtype = "light",
	groups = { plant = 1, cactus = 1 }
})

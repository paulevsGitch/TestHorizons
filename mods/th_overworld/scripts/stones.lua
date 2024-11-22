local translate = THOverworld.translate

core.register_node("th_overworld:stone", {
	description = translate("Stone"),
	tiles = {"th_stone.png"},
	groups = { stone = 1, solid = 1 }
})

NodeShapes.register_shapes_set("th_overworld:stone", {
	{ type = "slab" },
	{ type = "panel" },
	{ type = "stairs" },
	{ type = "pillar" },
	{ type = "thin_pillar" },
	{ type = "post" },
	{ type = "wall" },
	{ type = "fence_flat" }
})
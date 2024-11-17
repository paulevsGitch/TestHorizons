local translate = THOverworld.translate

core.register_node("th_overworld:stone", {
	description = translate("Stone"),
	tiles = {"th_stone.png"},
	groups = { stone = 1, solid = 1 }
})

NODE_SHAPES.register_shapes_set("th_overworld:stone")
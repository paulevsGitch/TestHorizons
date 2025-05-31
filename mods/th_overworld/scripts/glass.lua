local translate = THOverworld.protected.translate

NodeShapes.register_shapes_set("th_overworld:glass", {
	description = translate("Glass"),
	tiles = {{
		name = "th_glass.png",
		backface_culling = true
	}},
	groups = { glass = 1 },
	use_texture_alpha = "clip",
	paramtype = "light",
	sunlight_propagates = true,
	drawtype = "glasslike",
	_node_sounds = THOverworld.sounds.glass
}, {
	{ type = "cube" },
	{ type = "slab" },
	{ type = "panel" },
	--{ type = "stairs" }
})
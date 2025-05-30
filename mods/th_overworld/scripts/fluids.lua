local translate = THOverworld.protected.translate

local texture_source = {
	name = "th_water.png",
	backface_culling = false,
	animation = {
		type = "vertical_frames",
		aspect_w = 16,
		aspect_h = 16,
		length = 8.0,
	}
}

local texture_flowing = {
	name = "th_water.png",
	backface_culling = false,
	animation = {
		type = "vertical_frames",
		aspect_w = 16,
		aspect_h = 16,
		length = 4.0,
	}
}

core.register_node("th_overworld:water_source", {
	description = translate("Water Source"),
	drawtype = "liquid",
	paramtype2 = "flowingliquid",
	leveled = 4,
	waving = 3,
	tiles = {texture_source, texture_source},
	use_texture_alpha = "blend",
	paramtype = "light",
	sunlight_propagates = false,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "th_overworld:water_flowing",
	liquid_alternative_source = "th_overworld:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90}
})

core.register_node("th_overworld:water_flowing", {
	description = translate("Flowing Water"),
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {texture_flowing},
	special_tiles = {texture_flowing, texture_flowing},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	sunlight_propagates = false,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "th_overworld:water_flowing",
	liquid_alternative_source = "th_overworld:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {not_in_creative_inventory = 1}
})
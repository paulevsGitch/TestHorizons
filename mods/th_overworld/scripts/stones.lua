local translate = THOverworld.translate

local function register_stone(name)
	NodeShapes.register_simple_stone_set("th_overworld:" .. name, {
		description = translate(string.snake_to_title(name)),
		tiles = {"th_" .. name .. ".png"},
		groups = { stone = 1, solid = 1 }
	})
end

register_stone("stone")
register_stone("sandstone")
register_stone("dark_sandstone")

local size_half_1 = 0.5 / 2.0
local size_half_2 = 0.501 / 2.0
local size_half_3 = 1.0 / 2.0
local size_half_4 = 0.502 / 2.0

core.register_node("th_overworld:sandstone_to_dark", {
	description = translate("sandstone"),
	--tiles = {"th_dark_sandstone.png", "th_sandstone.png", "th_sandstone_to_dark.png"},
	tiles = {{ name = "4-dir.png", scale = 3, align_style = "node" }},
	groups = { stone = 1, solid = 1 },
	visual_scale = 2.0,
	drawtype = "nodebox",
	node_box = {
		type = "connected",
		fixed = { -size_half_1, -size_half_1, -size_half_1, size_half_1, size_half_1, size_half_1 },
		connect_front = { -size_half_2, -size_half_2, -size_half_3, size_half_2, size_half_2, -size_half_1 },
		connect_back = { -size_half_2, -size_half_2, size_half_1, size_half_2, size_half_2, size_half_3 },
		connect_right = { size_half_1, -size_half_4, -size_half_4, size_half_3, size_half_4, size_half_4 },
		connect_left = { -size_half_3, -size_half_4, -size_half_4, -size_half_1, size_half_4, size_half_4 },
		connect_top = { -size_half_2, size_half_1, -size_half_2, size_half_2, size_half_3, size_half_2 },
		connect_bottom = { -size_half_2, -size_half_3, -size_half_2, size_half_2, -size_half_1, size_half_2 }
	},
	collision_box = {
		type = "connected",
		fixed = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 }
	},
	selection_box = {
		type = "connected",
		fixed = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 }
	},
	connects_to = { "th_overworld:dark_sandstone" },
	use_texture_alpha = "clip"
})
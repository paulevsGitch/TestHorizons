local translate = core.get_translator("th_node_shapes")

local PILLAR_BOX_MIDDLE = {
	type = "fixed",
	fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125}
}

local PILLAR_BOX_TOP = {
	type = "fixed",
	fixed = {
		{-0.3125, -0.5, -0.3125, 0.3125, 0.45, 0.3125},
		{-0.4375, 0.3125, -0.4375, 0.4375, 0.5, 0.4375},
		{-0.375, 0.125, -0.375, 0.375, 0.3125, 0.375}
	}
}

local PILLAR_BOX_BOTTOM = {
	type = "fixed",
	fixed = {
		{-0.3125, -0.45, -0.3125, 0.3125, 0.5, 0.3125},
		{-0.4375, -0.3125, -0.4375, 0.4375, -0.5, 0.4375},
		{-0.375, -0.125, -0.375, 0.375, -0.3125, 0.375}
	}
}

local PILLAR_BOX_SMALL = {
	type = "fixed",
	fixed = {
		{-0.3125, -0.45, -0.3125, 0.3125, 0.45, 0.3125},
		{-0.4375, 0.3125, -0.4375, 0.4375, 0.5, 0.4375},
		{-0.375, 0.125, -0.375, 0.375, 0.3125, 0.375},
		{-0.4375, -0.3125, -0.4375, 0.4375, -0.5, 0.4375},
		{-0.375, -0.125, -0.375, 0.375, -0.3125, 0.375}
	}
}

local STAIRS_ANGLES = { 5, 7, 11, 9 }

local MUTABLE_POS = vector.zero()
local PILLAR_POS = vector.zero()

-- 0 = y+,   1 = z+,   2 = z-,   3 = x+,   4 = x-,   5 = y-
local function simple_facedir(dir)
	if dir.x == 1 then
		return 4
	elseif dir.x == -1 then
		return 3
	elseif dir.y == 1 then
		return 5
	elseif dir.y == -1 then
		return 0
	elseif dir.z == 1 then
		return 2
	else
		return 1
	end
end

local function place_slab(itemstack, placer, pointed_thing)
	local dir = vector.subtract(pointed_thing.under, pointed_thing.above)
	local index = core.dir_to_wallmounted(dir)
	if not placer:get_player_control().sneak then
		local node = core.get_node(pointed_thing.under)
		if core.get_node_group(node.name, "slab") > 0 and bit.rshift(index, 1) ~= bit.rshift(node.param2, 1) then
			index = node.param2
		end
	end
	return core.item_place(itemstack, placer, pointed_thing, index)
end

local function place_stairs(itemstack, placer, pointed_thing)
	local dir = vector.subtract(pointed_thing.under, pointed_thing.above)
	local vec = placer:get_look_dir()
	
	local index = 0
	
	if dir.y ~= 0 then
		local ax = math.abs(vec.x)
		local az = math.abs(vec.z)
		local mx = math.max(ax, az)
		local rotation = 0
		
		if dir.y < 0 then
			if mx == ax then
				if vec.x > 0 then
					rotation = 1
				else
					rotation = 3
				end
			else
				if vec.z > 0 then
					rotation = 0
				else
					rotation = 2
				end
			end
		else
			if mx == ax then
				if vec.x > 0 then
					rotation = 3
				else
					rotation = 1
				end
			else
				if vec.z > 0 then
					rotation = 0
				else
					rotation = 2
				end
			end
		end
		
		index = bit.bor(bit.lshift(simple_facedir(dir), 2), rotation)
	else
		local rotation = math.atan2(vec.x, vec.z)
		rotation = math.floor((rotation + math.pi) * 2.0 / math.pi)
		rotation = bit.band(rotation + 1, 3) + 1
		index = STAIRS_ANGLES[rotation]
	end
	
	return core.item_place(itemstack, placer, pointed_thing, index)
end

local function place_pillar(itemstack, placer, pointed_thing)
	local dir = vector.subtract(pointed_thing.under, pointed_thing.above)
	local index = core.dir_to_wallmounted(dir)
	index = bit.bor(bit.band(index, 6), 1)
	return core.item_place(itemstack, placer, pointed_thing, index)
end

local function is_pillar(x, y, z, param2)
	MUTABLE_POS.x = x
	MUTABLE_POS.y = y
	MUTABLE_POS.z = z
	local node = core.get_node(MUTABLE_POS)
	return node.param2 == param2 and core.get_item_group(node.name, "thin_pillar") == 1
end

local function update_thin_pillar(x, y, z)
	PILLAR_POS.x = x
	PILLAR_POS.y = y
	PILLAR_POS.z = z
	
	local node = core.get_node(PILLAR_POS)
	
	if core.get_item_group(node.name, "thin_pillar") ~= 1 then return end
	
	local bottom = false
	local top = false
	
	if node.param2 == 12 then
		bottom = is_pillar(x - 1, y, z, node.param2)
		top = is_pillar(x + 1, y, z, node.param2)
	elseif node.param2 == 4 then
		bottom = is_pillar(x, y, z - 1, node.param2)
		top = is_pillar(x, y, z + 1, node.param2)
	else
		bottom = is_pillar(x, y - 1, z, node.param2)
		top = is_pillar(x, y + 1, z, node.param2)
	end
	
	local name = string.sub(node.name, 1, string.find(node.name, "_thin_pillar", 1, true) + 11)

	if bottom and top then
		name = name .. "_middle"
	elseif bottom and not top then
		name = name .. "_top"
	elseif not bottom and top then
		name = name .. "_bottom"
	else
		name = name .. "_small"
	end
	
	if name ~= node.name then
		node.name = name
		core.set_node(PILLAR_POS, node)
	end
end

local function place_thin_pillar(itemstack, placer, pointed_thing)
	local under = pointed_thing.under
	local above = pointed_thing.above
	
	local dx = above.x - under.x
	local dz = above.z - under.z
	
	local node_name = itemstack:get_name()
	local bottom = false
	local top = false
	local param2 = 0
	
	if dx ~= 0 then
		param2 = 12
		bottom = is_pillar(under.x - 1, under.y, under.z, param2)
		top = is_pillar(under.x + 1, under.y, under.z, param2)
	elseif dz ~= 0 then
		param2 = 4
		bottom = is_pillar(under.x, under.y, under.z - 1, param2)
		top = is_pillar(under.x, under.y, under.z + 1, param2)
	else
		bottom = is_pillar(under.x, under.y - 1, under.z, param2)
		top = is_pillar(under.x, under.y + 1, under.z, param2)
	end
	
	local place_name = node_name.sub(node_name, 1, string.find(node_name, "_thin_pillar", 1, true) + 11)

	if bottom and top then
		place_name = place_name .. "_middle"
	elseif bottom and not top then
		place_name = place_name .. "_top"
	elseif not bottom and top then
		place_name = place_name .. "_bottom"
	else
		place_name = place_name .. "_small"
	end

	itemstack:set_name(place_name)
	local result = core.item_place_node(itemstack, placer, pointed_thing, param2)
	itemstack:set_name(node_name)
	
	update_thin_pillar(above.x, above.y, above.z)
	
	if dx ~= 0 then
		update_thin_pillar(above.x - 1, above.y, above.z)
		update_thin_pillar(above.x + 1, above.y, above.z)
	elseif dz ~= 0 then
		update_thin_pillar(above.x, above.y, above.z - 1)
		update_thin_pillar(above.x, above.y, above.z + 1)
	else
		update_thin_pillar(above.x, above.y - 1, above.z)
		update_thin_pillar(above.x, above.y + 1, above.z)
	end
	
	return result
end

local function after_break_thin_pillar(pos, oldnode, oldmetadata, digger)
	if oldnode.param2 == 12 then
		update_thin_pillar(pos.x - 1, pos.y, pos.z)
		update_thin_pillar(pos.x + 1, pos.y, pos.z)
	elseif oldnode.param2 == 4 then
		update_thin_pillar(pos.x, pos.y, pos.z - 1)
		update_thin_pillar(pos.x, pos.y, pos.z + 1)
	else
		update_thin_pillar(pos.x, pos.y - 1, pos.z)
		update_thin_pillar(pos.x, pos.y + 1, pos.z)
	end
end

--
--node_shapes.register_pillar = function (node_name, overrides)
--	local def = table.copy(core.registered_nodes[node_name])
--	apply_overrides(def, overrides)
--	if not def.groups then def.groups = {} end
--	def.groups.pillar = 1
--
--	def.description = def.description .. " [" .. DESC_PILLAR .. "]"
--	def.paramtype2 = "wallmounted"
--	def.on_place = place_pillar
--
--	core.register_node(node_name .. "_pillar", def)
--end
--
--node_shapes.register_thin_pillar = function(node_name, overrides)
--	local def = table.copy(core.registered_nodes[node_name])
--	local tex_pref = string.gsub(node_name, ":", "_") .. "_pillar"
--
--	apply_overrides(def, overrides)
--	if not def.groups then def.groups = {} end
--	def.groups.thin_pillar = 1
--	
--	def.description = def.description .. " [" .. DESC_THIN_PILLAR .. "]"
--	def.paramtype2 = "facedir"
--	def.paramtype = "light"
--	def.drawtype = "mesh"
--	
--	def.on_place = place_thin_pillar
--	def.after_dig_node = after_break_thin_pillar
--	
--	local pillar = node_name .. "_thin_pillar"
--	def.drop = pillar
--	
--	def.mesh = "node_shapes_thin_pillar_small.obj"
--	def.tiles = {tex_pref .. "_ends.png", tex_pref .. "_top.png"}
--	def.selection_box = PILLAR_BOX_SMALL
--	def.collision_box = PILLAR_BOX_SMALL
--	core.register_node(pillar, def)
--	
--	def = table.copy(def)
--	def.groups.not_in_creative_inventory = 1
--	def.selection_box = PILLAR_BOX_BOTTOM
--	def.collision_box = PILLAR_BOX_BOTTOM
--	def.mesh = "node_shapes_thin_pillar_bottom.obj"
--	def.tiles = {tex_pref .. "_ends.png", tex_pref .. "_top.png", tex_pref .. "_middle.png"}
--	core.register_node(pillar .. "_bottom", def)
--	
--	def = table.copy(def)
--	def.mesh = "node_shapes_thin_pillar_top.obj"
--	def.selection_box = PILLAR_BOX_TOP
--	def.collision_box = PILLAR_BOX_TOP
--	core.register_node(pillar .. "_top", def)
--	
--	def = table.copy(def)
--	def.selection_box = PILLAR_BOX_MIDDLE
--	def.collision_box = PILLAR_BOX_MIDDLE
--	def.mesh = "node_shapes_thin_pillar_middle.obj"
--	def.tiles = {tex_pref .. "_middle.png"}
--	core.register_node(pillar .. "_middle", def)
--end
--
--node_shapes.register_variants = function(node_name)
--	node_shapes.register_slab(node_name)
--	node_shapes.register_stairs(node_name)
--	local prefix = string.gsub(node_name, ":", "_")
--	local side = prefix .. "_pillar_side.png"
--	local top = prefix .. "_pillar_top.png"
--	node_shapes.register_pillar(node_name, {
--		tiles = {top, top, side}
--	})
--	node_shapes.register_thin_pillar(node_name, {
--		tiles = {top, top, side}
--	})
--end

-- local DESC_SLAB = translate("Slab")
-- local DESC_STAIRS = translate("Stairs")
-- local DESC_PILLAR = translate("Pillar")
-- local DESC_THIN_PILLAR = translate("Thin Pillar")

local SHAPES = {
	{
		name_suffix = "_slab",
		description_suffix = " [" .. translate("Slab") .. "]",
		definition = {
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = { -0.5, -0.5, -0.5, 0.5, 0.0, 0.5 }
			},
			paramtype2 = "wallmounted",
			paramtype = "light",
			on_place = place_slab,
			groups = { slab = 1 }
		}
	},
	{
		name_suffix = "_panel",
		description_suffix = " [" .. translate("Panel") .. "]",
		definition = {
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
			},
			paramtype2 = "wallmounted",
			paramtype = "light",
			on_place = place_slab,
			groups = { slab = 1 }
		}
	},
	{
		name_suffix = "_stairs",
		description_suffix = " [" .. translate("Stairs") .. "]",
		definition = {
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
					{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5}
				}
			},
			paramtype2 = "facedir",
			paramtype = "light",
			on_place = place_stairs,
			groups = { stairs = 1 }
		}
	},
	{
		name_suffix = "_pillar",
		description_suffix = " [" .. translate("Pillar") .. "]",
		definition = {
			paramtype2 = "wallmounted",
			on_place = place_pillar,
			groups = { pillar = 1, solid = 1 }
		}
	},
	{
		name_suffix = "_thin_pillar_small",
		description_suffix = " [" .. translate("Thin Pillar") .. "]",
		definition = {
			drawtype = "mesh",
			mesh = "th_node_shapes_thin_pillar_small.obj",
			paramtype2 = "facedir",
			paramtype = "light",
			on_place = place_thin_pillar,
			after_dig_node = after_break_thin_pillar,
			groups = { thin_pillar = 1 },
			selection_box = PILLAR_BOX_SMALL,
			collision_box = PILLAR_BOX_SMALL
		}
	},
	{
		name_suffix = "_thin_pillar_bottom",
		description_suffix = " [" .. translate("Thin Pillar") .. "]",
		drop = "_thin_pillar_small",
		definition = {
			drawtype = "mesh",
			mesh = "th_node_shapes_thin_pillar_bottom.obj",
			paramtype2 = "facedir",
			paramtype = "light",
			on_place = place_thin_pillar,
			after_dig_node = after_break_thin_pillar,
			groups = { thin_pillar = 1, not_in_creative_inventory = 1 },
			selection_box = PILLAR_BOX_BOTTOM,
			collision_box = PILLAR_BOX_BOTTOM
		}
	},
	{
		name_suffix = "_thin_pillar_middle",
		description_suffix = " [" .. translate("Thin Pillar") .. "]",
		drop = "_thin_pillar_small",
		definition = {
			drawtype = "mesh",
			mesh = "th_node_shapes_thin_pillar_middle.obj",
			paramtype2 = "facedir",
			paramtype = "light",
			on_place = place_thin_pillar,
			after_dig_node = after_break_thin_pillar,
			groups = { thin_pillar = 1, not_in_creative_inventory = 1 },
			selection_box = PILLAR_BOX_MIDDLE,
			collision_box = PILLAR_BOX_MIDDLE
		}
	},
	{
		name_suffix = "_thin_pillar_top",
		description_suffix = " [" .. translate("Thin Pillar") .. "]",
		drop = "_thin_pillar_small",
		definition = {
			drawtype = "mesh",
			mesh = "th_node_shapes_thin_pillar_top.obj",
			paramtype2 = "facedir",
			paramtype = "light",
			on_place = place_thin_pillar,
			after_dig_node = after_break_thin_pillar,
			groups = { thin_pillar = 1, not_in_creative_inventory = 1 },
			selection_box = PILLAR_BOX_TOP,
			collision_box = PILLAR_BOX_TOP
		}
	}
}

local function fix_tile_def(tiles)
	for index, tile in ipairs(tiles) do
		if type(tile) == "table" then
			tile.align_style = "world"
		else
			core.chat_send_all(tile)
			tiles[index] = { name = tile, backface_culling = false, align_style = "world" }
		end
	end
end

NODE_SHAPES.PROTECTED.register_nodes = function(source_node, shape_list)
	local src_def = core.registered_nodes[source_node]
	local node_list = {}
	table.insert(node_list, source_node)

	for _, shape in ipairs(SHAPES) do
		local node_name = source_node .. shape.name_suffix
		local node_def = table.copy(src_def)
		table.merge_into(node_def, shape.definition)
		fix_tile_def(node_def.tiles)

		node_def.description = node_def.description .. shape.description_suffix
		if shape.drop then
			node_def.drop = source_node .. shape.drop
		end

		core.register_node(":" .. node_name, node_def)
		
		if not node_def.groups or not node_def.groups.not_in_creative_inventory then
			table.insert(node_list, node_name)
		end
	end

	return node_list
end
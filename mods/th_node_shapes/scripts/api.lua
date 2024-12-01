local make_formscpec = NodeShapes.protected.make_formscpec
local show_formspec = NodeShapes.protected.show_formspec
local register_nodes = NodeShapes.protected.register_nodes

local SUFFIX = "\n" .. core.colorize("#00FF33", NodeShapes.protected.translate("Press Aux1 to change shape"))
local FORMSPEC_DATA = {}

--- Register a set of shapes for the node with radial meny to select them.
---@param source_node string Source node ID to copy parameters from.
---@param shapes table Shapes list where each shape is in format `{type: string, overrides: table (not required)}`.
---
--- **Available shape types:**
--- - "slab" - half cube node, can be placed on all 6 sides
--- - "panel" - quart cube node, can be placed on all 6 sides
--- - "stairs" - 2 connected cuboids node, can be placed on all 6 sides
--- - "pillar" - full cube node with rotations
--- - "thin_pillar" - thin decorative cube node with rotations
--- - "post" - thin cube node with rotations
--- - "wall" - thin cube node with connection to neigbours or solids
--- - "fence_flat" - very thin cube node with flat connection to neigbours or solids
--- - "fence_decorative" - very thin cube node with two small connection to neigbours or solids
--- - "frame" - square frame with borders to other nodes, has 3 directions
NodeShapes.register_shapes_set = function(source_node, shapes)
	local node_list = register_nodes(source_node, shapes)
	for _, node_name in ipairs(node_list) do
		FORMSPEC_DATA[node_name] = {
			node_list = node_list,
			formspec = make_formscpec(node_name, node_list)
		}
		local description = minetest.registered_items[node_name].description
		core.override_item(node_name, {
			description = description .. SUFFIX
		})
	end
end

-- Register a pre-defined set of shapes for the stone-like node with radial meny to select them.
---@param source_node string Source node ID to copy parameters from.
NodeShapes.register_stone_set = function(source_node)
	NodeShapes.register_shapes_set(source_node, {
		{ type = "slab" },
		{ type = "panel" },
		{ type = "stairs" },
		{ type = "pillar" },
		{ type = "thin_pillar" },
		{ type = "post" },
		{ type = "wall" },
		{ type = "fence_flat" },
		{ type = "frame" }
	})
end

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local controls = player:get_player_control()
		if controls.aux1 then
			local data = FORMSPEC_DATA[player:get_wielded_item():get_name()]
			if data then
				show_formspec(player, data.node_list, data.formspec)
			end
		end
	end
end)
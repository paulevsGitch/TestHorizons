local make_formscpec = NODE_SHAPES.PROTECTED.make_formscpec
local show_formspec = NODE_SHAPES.PROTECTED.show_formspec
local register_nodes = NODE_SHAPES.PROTECTED.register_nodes

-- Register a set of shapes for node with radial meny to select them
NODE_SHAPES.register_shapes_set = function(source_node)
	local node_list = register_nodes(source_node)
	for _, node_name in ipairs(node_list) do
		local formspec = make_formscpec(node_name, node_list)
		core.override_item(node_name, {
			on_use = function(stack, player, pointed_thing)
				show_formspec(player, node_list, formspec)
			end
		})
	end
end
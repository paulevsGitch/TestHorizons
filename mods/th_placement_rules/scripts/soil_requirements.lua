PlacementRules.sand_requirement = function (itemstack, placer, pointed_thing)
    local node = core.get_node(pointed_thing.under)
	if core.get_node_group(node.name, "soil") == 1 then
		return core.item_place(itemstack, placer, pointed_thing)
	end
end
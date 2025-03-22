PlacementRules = {}

--- A node with this rule can only be placed on soil of quality 1 or above.
--- Function is named after sand as an example of quality 1 soil.
PlacementRules.sand_requirement = function (itemstack, placer, pointed_thing)
	local node = core.get_node(pointed_thing.under)
	if core.get_node_group(node.name, "soil") >= 1 then
		return core.item_place(itemstack, placer, pointed_thing)
	end
end

--- A node with this rule can only be placed on soil of quality 2 or above.
--- Function is named after dirt as an example of quality 2 soil.
PlacementRules.dirt_requirement = function (itemstack, placer, pointed_thing)
	local node = core.get_node(pointed_thing.under)
	if core.get_node_group(node.name, "soil") >= 2 then
		return core.item_place(itemstack, placer, pointed_thing)
	end
end

--- A node with this rule can only be placed on soil of quality 3 or above.
--- Function is named after farmland as an example of quality 3 soil.
PlacementRules.farmland_requirement = function (itemstack, placer, pointed_thing)
	local node = core.get_node(pointed_thing.under)
	if core.get_node_group(node.name, "soil") >= 3 then
		return core.item_place(itemstack, placer, pointed_thing)
	end
end

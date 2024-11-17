local ITEM_ENTITY_NAME = "__builtin:item"
local PICKUP_SOUND = { name = "item_pickup" }
local OVERRIDES = { stack_max = 64 }
local ITEM_CHECK_STEP = 0.2
local step_time = 0.0

local ITEM_ENTITY = core.registered_entities[ITEM_ENTITY_NAME]

ITEM_ENTITY.initial_properties.visual_size.x = 0.25
ITEM_ENTITY.initial_properties.visual_size.y = 0.25
ITEM_ENTITY.initial_properties.pointable = false
ITEM_ENTITY.try_merge_with = function(self, own_stack, object, entity) end

local set_item = ITEM_ENTITY.set_item

ITEM_ENTITY.set_item = function(self, item)
	set_item(self, item)
	self.object:set_properties({
		visual_size = {
			x = 0.25 + math.random() * 0.001,
			y = 0.25 + math.random() * 0.001
		}
	})
end

core.register_entity(":" .. ITEM_ENTITY_NAME, ITEM_ENTITY)

core.handle_node_drops = function(pos, drops, digger)
	for _, item in ipairs(drops) do
		local entity = core.add_entity(pos, ITEM_ENTITY_NAME)
		entity:get_luaentity():set_item(item)
		entity:get_luaentity()._naturally_spawned = true

		local velocity = entity:get_velocity()
		velocity.x = math.random() * 2.0 - 1.0
		velocity.z = math.random() * 2.0 - 1.0
		entity:set_velocity(velocity)
	end
end

local function collect_items(player)
	local objects = core.get_objects_inside_radius(player:get_pos(), 2.0)

	if #objects < 2 then
		return
	end

	local inventory = player:get_inventory()

	for _, obj in pairs(objects) do
		local entity = obj:get_luaentity()
		if entity and entity.name == ITEM_ENTITY_NAME and (entity.age > 2 or entity._naturally_spawned) then
			local itemstring = entity.itemstring
			if itemstring and itemstring ~= "" then
				local stack = ItemStack(itemstring)
				local name = stack:get_name()
				local count = stack:get_count()
				stack = inventory:add_item("main", stack)
				
				if count ~= stack:get_count() then
					local item_effect = core.add_entity(obj:get_pos(), "th_items:item_effect")
					local luaentity = item_effect:get_luaentity()
					luaentity:set_item(name)

					local entity_pos = obj:get_pos()
					local player_pos = player:get_pos()

					local dx = player_pos.x - entity_pos.x
					local dy = player_pos.y - entity_pos.y + 1.25
					local dz = player_pos.z - entity_pos.z
					local dist = dx * dx + dy * dy + dz * dz
					if dist > 0 then
						dist = math.sqrt(dist) / 20
						dx = dx / dist
						dy = dy / dist
						dz = dz / dist
					end
					item_effect:set_velocity(vector.new(dx, dy, dz))

					dx = math.abs(dx)
					dy = math.abs(dy)
					dz = math.abs(dz)

					local max = dx
					max = math.max(max, dy)
					max = math.max(max, dz)

					local max_age = 10
					if max == dx then
						max_age = math.abs(player_pos.x - entity_pos.x) / dx
					elseif max == dy then
						max_age = math.abs(player_pos.y - entity_pos.y) / dy
					else
						max_age = math.abs(player_pos.z - entity_pos.z) / dz
					end

					luaentity:set_data(max_age, player:get_player_name())

					if stack:is_empty() then
						obj:remove()
					else
						entity:set_item(stack)
					end
				end
			end
		end
	end
end

core.register_globalstep(function(dtime)
	step_time = step_time + dtime

	if step_time < ITEM_CHECK_STEP then
		return
	end

	step_time = step_time - ITEM_CHECK_STEP
	local players = core.get_connected_players()
	for _, player in pairs(players) do
		collect_items(player)
	end
end)

core.register_on_mods_loaded(function()
	for name, item in pairs(core.registered_items) do
		if item.stack_max and item.stack_max > 64 then
			core.override_item(name, OVERRIDES)
		end
	end
end)

core.register_entity("th_items:item_effect", {
	initial_properties = {
        hp_max = 1,
		physical = false,
		collide_with_objects = false,
		visual = "wielditem",
		visual_size = ITEM_ENTITY.initial_properties.visual_size,
		textures = {""},
		is_visible = false
    },
	max_age = 10,
	age = 0.0,
	player_name = "",
	set_item = ITEM_ENTITY.set_item,
	set_data = function(self, max_age, player_name)
		self.max_age = max_age
		self.player_name = player_name
	end,
	on_step = function(self, dtime, moveresult)
		self.age = self.age + dtime
		if self.age >= self.max_age then
			self.itemstring = ""
			self.object:remove()
			core.sound_play(PICKUP_SOUND, {to_player = self.player_name}, true)
		end
	end
})
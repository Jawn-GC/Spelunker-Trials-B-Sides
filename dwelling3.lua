local dwelling3 = {
    identifier = "Dwelling-3",
    title = "Dwelling-3: Side Quest",
    theme = THEME.DWELLING,
    width = 4,
    height = 4,
    file_name = "Dwelling-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible thorn vine
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible wood floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snake to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)

	local quillback
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		quillback = entity
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
		entity.flags = clr_flag(entity.flags, 17)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_CAVEMAN_BOSS)

	--Spike Shoes
	define_tile_code("anti_thorn_technology")
	local springs
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_PICKUP_SPIKESHOES, x, y, layer, 0, 0)		
		 springs = get_entity(block_id)
		 return true
	end, "anti_thorn_technology")

	local frames = 0
	local dropped = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if quillback.velocityy < -0.18 and dropped == false then
			dropped = true
		elseif dropped == false then
			quillback.walk_pause_timer = 10
		end
    end, ON.FRAME)
	
	toast(dwelling3.title)
end

dwelling3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return dwelling3
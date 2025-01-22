local dwelling2 = {
    identifier = "Dwelling-2",
    title = "Dwelling-2: Low Roller",
    theme = THEME.DWELLING,
    width = 6,
    height = 4,
    file_name = "Dwelling-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	-- level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		-- entity:destroy()
	-- end, SPAWN_TYPE.ANY, 0, ENT_TYPE.DECORATION_HANGING_HIDE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible wood floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible thorn vine
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)
	
	local lizard
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Horned Lizard to stand on thorns
		lizard = entity
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HORNEDLIZARD)

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()

		if frames == 0 then
			lizard.flags = set_flag(lizard.flags, 6)
			lizard.flags = clr_flag(lizard.flags, 12)
		end

		frames = frames + 1
    end, ON.FRAME)
	
	toast(dwelling2.title)
	
end

dwelling2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return dwelling2

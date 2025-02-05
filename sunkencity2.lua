local sunkencity2 = {
    identifier = "Sunken City-2",
    title = "Sunken City-2: Royalty",
    theme = THEME.EGGPLANT_WORLD,
    width = 4,
    height = 6,
    file_name = "Sunken City-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

sunkencity2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_NUGGET_SMALL)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_SUNKEN)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible wood floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_PAGODA)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible thorn vine
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Jumpdog to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_JUMPDOG)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Minister to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_EGGPLANT_MINISTER)
	
	local switch
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		switch = entity
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SLIDINGWALL_SWITCH)
	
	local wall
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		wall = entity
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_SLIDINGWALL_CEILING)
	
	local frames = 0
	switch_on = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		
		if switch_on == false and switch.timer == 90 then
			switch_on = true
			wall.state = 1
		elseif switch_on == true and switch.timer == 90 then
			switch_on = false
			wall.state = 0
		end
		
		frames = frames + 1
    end, ON.FRAME)	
	
	toast(sunkencity2.title)
end

sunkencity2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return sunkencity2
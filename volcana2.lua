local volcana2 = {
    identifier = "Volcana-2",
    title = "Volcana-2: K-9 Unit",
    theme = THEME.VOLCANA,
    width = 5,
    height = 6,
    file_name = "Volcana-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

volcana2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Magmamen.
        local x, y, layer = get_position(entity.uid)
        local lavas = get_entities_at(0, MASK.LAVA, x, y, layer, 1)
        if #lavas > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MAGMAMAN)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Firebugs.
        local x, y, layer = get_position(entity.uid)
        local chains = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #chains > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_FIREBUG)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_VLAD)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM)

	local rockdog 
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        --Tame Rockdog
		--Set its health to one
		rockdog = entity
        entity:tame(true)
		entity.health = 1
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MOUNT_ROCKDOG)

	--Thorns
	local thorns = {}
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible thorn vine
		entity.flags = set_flag(entity.flags, 6)
		thorns[#thorns + 1] = get_entity(entity.uid)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		for i = 1,#thorns do
			if rockdog.standing_on_uid == thorns[i].uid then
				kill_entity(rockdog.uid, false)
			end
		end
	
        frames = frames + 1
    end, ON.FRAME)
	
	toast(volcana2.title)
end

volcana2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return volcana2
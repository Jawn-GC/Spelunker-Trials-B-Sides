local tidepool2 = {
    identifier = "Tidepool-2",
    title = "Tidepool-2: Betrayal",
    theme = THEME.TIDE_POOL,
    width = 6,
    height = 5,
    file_name = "Tidepool-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

tidepool2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible Pagoda floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_PAGODA)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        --Tame Axolotl
		--Set its health to one
        entity:tame(true)
		entity.health = 1
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MOUNT_AXOLOTL)

	local octo
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        octo = entity
		octo.health = 1
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_OCTOPUS)

	local keg
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        keg = entity
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ACTIVEFLOOR_POWDERKEG)

	local switch
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		switch = entity
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SLIDINGWALL_SWITCH)

	--Sliding Wall
	define_tile_code("wall")
	local wall
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity(ENT_TYPE.FLOOR_SLIDINGWALL_CEILING, x, y, layer, 0, 0)		
		wall = get_entity(block_id)
		wall.state = 1
		return true
	end, "wall")

	--Axo Traitor
	define_tile_code("traitor")
	local traitor
	local axo_x
	local axo_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity(ENT_TYPE.MOUNT_AXOLOTL, x, y, layer, 0, 0)		
		traitor = get_entity(block_id)
		traitor.health = 1
		traitor.flags = set_flag(traitor.flags, ENT_FLAG.FACING_LEFT)
		axo_x = x
		axo_y = y
		return true
	end, "traitor")

	local frames = 0
	local switch_on = false
	local traitor_tamed = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		
		if frames == 1 then
			traitor:tame(false)		
		end

		if switch_on == false and switch.timer == 90 then
			switch_on = true
			wall.state = 0
		elseif switch_on == true and switch.timer == 90 then
			switch_on = false
			wall.state = 1
		end
		
		if test_flag(octo.flags, ENT_FLAG.DEAD) ~= true then
			octo:light_on_fire(10)
		end
		
		--temporary code because new patch broke collision between the octopy and keg (?)
		if test_flag(octo.flags, ENT_FLAG.DEAD) ~= true and octo.x > 29.5 and octo.x < 30.5 and octo.y > 114.29 and octo.y < 114.3 and test_flag(keg.flags, ENT_FLAG.DEAD) ~= true then
			keg:kill(false, octo)
		end
		
		if #players ~= 0 and test_flag(traitor.flags, ENT_FLAG.DEAD) ~= true then
			if traitor.rider_uid == players[1].uid and traitor_tamed == false then
				traitor:tame(true)
				traitor_tamed = true
			end
		end

		frames = frames + 1
    end, ON.FRAME)
	
	toast(tidepool2.title)
end

tidepool2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return tidepool2
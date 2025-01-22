local ending = {
    identifier = "Ending",
    title = "Ending",
    theme = THEME.CITY_OF_GOLD,
    width = 4,
    height = 4,
    file_name = "CoG.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

ending.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	--Rubies
	define_tile_code("rooby")
	set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_RUBY, x, y, layer, 0, 0)
		return true
	end, "rooby")

	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()

    end, ON.FRAME)
	
	toast("Congratulations!")
end

ending.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return ending
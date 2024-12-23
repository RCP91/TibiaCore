function onLogin(player)
	if player:getLastLoginSaved() <= 0 then
		-- Items
		if player:getSex() == PLAYERSEX_FEMALE then
			player:addItem(3562, 1, true, -1, CONST_SLOT_ARMOR)
		else
			player:addItem(3561, 1, true, -1, CONST_SLOT_ARMOR)
		end
		--player:addItem(3559, 1, true, -1, CONST_SLOT_LEGS) -- leather legs
		player:addItem(3270, 1, true, -1, CONST_SLOT_LEFT)   -- club
		--player:addItem(3412, 1, true, -1, CONST_SLOT_RIGHT) -- wooden shield
		player:addItem(2920, 1, true, -1, CONST_SLOT_AMMO) -- torch
		
		local container = Game.createItem(2853, 1) -- bag
		container:addItem(3585, 3) -- apple
		--container:addItem(3298, 5) -- throwing knife
		
		player:addItemEx(container, true, CONST_SLOT_BACKPACK)
	
		-- Default Outfit
		if player:getSex() == PLAYERSEX_FEMALE then
			player:setOutfit({lookType = 136, lookHead = 78, lookBody = 106, lookLegs = 58, lookFeet = 95})
		else
			player:setOutfit({lookType = 128, lookHead = 78, lookBody = 106, lookLegs = 58, lookFeet = 95})
		end
		
		local town = Town("Rookgaard")
		player:teleportTo(town:getTemplePosition())
		player:setTown(town)
		player:setDirection(DIRECTION_SOUTH)
	end
	return true
end

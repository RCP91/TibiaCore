function onStepIn(creature, item, position, fromPosition)
	doRelocate(item:getPosition(),{x = 33021, y = 32605, z = 07})
	Game.sendMagicEffect(item:getPosition(), 11)
	Game.sendMagicEffect({x = 33021, y = 32605, z = 07}, 15)
end

function onAddItem(item, tileitem, position)
	doRelocate(item:getPosition(),{x = 33021, y = 32605, z = 07})
	Game.sendMagicEffect(tileitem:getPosition(), 11)
	Game.sendMagicEffect({x = 33021, y = 32605, z = 07}, 15)
end
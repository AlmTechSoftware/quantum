--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Inventory = {} 

Quantum.Inventory.Size = Quantum.Inventory.Width * Quantum.Inventory.Height

function Quantum.Server.Inventory.Create( char )
	char.inventory = {}
	char.equiped = {
		[Quantum.EquipSlots.Head] = -1, -- -1 means that it is empty
		[Quantum.EquipSlots.Chest] = -1,
		[Quantum.EquipSlots.Legs] = -1,
		[Quantum.EquipSlots.Boots] = -1,
		[Quantum.EquipSlots.Weapon] = -1
	}
	char.effects = {}

	return char.inventory
end

local function isEquippable( item )
	return item.equipslot != nil 
end

local function isStackable( item )
	return item.stack || false
end

function Quantum.Server.Inventory.SetEquipSlotItem( pl, slot, itemindex )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl )
	local slotitem = Quantum.Server.Inventory.GetSlotItem( char, index ) 
	local itemTbl = Quantum.Item.Get( slotitem[1] )

	local equipslot = itemTbl.equipslot

	if( equipslot == nil ) then 
		Quantum.Error( tostring(pl) .. " tried to equip an non-equipable item (" .. tostring(itemTbl[1]) .. ")" )
		return 
	else
		Quantum.Debug( "Commin' soon." )
		-- add effects here and equip it to the slot but check before
	end
end

function Quantum.Server.Inventory.SetSlotItem( pl, char, pos, itemid, amount ) 
	local setItemTbl = {}
	if( amount < 1 ) then 
		setItemTbl = nil 
	else
		local item = Quantum.Item.Get( itemid )
		if( isEquippable( item ) || !isStackable( item ) ) then 
			amount = nil
			setItemTbl = { itemid }
		else
			amount = amount || 1
			setItemTbl = { itemid, amount } 
		end
	end
	
	char.inventory[pos] = setItemTbl -- remove the item
	-- Sent the new data to the client
	Quantum.Net.Inventory.SetItem( pl, pos, itemid, amount )
end

function Quantum.Server.Inventory.GetSlotItem( char, pos ) return char.inventory[pos] end

function Quantum.Server.Inventory.FindStackable( char, item )
	if( item.stack ) then
		local inv = Quantum.Server.Char.GetInventory( char ) 
		for i, item2 in pairs( inv ) do
			if( item2[1] == item.id && item2[2] < item.stack ) then -- if the item is stackable and it is the same item
				return i -- return its index
			end
		end
	else
		return
	end
end

function Quantum.Server.Inventory.FindItemSpot( char )
	local inv = Quantum.Server.Char.GetInventory( char )
	local pos = 0

	local item
	for ii = 1, Quantum.Inventory.Width * Quantum.Inventory.Height, 1 do 
		item = inv[ii]
		if( item == nil ) then 
			pos = ii
			break
		end
	end
	return pos
end

local function getStackSize( char, item )
	return item.stack || 1
end

local function sortItem( pl, char, itemid, amount )

	Quantum.Debug( "--Stacking Debug--" )

	local item = Quantum.Item.Get( itemid )
	local slotitem = Quantum.Server.Inventory.GetSlotItem( char, index ) 
	local inv = Quantum.Server.Char.GetInventory( char )

	local stacksize = getStackSize( char, item )

	local index = Quantum.Server.Inventory.FindStackable( char, item ) || #inv + 1

	local rest = amount
	if( slotitem != nil ) then rest = rest + slotitem[2] end

	local count = 0

	local itemInSlot = Quantum.Server.Inventory.GetSlotItem( char, index )

	if( itemInSlot != nil ) then
		if( itemInSlot[1] == itemid && itemInSlot[2] < stacksize ) then

			local add = itemInSlot[2] + amount
			if( add > stacksize ) then
				rest = rest - ( stacksize - itemInSlot[2] )
			else
				rest = rest - amount
			end
			local setAmt = math.Clamp( add, 1, stacksize )
			Quantum.Server.Inventory.SetSlotItem( pl, char, index, itemid, setAmt )

			print( "1", itemid, setAmt, rest, index )

		end
	else
		local setAmt = math.Clamp( amount, 1, stacksize )
		local pos = Quantum.Server.Inventory.FindItemSpot( char )
		rest = rest - setAmt
		Quantum.Server.Inventory.SetSlotItem( pl, char, pos, itemid, setAmt )

		print( "2", itemid, setAmt, rest, pos )
	end

	while( rest >= stacksize ) do
		count = count + 1
		
		if( count == 1 ) then
			local setAmt = math.Clamp( amount, 1, stacksize )

			if( itemInSlot != nil ) then 
				setAmt = math.Clamp( itemInSlot[2] + amount, 1, stacksize )
			end

			rest = rest - setAmt

			local pos = Quantum.Server.Inventory.FindItemSpot( char )
			Quantum.Server.Inventory.SetSlotItem( pl, char, pos, itemid, setAmt )
			print( "3", itemid, setAmt, rest, pos )
		else
			index = index + 1
			itemInSlot = Quantum.Server.Inventory.GetSlotItem( char, index )

			if( itemInSlot != nil ) then
				if( itemInSlot[1] == itemid && itemInSlot[2] < stacksize ) then
					rest = rest - ( stacksize - itemInSlot[2] )
					Quantum.Server.Inventory.SetSlotItem( pl, char, index, itemid, stacksize )

					print( "4", itemid, stacksize, rest, index )
	
					if( rest <= 0 ) then 
						rest = 0
						break
					end
				end
			else
				rest = rest - stacksize
				Quantum.Server.Inventory.SetSlotItem( pl, char, index, itemid, stacksize )
				print( "5", itemid, stacksize, rest, index )
			end
		end
	end

	local stackIndex = Quantum.Server.Inventory.FindStackable( char, item )
	print( "stackIndex=", stackIndex )
	local pos 
	if( stackIndex == nil ) then
		pos = Quantum.Server.Inventory.FindItemSpot( char )
		Quantum.Server.Inventory.SetSlotItem( pl, char, pos, itemid, rest ) 
		print( "6", itemid, rest, rest, pos )
	else
		if( rest > 0 ) then
			pos = stackIndex
			itemInSlot = Quantum.Server.Inventory.GetSlotItem( char, pos )

			local setAmt = math.Clamp( itemInSlot[2] + rest, 1, stacksize )
			local diff = ( itemInSlot[2] + rest ) - setAmt
			rest = rest - diff

			if( rest <= 0 ) then
				Quantum.Server.Inventory.SetSlotItem( pl, char, pos, itemid, setAmt ) 
				print( "7", itemid, setAmt, rest, pos )
			end
		end
	end
	Quantum.Debug( "--End of Stacking Debug--" )
end

function Quantum.Server.Inventory.GiveItem( pl, itemid, amount ) -- Quantum.Server.Inventory.GiveItem( Entity(1), "test2", 21 )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl ) -- Quantum.Server.Inventory.GiveItem( Entity(1), "test", 1 )
	local inv = Quantum.Server.Char.GetInventory( char )
	local item = Quantum.Item.Get( itemid )

	if( item == nil ) then Quantum.Error( "Tried to give " .. tostring(pl) .. " a non-existent item! Item '" .. tostring(itemid) .. "' does not exist." ) return end

	if( #inv + 1 <= Quantum.Inventory.Size || Quantum.Server.Inventory.FindStackable( char, item ) != nil ) then
		sortItem( pl, char, itemid, amount )
	else
		Quantum.Debug( "Tried to give " .. tostring(pl) ..  " a item but their inventory is full!" )
	end
end

function Quantum.Server.Inventory.DropItem( pl, index, amount ) -- Quantum.Server.Inventory.DropItem( Entity(1), 1, 9 )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl ) -- Quantum.Server.Inventory.DropItem( Entity(1), 4, 1 )
	local inv = Quantum.Server.Char.GetInventory( char )

	if( inv[index] != nil ) then
		local itemid = inv[index][1] 

		local item = Quantum.Item.Get( itemid )

		if( item.soulbound == true ) then 
			Quantum.Notify.Deny( pl, "You can not drop that item!" )
			return 
		end -- players cant drop soulbound items

		local am_diff = inv[index][2] - amount

		if( am_diff >= 0 ) then -- drop the item from the players inv
			-- remove the items am_diff from its stack
			Quantum.Server.Inventory.SetSlotItem( pl, char, index, itemid, am_diff )

			-- spawn the item infront of the player
			Quantum.Server.Item.SpawnItemAtPlayer( pl, itemid, amount ) 
		end
	else
		Quantum.Error( "Player " .. tostring( pl ) .. " tried to drop a something from index=" .. tostring(index) .. " where there exists no item." )
	end
end

function Quantum.Server.Inventory.UseItem( pl, index )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl ) 
	local inv = Quantum.Server.Char.GetInventory( char )

	local item = inv[index]

	if( item != nil || #item > 0 ) then
		local itemTbl = Quantum.Item.Get( item[1] )
		if( itemTbl.usefunction != nil ) then
			Quantum.Server.Inventory.SetSlotItem( pl, char, index, item[1], item[2] - 1 )
			itemTbl.usefunction(pl) -- call the function
		end
	end
end

function Quantum.Server.Inventory.EatItem( pl, index )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl ) 
	local inv = Quantum.Server.Char.GetInventory( char )

	local item = inv[index]

	if( item != nil || #item > 0 ) then
		local itemTbl = Quantum.Item.Get( item[1] )
		if( itemTbl.consumefunction != nil ) then
			Quantum.Server.Inventory.SetSlotItem( pl, char, index, item[1], item[2] - 1 )
			itemTbl.consumefunction( pl ) 
		end
	end
end
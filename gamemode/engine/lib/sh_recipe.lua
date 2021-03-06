--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Recipe = {}

Quantum.Recipes = {}

function Quantum.Recipe.Add( itemid, station, tbl )
	if( Quantum.Item.Get( itemid ) == nil ) then return end

	local returnTbl = {
		name = tbl.name || "Secret Recipe", -- name of the recipe
		station = station, -- where you can craft it ( at what "crafting table" can you make it at )
		creates = itemid, -- what the recipe creates
		delay = tbl.delay || Quantum.MinCraftDelay,
		amount = tbl.amount || 1, -- how much you get from 1 craft
		recipe = tbl.recipe || {}
	}

	Quantum.Recipes[ itemid ] = returnTbl 
	Quantum.Recipes[ itemid ].delay = math.Clamp( Quantum.Recipes[ itemid ].delay, Quantum.MinCraftDelay, Quantum.MaxCraftDelay ) 

	-- add the recipe to the stations recipe list --
	if( station != nil ) then
		if( Quantum.Stations[ returnTbl.station ].recipes == nil ) then
			Quantum.Stations[ returnTbl.station ].recipes = {}
		end
		table.insert( Quantum.Stations[ returnTbl.station ].recipes, itemid )
	else
		if SERVER then
			Quantum.Error( "Recipe '" .. itemid .. "' does not have a station! You will not be able to craft this item!" )
		end
	end

	return returnTbl
end

function Quantum.Recipe.Get( itemid )
	return Quantum.Recipes[itemid]
end	

function Quantum.Recipe.GetAvailableAmountForReq( recipe, pos, inv )
	if( inv != nil ) then
		return Quantum.Server.Inventory.GetItemAmount( nil, recipe[pos].item, inv )
	end
end

function Quantum.Recipe.GetNeededAmountForReq( recipe, pos, inv )
	if( inv != nil ) then
		return Quantum.Recipe.GetAvailableAmountForReq( recipe, pos, inv ) - recipe[pos].amount
	end
end

local function canMakeReq( diff ) return diff >= 0 end

function Quantum.Recipe.CanMake( inv, itemid )
	if( inv != nil && itemid != nil ) then

		local recipeTbl = Quantum.Recipe.Get( itemid )
		local rTbl = recipeTbl.recipe

		local canMake = {}
		local failedReq = {}

		for i, req in pairs( rTbl ) do
			canMake[i] = canMakeReq( Quantum.Recipe.GetNeededAmountForReq( rTbl, i, inv ) )
			if( !canMake[i] ) then
				failedReq[i] = req.item
			end
		end

		return #failedReq <= 0, failedReq

	end
end
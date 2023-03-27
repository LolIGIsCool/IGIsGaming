util.AddNetworkString("Blackmarket_SyncWeapons")
util.AddNetworkString("Blackmarket_BuyWeapons")
util.AddNetworkString("Blackmarket_OpenMenu")
util.AddNetworkString("Blackmarket_ConfigMenu")
util.AddNetworkString("Blackmarket_UpdateConfigMenu")
util.AddNetworkString("Blackmarket_EditLocation")
util.AddNetworkString("Blackmarket_GotoLocation")
util.AddNetworkString("Blackmarket_Toggle")
util.AddNetworkString("Blackmarket_Refresh")

local function createBlackmarket()
	local npc = ents.Create("starwars_blackmarket")
	npc.serverSpawned = true
	npc:Spawn()
	npc:Activate()

	return npc
end

local function spawnNPC()
	SBlackmarket.Config.Enabled = true
	timer.Simple(3, function()
		createBlackmarket()
		timer.Create("Blackmarket_PersistantNPC", SBlackmarket.Config.LocationChangeDelay, 0, function()
			if not IsValid(SBlackmarket.BlackmaketDealer) and SBlackmarket.Config.Locations[0] > 0 then
				createBlackmarket()
			end
		end )
	end)
end

function SBlackmarket.Action.connectDatabase()
	if not file.Exists("blackmarket", "DATA") then
		file.CreateDir( "blackmarket" )
	end

	if file.Exists("blackmarket/blackmarket_locations-" .. game.GetMap() .. ".json", "DATA" ) then
		local tbl = file.Read("blackmarket/blackmarket_locations-" .. game.GetMap() .. ".json", "DATA")
		SBlackmarket.Config.Locations = util.JSONToTable(tbl)
	else
		local newtbl = SBlackmarket.Config.BlackmarketLocations[game.GetMap()]
		if newtbl then
			for k, locations in ipairs(SBlackmarket.Config.BlackmarketLocations[game.GetMap()]) do
				locations.name = ""
				locations.description = ""
			end
			SBlackmarket.Config.BlackmarketLocations[game.GetMap()][0] = #SBlackmarket.Config.BlackmarketLocations[game.GetMap()]
			SBlackmarket.Config.Locations = SBlackmarket.Config.BlackmarketLocations[game.GetMap()]
			file.Write("blackmarket/blackmarket_locations-" .. game.GetMap() .. ".json", util.TableToJSON(SBlackmarket.Config.Locations))
		end
	end
	SBlackmarket.Config.BlackmarketLocations = nil

	if not SBlackmarket.Config.Locations then
		SBlackmarket.Config.Locations = {}
	end
	SBlackmarket.Config.Locations[0] = #SBlackmarket.Config.Locations
	if SBlackmarket.Config.Locations[0] > 0 then
		MsgC("Found " .. SBlackmarket.Config.Locations[0] .. " Blackmarket locations. Spawning NPC")
		spawnNPC()
	else
		MsgC("Found 0 Blackmarket locations.")
		SBlackmarket.Config.Locations = nil
	end
end
hook.Add( "Initialize", "SBlackmarket.Action.connectDatabase", SBlackmarket.Action.connectDatabase)

local function spawn(Player)
	Player.BlackmarketDeployedWeapons = {}
	Player.BlackmarketDeployedKeycards = {}
end
hook.Add( "PlayerSpawn", "setupblackmarkettables1", spawn )
hook.Add( "PlayerInitialSpawn", "setupblackmarkettables2", spawn )

function SBlackmarket.Action.PurchaseWeapon(Player, strWep)
	
	local data = SBlackmarket.Database[strWep]
	if not data then return end

	if data.Cost == 1 and not Player:IsDeveloper() then
		return Player:ChatPrint(data.Name .. "is currently unavailable, please come back later.")
	end

	-- Hideyoshi Keycard Blackmarket
	if (string.match(strWep, "bkeycard") and data.KeycardLevel) then
		if (Player:SH_CanAffordPremium(data.Cost) == false) then
			Player:PrintMessage(HUD_PRINTTALK, "You can't afford this keycard!")

			return
		end
		if Player.BlackmarketDeployedKeycards[data.Name] then
			Player:PrintMessage(HUD_PRINTTALK, "You already have this keycard!")

			return
		end
		hideyoshiKeycards.func:allocateKeycard(Player, {data.KeycardLevel})

		Player:SH_AddPremiumPoints(-data.Cost)
		Player:PrintMessage(HUD_PRINTTALK, "Succesfully purchased " .. data.Name .. " for " .. data.Cost .. " credits!")
		Player:Give(string.Left(strWep, 8))
		Player.BlackmarketDeployedKeycards[data.Name] = true

		return
	elseif (string.match(strWep, "bkeycard") and data.PilotLevel) then
		if (Player:SH_CanAffordPremium(data.Cost) == false) then
			Player:PrintMessage(HUD_PRINTTALK, "You can't afford this licence!")

			return
		end
		if Player.BlackmarketDeployedKeycards[data.Name] then
			Player:PrintMessage(HUD_PRINTTALK, "You already have this keycard!")

			return
		end

		local baseData = {
			steamID = Player:SteamID(),
			PlayerModel = Player:GetModel(),
			Team = Player:Team(),
			PlayerBind = Player:SteamID()
		}

		local id = hideyoshiKeycards.func:assignID(Player, {18})

		hideyoshiKeycards.func:createData({18}, baseData, id)

		net.Start("hideyoshi_update_keycardregistry")
		net.WriteInt(id, 32)
		net.WriteTable(bKeypads_Keycards_Registry[id])
		net.Broadcast()
		hideyoshiKeycards.func:processKeycard(Player, id)
		Player:SetNWString("BlackMarketLicence_" .. id, data.PilotLevel)
		Player:SH_AddPremiumPoints(-data.Cost)
		Player:PrintMessage(HUD_PRINTTALK, "Succesfully purchased " .. data.Name .. " for " .. data.Cost .. " credits!")
		Player:Give(string.Left(strWep, 8))
		Player.BlackmarketDeployedKeycards[data.Name] = true

		return
	end

	-- Hideyoshi Keycard Blackmarket

	for _, wep in ipairs(Player:GetWeapons()) do
		if wep:GetClass() == strWep then
			Player:PrintMessage(HUD_PRINTTALK, "You already own a " .. data.Name .. ", I don't think you need to buy it again!")
			return
		end
	end
	
	if (Player:SH_CanAffordPremium(data.Cost) == false) then
		Player:PrintMessage(HUD_PRINTTALK, "You can't afford this weapon!")
		return
	end
	Player:SH_AddPremiumPoints(-data.Cost)
	Player:PrintMessage(HUD_PRINTTALK, "Succesfully purchased " .. data.Name .. " for " .. data.Cost .. " credits!")
	Player.BlackmarketDeployedWeapons[strWep] = true
	Player:Give(strWep)
end

net.Receive("Blackmarket_BuyWeapons", function(len, Player)
	local weapon = net.ReadString()
	if not weapon then return end
	for k, v in ipairs( ents.FindInSphere(Player:GetPos(),500) ) do
		if v:GetClass() == "starwars_blackmarket" then
			SBlackmarket.Action.PurchaseWeapon(Player, weapon)
			return
		end
	end
end)

concommand.Add("goto_blackmarket",function(ply)
	if not ply:IsAdmin() or not ply:IsDeveloper() then
		return ply:ChatPrint("Permission Denied")
	end
	ulx.fancyLogAdmin( ply, true, "#A teliported to #s", "Starwars Blackmarket" )
	ply.ulx_prevpos = ply:GetPos()
	ply.ulx_prevang = ply:LocalEyeAngles()
	ply:SetPos(SBlackmarket.BlackmaketDealer:GetPos())
end)

net.Receive("Blackmarket_GotoLocation", function(_, ply)
	if not ply:IsDeveloper() then
		return ply:ChatPrint("Permission Denied")
	end
	local idx = net.ReadUInt(8)
	ply.ulx_prevpos = ply:GetPos()
	ply.ulx_prevang = ply:LocalEyeAngles()
	ply:SetPos(SBlackmarket.Config.Locations[idx].pos)
	ply:SetEyeAngles(SBlackmarket.Config.Locations[idx].angle)
end)

net.Receive("Blackmarket_EditLocation", function(_, ply)
	if not ply:IsDeveloper() then
		return ply:ChatPrint("Permission Denied")
	end
	local idx = net.ReadUInt(8)
	local type = net.ReadString()
	local name = net.ReadString()
	local description = net.ReadString()
	local position = net.ReadVector()
	local angle = net.ReadAngle()
	local data = {name = name, description = description, pos = position, angle = angle}
	if type == "add" then
		if not SBlackmarket.Config.Locations then
			SBlackmarket.Config.Locations = {
				[0] = 1,
				[1] = data
			}
		else
			table.insert(SBlackmarket.Config.Locations, data)
			SBlackmarket.Config.Locations[0] = SBlackmarket.Config.Locations[0] + 1
		end
	elseif type == "edit" then
		SBlackmarket.Config.Locations[idx] = data
	elseif type == "delete" then
		table.remove(SBlackmarket.Config.Locations, idx)
		SBlackmarket.Config.Locations[0] = SBlackmarket.Config.Locations[0] - 1
		if SBlackmarket.Config.Locations[0] == 0 then
			timer.Pause("Blackmarket_PersistantNPC")
			SBlackmarket.BlackmaketDealer:Remove()
			SBlackmarket.BlackmaketDealer = nil
		end
	end

	net.Start("Blackmarket_UpdateConfigMenu")
	net.WriteTable(SBlackmarket.Config.Locations)
	net.Send(ply)

	file.Write("blackmarket/blackmarket_locations-" .. game.GetMap() .. ".json", util.TableToJSON(SBlackmarket.Config.Locations))
end)

local function openConfigMenu(ply)
	if not SBlackmarket.Config.Locations then
		return ply:ChatPrint("No locations set on this map. Get started with !bmcreate")
	end
	net.Start("Blackmarket_ConfigMenu")
	net.WriteTable(SBlackmarket.Config.Locations)
	net.WriteBool(SBlackmarket.Config.Enabled or true)
	net.WriteEntity(SBlackmarket.BlackmaketDealer)
	net.Send(ply)
end

concommand.Add("blackmarketmenu",function(ply)
	if not ply:IsDeveloper() then
		return ply:ChatPrint("Permission Denied")
	end
	openConfigMenu(ply)
end)

hook.Add("PlayerSay", "blackmarketconfigmenu", function(ply, text)
	if string.lower(text) == "!blackmarketmenu" then
		if not ply:IsDeveloper() then
			return ply:ChatPrint("Permission Denied")
		end
		openConfigMenu(ply)
	end
end)

function SBlackmarket.Action.ToggleNPC(ply)
	if not ply:IsDeveloper() then
		return ply:ChatPrint("Permission Denied")
	end
	if not SBlackmarket.BlackmaketDealer then return end
	SBlackmarket.Config.Enabled = not SBlackmarket.Config.Enabled
	if SBlackmarket.Config.Enabled then
		timer.UnPause("Blackmarket_PersistantNPC")
		SBlackmarket.BlackmaketDealer:NextThink(CurTime())
		SBlackmarket.BlackmaketDealer:SetNoDraw(false)
	else
		timer.Pause("Blackmarket_PersistantNPC")
		SBlackmarket.BlackmaketDealer:NextThink(CurTime() + 21600)
		SBlackmarket.BlackmaketDealer:SetNoDraw(true)
	end

	RunConsoleCommand("ulx", "asay", ply:Nick(), SBlackmarket.Config.Enabled and "Enabled" or "Disabled", "the", "blackmarket", "dealer")
end

net.Receive("Blackmarket_Toggle", function(_, ply)
	SBlackmarket.Action.ToggleNPC(ply)
end)

function SBlackmarket.Action.RefreshNPC(ply)
	if not ply:IsDeveloper() then
		return ply:ChatPrint("Permission Denied")
	end
	local pos, ang
	if SBlackmarket.BlackmaketDealer then
		pos = SBlackmarket.BlackmaketDealer:GetPos()
		ang = SBlackmarket.BlackmaketDealer:GetAngles()
		SBlackmarket.BlackmaketDealer:Remove()
	end
	local npc = createBlackmarket()
	timer.Simple(0.2, function()
		npc:SetPos(pos or npc:GetPos())
		npc:SetAngles(ang or npc:GetAngles())
	end)
end

net.Receive("Blackmarket_Refresh", function(_, ply)
	SBlackmarket.Action.RefreshNPC(ply)
end)

local function errorMessage(ply)
	ply:ChatPrint(ply:IsDeveloper() and "You cannot edit the blackmarket. Use !blackmarketmenu." or "You cannot edit the blackmarket. Contact a SuperAdmin if there is an issue.")
end

hook.Add( "CanTool", "NoEditingBlackmarket", function( ply, tr )
	if IsValid( tr.Entity ) and tr.Entity:GetClass() == "starwars_blackmarket" then
		errorMessage(ply)
		return false
	end
end)

hook.Add( "CanProperty", "NoEditingBlackmarket", function( ply, _, ent )
	if IsValid( ent ) and ent:GetClass() == "starwars_blackmarket" then
		errorMessage(ply)
		return false
	end
end )

hook.Add( "PhysgunPickup", "NoEditingBlackmarket", function( ply, ent )
	if IsValid( ent ) and ent:GetClass() == "starwars_blackmarket" then
		-- errorMessage(ply)
		return false
	end
end )
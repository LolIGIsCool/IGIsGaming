local easynet = SH_POINTSHOP.easynet

if (!SH_POINTSHOP.CachedPlayerData) then
	SH_POINTSHOP.CurrentItemID = 0
	SH_POINTSHOP.CachedPlayerData = {}
	SH_POINTSHOP.ItemThinkCalls = {}
end

if (SH_POINTSHOP.UseWorkshop) then
	resource.AddWorkshop("1269811783")
	-- resource.AddWorkshop("76561198006360147")
	resource.AddFile("materials/shenesis/pointshop/credits.png")
	resource.AddFile("materials/shenesis/pointshop/scrap.png")
	resource.AddFile("materials/shenesis/pointshop/iglogo.png")
	resource.AddFile("materials/shenesis/pointshop/igquest.png")
	resource.AddFile("materials/shenesis/pointshop/igdonate.png")
else
	resource.AddFile("materials/shenesis/general/back.png")
	resource.AddFile("materials/shenesis/general/checked.png")
	resource.AddFile("materials/shenesis/general/close.png")
	resource.AddFile("materials/shenesis/general/list.png")
	resource.AddFile("materials/shenesis/general/options.png")
	resource.AddFile("materials/shenesis/pointshop/accessory.png")
	resource.AddFile("materials/shenesis/pointshop/checked.png")
	resource.AddFile("materials/shenesis/pointshop/controls.png")
	resource.AddFile("materials/shenesis/pointshop/equipped.png")
	resource.AddFile("materials/shenesis/pointshop/gun.png")
	resource.AddFile("materials/shenesis/pointshop/hat.png")
	resource.AddFile("materials/shenesis/pointshop/manager.png")
	resource.AddFile("materials/shenesis/pointshop/person.png")
	resource.AddFile("materials/shenesis/pointshop/powerup.png")
	resource.AddFile("materials/shenesis/pointshop/premium.png")
	resource.AddFile("materials/shenesis/pointshop/standard.png")
	resource.AddFile("materials/shenesis/pointshop/suitcase.png")
	resource.AddFile("materials/shenesis/pointshop/trail.png")
	resource.AddFile("materials/shenesis/pointshop/transfer.png")
	resource.AddFile("materials/shenesis/pointshop/credits.png")
	resource.AddFile("materials/shenesis/pointshop/scrap.png")
	resource.AddFile("materials/shenesis/pointshop/iglogo.png")
	resource.AddFile("materials/shenesis/pointshop/igquest.png")
	resource.AddFile("materials/shenesis/pointshop/igdonate.png")
	resource.AddFile("resource/fonts/circular.ttf")
	resource.AddFile("resource/fonts/circular_bold.ttf")
end

function SH_POINTSHOP:DatabaseConnected()
	local dm = self.DatabaseMode
	if (dm == "mysqloo") then
		local to_create = {
			sh_pointshop = [[`item_id` int(11) NOT NULL DEFAULT '0']],
			sh_pointshop_player = [[`id` INT NOT NULL AUTO_INCREMENT, `steamid` VARCHAR(45) NOT NULL, `standard_points` INT NOT NULL DEFAULT 0, `premium_points` INT NOT NULL DEFAULT 0, `inventory` TEXT(4096) NOT NULL DEFAULT '', `equipped` TEXT(4096) NOT NULL DEFAULT '', PRIMARY KEY (`id`), UNIQUE INDEX `steamid_UNIQUE` (`steamid` ASC)]],
		}

		self:CreateMultipleTables(to_create, function()
			_SH_QUERY_SILENT = true
				self:BetterQuery([[
					ALTER TABLE `sh_pointshop_player`
					CHANGE COLUMN `inventory` `inventory` MEDIUMTEXT CHARACTER SET 'utf8' NOT NULL ,
					CHANGE COLUMN `equipped` `equipped` MEDIUMTEXT CHARACTER SET 'utf8' NOT NULL ,
					ADD COLUMN `is_uniqueid` ENUM('0', '1') NOT NULL DEFAULT '0' AFTER `equipped`;
				]], {})
			_SH_QUERY_SILENT = false

			self:PostDatabaseConnected()
		end)
	else
		self:TryCreateTable("sh_pointshop", [[`item_id` INTEGER NOT NULL DEFAULT 0]])
		self:TryCreateTable("sh_pointshop_player", [[`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, `steamid` TEXT NOT NULL UNIQUE, `standard_points` INTEGER NOT NULL DEFAULT 0, `premium_points` INTEGER NOT NULL DEFAULT 0, `inventory` TEXT NOT NULL DEFAULT '', `equipped` TEXT NOT NULL DEFAULT '']]) -- 76561198006360147

		_SH_QUERY_SILENT = true
			self:BetterQuery([[ALTER TABLE sh_pointshop_player ADD COLUMN is_uniqueid INTEGER NOT NULL DEFAULT 0]], {})
		_SH_QUERY_SILENT = false

		self:PostDatabaseConnected()
	end
end

function SH_POINTSHOP:PostDatabaseConnected(cb)
	self:DBPrint("Post database actions..")

	self:BetterQuery("SELECT * FROM sh_pointshop", {}, function(q, ok, data)
		if (!ok) then
			return end

		if (data[1]) then
			self.CurrentItemID = tonumber(data[1].item_id)
		else
			self:BetterQuery("INSERT INTO sh_pointshop (item_id) VALUES (0)")
		end
	end)
end

function SH_POINTSHOP:PlayerReady(ply)
	ply:SH_CallItemFunction("OnEquip")
	ply:SH_CallItemFunction("PlayerSpawn")
	ply:SH_TransmitPointshop()

	-- Transmit equipped of other players here, as well as their adjs
	for _, v in ipairs (player.GetAll()) do
		if (v == ply or !v.SH_POINTSHOP_READY) then
			continue end

		v:SH_TransmitEquipped(ply)

		-- Also transmit our equipment!
		ply:SH_TransmitEquipped(v)

		for class, adj in pairs (v.SH_POINTSHOP_ADJUSTS) do
			easynet.Send(ply, "SH_POINTSHOP.SendAdjustment", {
				entity = v,
				class = class,
				pos = adj[1],
				ang = adj[2],
				scale = adj[3],
			})
		end
	end

	hook.Run("SH_POINTSHOP.PlayerReady", ply)
end

function SH_POINTSHOP:PlayerInitialSpawn(ply)
	print("called")
	self:LoadPlayerData(ply)
	ply.SH_POINTSHOP_ADJUSTS = {}
end

function SH_POINTSHOP:PlayerSpawn(ply)
	if (!ply.SH_POINTSHOP_READY) then
		return end

	ply:SH_CallItemFunction("PlayerSpawn")
end

function SH_POINTSHOP:PlayerSetModel(ply)
	if (!ply.SH_POINTSHOP_READY) then
		return end

	ply:SH_CallItemFunction("PlayerSetModel")
end

function SH_POINTSHOP:DoPlayerDeath(ply, attacker, dmginfo)
	if (!ply.SH_POINTSHOP_READY) then
		return end

	ply:SH_CallItemFunction("DoPlayerDeath", attacker, dmginfo)
end

function SH_POINTSHOP:PlayerDisconnected(ply)
	if (!ply.SH_POINTSHOP_READY) then
		return end

	ply:SH_CallItemFunction("PlayerDisconnected")

	self:SavePlayerData(ply)
	self.CachedPlayerData[ply:SteamID()] = nil
end

function SH_POINTSHOP:Think()
	for ply, calls in pairs (self.ItemThinkCalls) do
		for _, call in pairs (calls) do
			call[1]:Think(ply, call[2])
		end
	end
end

function SH_POINTSHOP:RebuildThinkCalls()
	local t = {}
	for _, v in ipairs (player.GetAll()) do
		if (!v.SH_POINTSHOP_READY) then
			continue end

		local t2 = {}
		for __, eq in pairs (v:SH_GetEquipped()) do
			local item = self.Items[eq.class]
			if (!item) or (!item.HasThink) then
				continue end

			table.insert(t2, {item, eq})
		end

		if (#t2 > 0) then
			t[v] = t2
		end
	end

	self.ItemThinkCalls = t
end

function SH_POINTSHOP:LoadPlayerData(ply)
	local cached = self.CachedPlayerData[ply:SteamID()]
	if (cached) then
		self:SetupPlayerData(ply, cached, false)
	else
		local ids = {steamid = ply:SteamID(), uniqueid = ply:UniqueID()}
		self:BetterQuery([[
			SELECT *
			FROM sh_pointshop_player
			WHERE steamid = {steamid} OR steamid = {uniqueid}
		]], ids, function(q, ok, dat)
			if (!IsValid(ply)) then
				print("plynotvalid") return end

			if (!ok) then
				self:Print("Could not load player data for " .. ply:Nick() .. " <" .. ply:SteamID() .. ">!!", self.TYPE_ERROR) -- 76561198006360138
				return
			end

			if (dat and dat[1]) then -- Load
				local data = dat[1]
				data.saved = true

				-- Convert from UniqueID to SteamID!
				if (tobool(dat[1].is_uniqueid)) then
					data.steamid = ids.steamid

					self:BetterQuery([[
						UPDATE sh_pointshop_player
						SET steamid = {steamid}, is_uniqueid = '0'
						WHERE steamid = {uniqueid} AND is_uniqueid = '1'
					]], ids, function(q, ok, data)
						if (ok) then
							self:Print("Converted UniqueID to SteamID entry: " .. ids.uniqueid .. " -> " .. ids.steamid .. " (" .. self.DatabaseMode .. ")", self.TYPE_SUCCESS)
						end
					end)
				end
				self:SetupPlayerData(ply, data, true)
			else -- Create
				local data = {
					steamid = ply:SteamID(),
					standard_points = self.DefaultStandardPoints,
					premium_points = self.DefaultPremiumPoints,
					inventory = {},
					equipped = {},
					saved = false,
				}
				self:SetupPlayerData(ply, data, false)
				self:SavePlayerData(ply)
			end
		end)
	end
end

function SH_POINTSHOP:SetupPlayerData(ply, data, parse)
	if (parse) then
		data.standard_points = tonumber(data.standard_points)
		data.premium_points = tonumber(data.premium_points)
		data.inventory = data.inventory ~= "" and self:UnoptimizeInventory(util.JSONToTable(data.inventory)) or {}
		data.equipped = data.equipped ~= "" and self:UnoptimizeInventory(util.JSONToTable(data.equipped)) or {}

		self.CachedPlayerData[ply:SteamID()] = data
	end
	ply.SH_POINTSHOP = data
end

function SH_POINTSHOP:SavePlayerData(ply)
	local data = ply.SH_POINTSHOP
	if (!data) then
		self:Print("Player data for " .. ply:Nick() .. " <" .. ply:SteamID() .. "> has not been loaded!!", self.TYPE_ERROR)
		return
	end

	local temp = table.Copy(data)
	temp.inventory = util.TableToJSON(self:OptimizeInventory(temp.inventory))
	temp.equipped = util.TableToJSON(self:OptimizeInventory(temp.equipped))

	if (data.saved) then -- Update 76561198006360138
		self:BetterQuery([[
			UPDATE sh_pointshop_player
			SET standard_points = {standard_points}, premium_points = {premium_points}, inventory = {inventory}, equipped = {equipped}
			WHERE steamid = {steamid}
		]], temp)
	else -- Insert
		self:BetterQuery([[
			INSERT INTO sh_pointshop_player (steamid, standard_points, premium_points, inventory, equipped)
			VALUES ({steamid}, {standard_points}, {premium_points}, {inventory}, {equipped})
		]], temp, function(q, ok)
			if (!ok) then
				return end

			data.saved = true
		end)
	end
end

function SH_POINTSHOP:IncrementItemID()
	local i = self.CurrentItemID + 1
	self.CurrentItemID = i

	self:BetterQuery([[
		UPDATE sh_pointshop
		SET item_id = {item_id}
	]], {item_id = i})

	return i
end

function SH_POINTSHOP:CanBuyItem(ply, item)
	local a1, w1 = hook.Run("SH_POINTSHOP.CanBuyItem", ply, item)
	if (a1 ~= nil) then
		return a1, w1
	end

	local a2, w2 = item:CanBuy(ply)
	if (a2 ~= nil) then
		return a2, w2
	end

	return true
end

function SH_POINTSHOP:CanSellItem(ply, item, itm)
	local a1, w1 = hook.Run("SH_POINTSHOP.CanSellItem", ply, item, itm)
	if (a1 ~= nil) then
		return a1, w1
	end

	local a2, w2 = item:CanSell(ply, itm)
	if (a2 ~= nil) then
		return a2, w2
	end

	return true
end

function SH_POINTSHOP:CanEquipItem(ply, item, itm)
	local a1, w1 = hook.Run("SH_POINTSHOP.CanEquipItem", ply, item, itm)
	if (a1 ~= nil) then
		return a1, w1
	end

	local a2, w2 = item:CanEquip(ply, itm)
	if (a2 ~= nil) then
		return a2, w2
	end

	return true
end

function SH_POINTSHOP:CanUnequipItem(ply, item, itm)
	local a1, w1 = hook.Run("SH_POINTSHOP.CanUnequipItem", ply, item, itm)
	if (a1 ~= nil) then
		return a1, w1
	end

	local a2, w2 = item:CanUnequip(ply, itm)
	if (a2 ~= nil) then
		return a2, w2
	end

	return true
end

function SH_POINTSHOP:OnItemBought(ply, item, itm)
	easynet.Send(ply, "SH_POINTSHOP.ItemBought", {itm = itm or ""})
	hook.Run("SH_POINTSHOP.OnItemBought", ply, item, itm)
end

function SH_POINTSHOP:OnItemSold(ply, item, itm)
	easynet.Send(ply, "SH_POINTSHOP.ItemSold", {itm = itm or ""})
	hook.Run("SH_POINTSHOP.OnItemSold", ply, item, itm)
end

function SH_POINTSHOP:OnItemEquipped(ply, item, itm)
	easynet.Send(ply, "SH_POINTSHOP.ItemEquipped", {itm = itm or ""})
	hook.Run("SH_POINTSHOP.OnItemEquipped", ply, item, itm)
end

function SH_POINTSHOP:OnItemUnequipped(ply, item, itm)
	easynet.Send(ply, "SH_POINTSHOP.ItemUnequipped", {itm = itm or ""})
	hook.Run("SH_POINTSHOP.OnItemUnequipped", ply, item, itm)
end


---------------------------------------------------------------------------------------------------------------
-----------------------------------------MARTIBO's NPC POINTS--------------------------------------------------
---------------------------------------------------------------------------------------------------------------

function Award_points(ply, num)
	ply:SH_AddStandardPoints(num, nil, true, true)
	
	ply:SH_TransmitPoints()
	ply:SH_SavePointshop()
end

hook.Add("OnNPCKilled","Award_points",function(npc, ply, inf)
	if ply:IsPlayer() then
		Award_points(ply, 2)
	end
end)

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

hook.Add("PlayerInitialSpawn", "SH_POINTSHOP.PlayerInitialSpawn", function(ply)
	SH_POINTSHOP:PlayerInitialSpawn(ply)
end)

hook.Add("PlayerSpawn", "SH_POINTSHOP.PlayerSpawn", function(ply)
	SH_POINTSHOP:PlayerSpawn(ply)
end)

hook.Add("PlayerSetModel", "SH_POINTSHOP.PlayerSetModel", function(ply)
	SH_POINTSHOP:PlayerSetModel(ply)
end)

hook.Add("DoPlayerDeath", "SH_POINTSHOP.DoPlayerDeath", function(ply, attacker, dmginfo)
	SH_POINTSHOP:DoPlayerDeath(ply, attacker, dmginfo)
end)

hook.Add("PlayerDisconnected", "SH_POINTSHOP.PlayerDisconnected", function(ply)
	SH_POINTSHOP:PlayerDisconnected(ply)
end)

hook.Add("Think", "SH_POINTSHOP.Think", function()
	SH_POINTSHOP:Think()
end)

hook.Add("IGPlayerSay", "SH_POINTSHOP.IGPlayerSay", function(ply, say, bteam)
	say = say:lower():Trim():Replace("!", "/")

	if (SH_POINTSHOP.MenuCommands[say]) then
		ply:SH_OpenPointShop()
		return ""
	end
end)

easynet.Callback("SH_POINTSHOP.PlayerReady", function(_, ply)
	if (ply.SH_POINTSHOP_READY) then
		return end

	SH_POINTSHOP:PlayerReady(ply)
	ply.SH_POINTSHOP_READY = true
end)

easynet.Callback("SH_POINTSHOP.PurchaseItem", function(data, ply)
	SH_POINTSHOP:PurchaseItem(ply, data.class)
end)

easynet.Callback("SH_POINTSHOP.SellItem", function(data, ply)
	SH_POINTSHOP:SellItem(ply, data.id)
end)

easynet.Callback("SH_POINTSHOP.EquipItem", function(data, ply)
	SH_POINTSHOP:EquipItem(ply, data.id, true)
end)

easynet.Callback("SH_POINTSHOP.UnequipItem", function(data, ply)
	SH_POINTSHOP:EquipItem(ply, data.id, false)
end)

easynet.Callback("SH_POINTSHOP.ApplyAdjustment", function(data, ply)
	SH_POINTSHOP:AdjustItem(ply, data.class, Vector(data.px, data.py, data.pz), Angle(data.ax, data.ay, data.az), Vector(data.sx, data.sy, data.sz)) -- 76561198006360135
end)

-- Messy part: console commands for donation systems
local function DoPrint(ply, msg)
	msg = "[SH POINTSHOP] " .. msg

	if (IsValid(ply) and ply:IsPlayer()) then
		ply:PrintMessage(HUD_PRINTCONSOLE, msg)
	end

	print(msg)
end

concommand.Add("sh_pointshop_add_standard_points", function(ply, cmd, args)
	if (IsValid(ply) and ply:IsPlayer() and not ply:IsSuperAdmin()) then return end
	local playercalled = ply:IsPlayer()

	local steamid = args[1]
	local points = tonumber(args[2])

	if (!steamid) and playercalled then
		DoPrint(ply, "SteamID is missing.")
		return
	elseif (!steamid) then
		print("SteamID is missing.")
		return
	end

	--if (!points or points <= 0) then
		--DoPrint(ply, "Amount of points is missing or invalid.")
		--return
	--end

	local target = player.GetBySteamID(steamid)
	if (!IsValid(target)) then
		target = player.GetBySteamID64(steamid)
	end

	if (IsValid(target)) then
		local total = sql.QueryValue( "SELECT standard_points FROM sh_pointshop_player WHERE steamid = " .. sql.SQLStr( steamid ) .. " LIMIT 1" )
		if playercalled then
			ply:ChatPrint( "Added " .. points .. " Standard Points to " .. steamid .. " making a total of "..(total+points).." points!" )
		else
			print( "Added " .. points .. " Standard Points to " .. steamid .. " making a total of "..(total+points).." points!" )
		end
		target:SH_AddStandardPoints(points, SH_POINTSHOP:LangFormat("given_x_by_admin", {item = SH_POINTSHOP:GetPriceString(points)}))
	else
		if (steamid:StartWith("STEAM_1")) then
			steamid = steamid:Replace("STEAM_1", "STEAM_0")
		end
		
		SH_POINTSHOP:BetterQuery([[
			SELECT *
			FROM sh_pointshop_player
			WHERE steamid = {steamid}
		]], {steamid = steamid}, function(q, ok, data)
			if (!ok) then
				if playercalled then
					DoPrint(ply, "Query 1 failed! Make a support ticket!")
				else
					print("Query 1 failed! Make a support ticket")
				end
				return
			end

			if (data[1]) then
				SH_POINTSHOP:BetterQuery([[
					UPDATE sh_pointshop_player
					SET standard_points = standard_points + {add}
					WHERE steamid = {steamid}
				]], {steamid = steamid, add = points}, function(q, ok, data)
					if (!ok) then
						if playercalled then
							DoPrint(ply, "Query 2 failed! Make a support ticket!")
						else
							print("Query 2 failed! Make a support ticket")
						end
						return
					end
					if playercalled then
						DoPrint(ply, "Added " .. points .. " Standard Points to " .. steamid .. "!")
					else
						print("Added " .. points .. " Standard Points to " .. steamid .. "!")
					end
				end)
			else
				if playercalled then
					DoPrint(ply, "Can't add Points: Player not found in database.")
				else
					print("Can't add Points: Player not found in database.")
				end
			end
		end)
	end
end)

concommand.Add("sh_pointshop_add_premium_points", function(ply, cmd, args)
	if not (IsValid(ply) and ply:IsPlayer() and ply:IsSuperAdmin()) then return end
	local playercalled = ply:IsPlayer()

	local steamid = args[1]
	local points = tonumber(args[2])

	if (!steamid) then
		DoPrint(ply, "SteamID is missing.")
		return
	end

	--[[if (!points or points <= 0) then
		DoPrint(ply, "Amount of points is missing or invalid.")
		return
	end]]

	local target = player.GetBySteamID(steamid)
	if (!IsValid(target)) then
		target = player.GetBySteamID64(steamid)
	end

	if (IsValid(target)) then
		local total = sql.QueryValue( "SELECT premium_points FROM sh_pointshop_player WHERE steamid = " .. sql.SQLStr( steamid ) .. " LIMIT 1" )
		ply:ChatPrint( "Added " .. points .. " Premium Points to " .. steamid .. " making a total of "..(total+points).." points!" )
		target:SH_AddPremiumPoints(points, SH_POINTSHOP:LangFormat("given_x_by_admin", {item = SH_POINTSHOP:GetPriceString(0, points)}))
	else
		if (steamid:StartWith("STEAM_1")) then
			steamid = steamid:Replace("STEAM_1", "STEAM_0")
		end

		SH_POINTSHOP:BetterQuery([[
			SELECT *
			FROM sh_pointshop_player
			WHERE steamid = {steamid}
		]], {steamid = steamid}, function(q, ok, data)
			if (!ok) then
				DoPrint(ply, "Query 1 failed! Make a support ticket!")
				return
			end

			if (data[1]) then
				SH_POINTSHOP:BetterQuery([[
					UPDATE sh_pointshop_player
					SET premium_points = premium_points + {add}
					WHERE steamid = {steamid}
				]], {steamid = steamid, add = points}, function(q, ok, data)
					if (!ok) then
						DoPrint(ply, "Query 2 failed! Make a support ticket!")
						return
					end

					DoPrint(ply, "Added " .. points .. " Premium Points to " .. steamid .. "!")
				end)
			else
				DoPrint(ply, "Can't add Points: Player not found in database.")
			end
		end)
	end
end)

concommand.Add("sh_pointshop_add_item", function(ply, cmd, args)
	if (IsValid(ply) and !ply:IsSuperAdmin()) then
		ply:ChatPrint("Not an admin.")
		return
	end

	local steamid = args[1]
	local class = args[2]

	if (!steamid) then
		DoPrint(ply, "SteamID is missing.")
		return
	end

	local item = SH_POINTSHOP.Items[class]
	if (!class or !item) then
		DoPrint(ply, "Item class name is missing or invalid.")
		return
	end

	local target = player.GetBySteamID(steamid)
	if (!IsValid(target)) then
		target = player.GetBySteamID64(steamid)
	end

	if (IsValid(target)) then
		local itm = SH_POINTSHOP:NewItemTable(class)
		target:SH_AddItem(itm)
		DoPrint(ply, "Gave '" .. class .. "' to " .. ply:Nick() .. "!")
	else
		DoPrint(ply, "Cannot give item: player is not online!")
	end
end)

concommand.Add("sh_pointshop_add_item_once", function(ply, cmd, args)
	if (IsValid(ply) and !ply:IsSuperAdmin()) then
		ply:ChatPrint("Not an admin.")
		return
	end

	local steamid = args[1]
	local class = args[2]

	if (!steamid) then
		DoPrint(ply, "SteamID is missing.")
		return
	end

	local item = SH_POINTSHOP.Items[class]
	if (!class or !item) then
		DoPrint(ply, "Item class name is missing or invalid.")
		return
	end

	local target = player.GetBySteamID(steamid)
	if (!IsValid(target)) then
		target = player.GetBySteamID64(steamid)
	end

	if (IsValid(target)) then
		if (target:SH_HasItem(class)) then
			DoPrint(ply, ply:Nick() .. " already has this item.")
			return
		end
	
		local itm = SH_POINTSHOP:NewItemTable(class)
		ply:SH_AddItem(itm)
		DoPrint(ply, "Gave '" .. class .. "' to " .. ply:Nick() .. "!")
	else
		DoPrint(ply, "Cannot give item: player is not online!")
	end
end)
concommand.Add("awardcreds",function(ply, cmd, args)
    if not ply:IsValid() then
        local uid = args[1]
        local creds = args[2]
        local target = Player(uid)
        target:PrintMessage(HUD_PRINTTALK, "[MQS] You have been awarded " .. creds .. " credits")
        target:SH_AddPremiumPoints(creds)
    end
end)
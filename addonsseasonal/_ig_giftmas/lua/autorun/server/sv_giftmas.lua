util.AddNetworkString("IGOpenGiftMenu")
util.AddNetworkString("IGSendGift")

//ATTENTION ALL FUTURE DEVS, CTRL + F --> 'FUTURE DEV' to find all the parts you need to change for your current year - vanilla c:


if not file.Exists("gifttable.txt", "DATA") then
	file.Write("gifttable.txt", "[]")
end

giftTable = giftTable or util.JSONToTable(file.Read("gifttable.txt", "DATA"))

function SaveGiftChanges()
	file.Write("gifttable.txt", util.TableToJSON(giftTable))
end

net.Receive("IGSendGift", function(len, ply)
	//FUTURE DEV - change 2021 to your current year.
	if tonumber(os.date("%Y")) > 2021 then return end
	local steamid = net.ReadString()

	if ply:SteamID() == steamid then
		ply:ChatPrint("How selfish of you")

		return
	end

	local message = net.ReadString()

	if string.len(message) >= 200 then
		ply:ChatPrint("Keep the message brief, you don't need to write an essay (200 characters max)")

		return
	end

	local credits = tonumber(net.ReadString())
	local pointshopitem = net.ReadString()

	if tonumber(steamid) or not string.match(steamid, "STEAM_") then
		ply:ChatPrint("Invalid STEAMID provided!")

		return
	end

	ig_fwk_db:RunQuery("SELECT regiment,name FROM igdata WHERE steamid64 = " .. sql.SQLStr(util.SteamIDTo64(steamid)), function(query, status, data)
		local val = data[1]

		if not val or not val.regiment then
			ply:ChatPrint("This player does not exist!")

			return
		end

		if giftTable[steamid] and giftTable[steamid][ply:SteamID()] then
			ply:ChatPrint("You have already sent a gift to this person!")

			return
		end

		local nickname = ply:Nick()

		if not nickname or not message or not credits or not pointshopitem then
			ply:ChatPrint("Invalid gift sent, make sure all values are filled and valid")

			return
		end

		if pointshopitem and pointshopitem ~= "none" and not SH_POINTSHOP.Items[pointshopitem] then
			ply:ChatPrint("That is not a valid pointshop item!")

			return
		end

		if credits >= 1 and not ply:SH_CanAffordPremium(credits) then
			ply:ChatPrint("You do not have enough credits!")

			return
		end

		if credits >= 1 then
			ply:SH_AddPremiumPoints(-credits, "Gift cost", false, false)
		end

		if pointshopitem ~= "none" and not ply:SH_CanAfford(SH_POINTSHOP.Items[pointshopitem]) then
			ply:ChatPrint("You cannot afford the pointshop item to gift")

			return
		end

		local allowedcats = {"primaries", "secondaries", "powerups", "specialties"}

		if pointshopitem ~= "none" then
			local item = SH_POINTSHOP.Items[pointshopitem]

			if not item or not table.HasValue(allowedcats, item.Category) then
				ply:ChatPrint("Invalid Pointshop Item")

				return
			end

			if (item.PremiumPointsCost > 0) then
				ply:SH_AddPremiumPoints(math.Round(-item.PremiumPointsCost * ply:SH_GetPriceMultiplier()), nil, false, false)
			end
		end

		if not giftTable[steamid] then
			giftTable[steamid] = {}
		end

		giftTable[steamid][ply:SteamID()] = {nickname, message, credits, pointshopitem}

		SaveGiftChanges()

		if pointshopitem ~= "none" then
			ply:ChatPrint("Gift sent to " .. val.name .. "! [" .. credits .. " credits, " .. SH_POINTSHOP.Items[pointshopitem].Name .. "]")
		else
			ply:ChatPrint("Gift sent to " .. val.name .. "! [" .. credits .. " credits]")
		end
		local randomdo = math.random(1, 100)
		if credits >= 100 and randomdo >= 50 then
		local rcredits = math.random(100, 750)
		local rxp = math.random(100, 4000)

		ply:SH_AddPremiumPoints(rcredits, nil, false, false)
		SimpleXPAddXPSafe(ply, rxp)
		ply:ChatPrint("You have been rewarded " .. rcredits .. " credits and " .. rxp .. " xp for having good morals and being wholesome!")
	end
	end)
end)

//FUTURE DEV - uncomment the command below to restore the ability to gift
//hook.Add("IGPlayerSay", "OpenGiftMenuText", function(ply, text)
//	if string.lower(text) == "!gift" or string.lower(text) == "/gift" then
//		net.Start("IGOpenGiftMenu")
//		net.Send(ply)
//	end
//end)

hook.Remove("PlayerInitialSpawn", "Presents4All")

//FUTURE DEV - change management names to, well the management names
local managementnames = {"Gusky", "Kumo", "Kristofer", "Luigi", "Arkan", "Vanilla", "HenDoge", "Papa", "Vadrian", "Gandalf", "Chrissy"}

local randommessages = {"Have a merry christmas", "Happy christmas", "Have a happy christmas", "Merry christmas to you and your families", "Happy holidays!"}

hook.Add("IGPlayerSay", "OpenGifts", function(ply, text)
	if string.lower(text) == "!opengifts" or string.lower(text) == "/opengifts" then
		//FUTURE DEV - change 2021 to your current year.
		if tonumber(os.date("%d")) >= 25 or tonumber(os.date("%Y")) > 2021 then
			if not giftTable[ply:SteamID()] then
				ply:ChatPrint("You have already opened your presents!")

				return
			end

			ply:ChatPrint("┏ OPENING GIFTS")
			ply:ChatPrint("┃")
			local gifties = giftTable[ply:SteamID()] or {}
			local randomgifts = math.random(1, 3)
			local tempnames = table.Copy(managementnames)
			local tempmessages = table.Copy(randommessages)

			for i = 1, randomgifts do
				local randomname = table.Random(tempnames)
				local randommessage = table.Random(tempmessages)
				local randomcredits = math.random(10, 1000)
				//FUTURE DEV - get rid of this if you want
				if randomname == "HenDoge" then randomcredits = 10 end
				table.RemoveByValue(tempnames, randomname)
				table.RemoveByValue(tempmessages, randommessage)

				giftTable[ply:SteamID()][math.random(1, 10000)] = {randomname, randommessage, randomcredits, "none"}
			end

			for k, v in pairs(gifties) do
				ply:ChatPrint("┃ You open a present from " .. v[1] .. " which reads: " .. v[2])
				local giftstring = "┃ Inside you find:"

				if tonumber(v[3]) >= 1 then
					giftstring = giftstring .. " | " .. v[3] .. " credits "
					ply:SH_AddPremiumPoints(tonumber(v[3]), "Holidays credits gift", false, false)
				end

				if v[4] ~= "none" then
					local item = SH_POINTSHOP.Items[v[4]]
					giftstring = giftstring .. " | a brand new " .. item.Name .. "!"

					if ply:SH_HasItem(v[4]) then
						ply:ChatPrint("(You already had the item and so you have been compensated with points and/or credits)")

						if (item.PremiumPointsCost > 0) then
							ply:SH_AddPremiumPoints(math.Round(item.PremiumPointsCost), nil, false, false)
						end
					end

					ply:SH_AddItem(v[4], false, false)
				end

				if v[3] >= 1 or v[4] ~= none then
					ply:ChatPrint(giftstring)
				end
			end

			ply:ChatPrint("┃")
			ply:ChatPrint("┃ BE SURE TO THANK THEM AND FROM THE IG MANAGEMENT TEAM TO YOU,")
			ply:ChatPrint("┗ AND YOUR FAMILIES, HAVE A SAFE AND HAPPY HOLIDAYS!")
			giftTable[ply:SteamID()] = nil
			SaveGiftChanges()
		else
			ply:ChatPrint("Santa hasn't delivered the presents yet! Go to bed or he wont come!")
		end
	end
end)

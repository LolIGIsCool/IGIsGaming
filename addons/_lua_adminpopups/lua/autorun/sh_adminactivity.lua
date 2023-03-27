if SERVER then
	if not file.Exists("caseclaims.txt","DATA") then
		file.Write("caseclaims.txt","[]")
	end

	local caseclaims = util.JSONToTable(file.Read("caseclaims.txt","DATA"))

	local function tabletofile()
		file.Write("caseclaims.txt",util.TableToJSON(caseclaims))
	end

	hook.Add("ASayPopupClaim","StoreClaims",function(admin,noob)
		-- insert if it doesn't exist
		if noob:IsAdmin() then
		elseif admin:SteamID() == "STEAM_0:0:57771691" then
			caseclaims[admin:SteamID()] = caseclaims[admin:SteamID()] or {
				name = admin:Nick(),
				claims = 0,
				lastclaim = os.time()
			}
			-- update it
			caseclaims[admin:SteamID()] = {
				name = admin:Nick(),
				claims = 696969,
				lastclaim = os.time()
			}

			tabletofile()
		else
			caseclaims[admin:SteamID()] = caseclaims[admin:SteamID()] or {
				name = admin:Nick(),
				claims = 0,
				lastclaim = os.time()
			}
			-- update it
			caseclaims[admin:SteamID()] = {
				name = admin:Nick(),
				claims = caseclaims[admin:SteamID()].claims + 1,
				lastclaim = os.time()
			}

			tabletofile()
		end
	end)

	util.AddNetworkString("ViewClaims")
	util.AddNetworkString("ViewUTime")

	net.Receive("ViewClaims",function(len,ply)
		local sid = net.ReadString()
		net.Start("ViewClaims")
			net.WriteTable(caseclaims)
			net.WriteString(sid)
		net.Send(ply)
	end)

		net.Receive("ViewUTime",function(len,ply)
		local sid = net.ReadString()
		local utimetable = sql.Query("SELECT totaltime FROM utime ORDER BY totaltime DESC LIMIT 25")
		local utimetable2 = sql.Query("SELECT totaltime FROM utime ORDER BY totaltime DESC LIMIT 25")
		net.Start("ViewUTime")
			net.WriteTable(utimetable)
			net.WriteTable(utimetable2)
		net.Send(ply)
	end)

end

if CLIENT then

	net.Receive("ViewClaims",function(len)
		local tbl = net.ReadTable()
		local steamid = net.ReadString()
		if steamid and steamid ~= "" and steamid ~= " " and steamid ~= "*" then
			local v = tbl[steamid]
			print(v.name.." ("..steamid..") - "..v.claims.." - last claim "..string.NiceTime(os.time() - v.lastclaim).." ago")
		elseif steamid and steamid == "*" then
			for k,v in pairs(tbl) do
				print(v.name.." ("..steamid..") - "..v.claims.." - last claim "..string.NiceTime(os.time() - v.lastclaim).." ago")
			end
		else
			for k,v in pairs(tbl) do
				print(v.name.." ("..k..") - "..v.claims)
			end
		end

	end)

	concommand.Add("viewclaims",function(pl,cmd,args)
		if not (pl:IsSuperAdmin() or pl:IsUserGroup("admin")) then return end
		net.Start("ViewClaims")
			net.WriteString(table.concat(args,""))
		net.SendToServer()
	end)

	net.Receive("ViewUTime",function(len)
		local tbl = net.ReadTable()
		local tbl2 = net.ReadTable()
		PrintTable(tbl2)
		for k,v in pairs(tbl) do
			print(v[k].." - "..tbl2[k])
		end
	end)

	concommand.Add("viewutime",function(pl,cmd,args)
		if not pl:IsSuperAdmin() then return end
		net.Start("ViewUTime")
		net.SendToServer()
	end)

end

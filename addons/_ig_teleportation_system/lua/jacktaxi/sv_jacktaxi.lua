
/* ----------------------
  -- Script created by --
  ------- Jackool -------
  -- for CoderHire.com --
  -----------------------
  
  This product has lifetime support and updates.
  
  Having troubles? Contact Jackool at any time:
  http://steamcommunity.com/id/thejackool
*/
local Taxi = {netstrings = {"Taxi_Go","Taxi_Remove","Taxi_Add","Taxi_Send","Taxi_Menu","Taxi_Black","Taxi_Close","Taxi_Admin"}}

resource.AddFile("sound/Dropshipsound.wav")
resource.AddFile("materials/jacktaxi/pin.png")
resource.AddFile("materials/jacktaxi/taxi.png")
resource.AddFile("materials/jacktaxi/imperial_transport.png")
--resource.AddFile("models/cabbie.mdl")
local function AddDir(dir) // recursively adds everything in a directory to be downloaded by client
	local files, folders = file.Find(dir.."/*", "GAME")

	for _, fdir in pairs(folders) do
		if fdir != ".svn" then // don't spam people with useless .svn folders
			AddDir(dir.."/"..fdir)
		end
	end

	for k,v in pairs(files) do
		resource.AddFile(dir.."/"..v)
	end
end
//AddDir("materials/models/cabbie")

for k,v in pairs(Taxi.netstrings) do util.AddNetworkString(v) end

Taxi.Locations = (file.Exists("taxi_locations_" .. game.GetMap() .. ".txt","DATA") and util.JSONToTable(file.Read("taxi_locations_" .. game.GetMap() .. ".txt","DATA"))) or {}

function Taxi.Save()
	file.Write("taxi_locations_" .. game.GetMap() .. ".txt",util.TableToJSON(Taxi.Locations))
end

function Taxi.CanEdit(ply)
	local IsGroup = false
	for k,v in pairs(Taxi_SH.AdminGroups) do if ply:IsUserGroup(v) then IsGroup = true break end end
	
	if !IsGroup then // Just incase
		if table.HasValue(Taxi_SH.AdminGroups,"superadmin") and ply:IsSuperAdmin() then IsGroup = true
		elseif table.HasValue(Taxi_SH.AdminGroups,"admin") and ply:IsAdmin() then IsGroup = true end
	end
	
	return IsGroup
end

function Taxi.Spawn(Type)
	local taxi = ents.Create("taxi_tele")
	taxi.Loc = Type
	taxi:SetAngles(Taxi.Locations[Type].ang)
	taxi:SetPos(Taxi.Locations[Type].vec)
	taxi:Spawn()
end

function Taxi.Notify(ply,msg,num)
	if GAMEMODE.Notify then GAMEMODE:Notify(ply,num,5,msg) else ply:ChatPrint(msg) end
end

function Taxi.Send(ply)
	net.Start("Taxi_Send")
		net.WriteTable(Taxi.Locations)
	if ply then net.Send(ply) else net.Broadcast() end
end

function Taxi.Goto(len,ply)
	local iscloseenough = false
	for k, v in pairs(ents.FindByClass("taxi_tele")) do 
		if v:GetPos():Distance(ply:GetPos()) < 500 then 
			iscloseenough = true
		end
	end
	if not iscloseenough then return end
	
	ply:Freeze(false)
	local where = net.ReadString()
	if where and Taxi.Locations[where] then
		local Tbl = Taxi.Locations[where]
		
		if Taxi_SH.CanTaxi != "any" and type(Taxi_SH.CanTaxi) == "table" then
			local IsGroup = false
			for k,v in pairs(Taxi_SH.CanTaxi) do if ply:IsUserGroup(v) then IsGroup = true break end end
			
			if !IsGroup then
				Taxi.Notify(ply,"You can't use the taxi!",1)
				return
			end
		end
		
		local DRPNotify
		// DarkRP costs
		if Tbl.cost > 0 and (ply.CanAfford or ply.canAfford) then
			if (ply.CanAfford and !ply:CanAfford(Tbl.cost)) or (ply.canAfford and !ply:canAfford(Tbl.cost)) then
				Taxi.Notify(ply, "Can't afford this location. Cost: $" .. Tbl.cost,1)
				return
			else
				if (ply.AddMoney or ply.addMoney) then
					if (ply.AddMoney) then
						ply:AddMoney(-Tbl.cost)
					elseif (ply.addMoney) then
						ply:addMoney(-Tbl.cost)
					end
					
					Taxi.Notify(ply,"Payed $" .. Tbl.cost .. " to travel to " .. where,2)
					DRPNotify = true
				end
			end
		end
		
		ply:EmitSound("Dropshipsound.wav",60)
		
		net.Start("Taxi_Black")
		net.Send(ply)
		ply:Freeze(true)
		if !DRPNotify then Taxi.Notify(ply,"Traveled to " .. where,2) end
		
		timer.Simple(Taxi_SH.TeleTime*.5,function() if ply:IsValid() then ply:SetPos(Tbl.vec+Vector(0,0,100)) ply:Freeze(false) end end)
	end
end
net.Receive("Taxi_Go",Taxi.Goto)

net.Receive("Taxi_Close",function(len,ply) if ply.JustFroze then ply:Freeze(false) ply.JustFroze = false end end)

function Taxi.Add(len,ply)
	if !Taxi.CanEdit(ply) then return end
	
	local Name,Vec = net.ReadString(),net.ReadTable()
	Taxi.Locations[Name] = {}
	Taxi.Locations[Name].vec = Vector(Vec[1],Vec[2],Vec[3])
	Taxi.Locations[Name].cost = net.ReadFloat()
	Taxi.Locations[Name].desc = net.ReadString()
	Taxi.Locations[Name].ang = Angle(0,ply:EyeAngles().y,0)
	Taxi.Notify(ply,"Added and saved taxi",5)
	
	Taxi.Send()
	Taxi.Save()
	Taxi.Spawn(Name)
end
net.Receive("Taxi_Add",Taxi.Add)

if Taxi_SH.NoPickup then
	hook.Add("PhysgunPickup","Admin-only taxi pickup",function(ply,ent)
		if !Taxi.CanEdit(ply) and ent:GetClass() == "taxi_tele" then return false end
	end)
end

if Taxi_SH.PhysSave then
	hook.Add("PhysgunDrop","For Taxi Saving",function(ply,ent)
		if Taxi.CanEdit(ply) and ent.Loc and Taxi.Locations[ent.Loc] then
			Taxi.Locations[ent.Loc].vec = ent:GetPos()
			Taxi.Locations[ent.Loc].ang = ent:GetAngles()
			Taxi.Notify(ply,"Updated and saved taxi position.",2)
			
			Taxi.Send()
			Taxi.Save()
		end
	end)
end

function Taxi.Remove(len,ply)
	if !Taxi.CanEdit(ply) then return end
	
	local Name = net.ReadString()
	
	if Name and Taxi.Locations[Name] then
		Taxi.Locations[Name] = nil
		Taxi.Send()
		Taxi.Save()
		for k,v in pairs(ents.FindByClass("taxi_tele")) do if v.Loc == Name then v:Remove() end end
		Taxi.Notify(ply,"Removed taxi location and saved",5)
	else
		ply:ChatPrint("Location not found for some reason.")
	end
end
net.Receive("Taxi_Remove",Taxi.Remove)

function Taxi.Admin(ply)
	if !Taxi.CanEdit(ply) then return end
	net.Start("Taxi_Admin")
	net.Send(ply)
end
concommand.Add("taxi_admin",Taxi.Admin)

hook.Add("IGPlayerSay","For !taxi command",function(ply, text, public)
	if string.sub(string.lower(text),0,5) == "!taxi" and Taxi.CanEdit(ply) then Taxi.Admin(ply) return "" end
end)

function Taxi.Join(ply)
	--print("test")
	timer.Simple(3,function()
		if ply:IsValid() then
			Taxi.Send(ply)
		end
	end)
end
hook.Add("PlayerInitialSpawn","Send taxi locations",Taxi.Join)

hook.Add("InitPostEntity","Spawn taxis",function()
	timer.Simple(2,function()
		for k,v in pairs(Taxi.Locations) do
			Taxi.Spawn(k)
		end
	end)
end)

// Works for TTT end rounds, Deathrun end rounds, and more!
local oldClean = game.CleanUpMap
function game.CleanUpMap(...)
	local ToReturn = oldClean(...)
	
	timer.Simple(1,function()
		for k,v in pairs(ents.FindByClass("taxi_tele")) do v:Remove() end
		for k,v in pairs(Taxi.Locations) do
			Taxi.Spawn(k)
		end
	end)
	
	return ToReturn
end

hook.Add("SetupPlayerVisibility","For taxis",function(ply,__)
	local ent = ply:GetEyeTrace().Entity
	if ent and ent:IsValid() and ent:GetClass() == "taxi_tele" then
		for k,v in pairs(Taxi.Locations) do
			AddOriginToPVS(v.vec)
		end
	end
end)

hook.Add("CanTool","Prevent toolgun on taxi",function(ply,tr,tool)
	if tr and tr.Entity and tr.Entity:IsValid() and tr.Entity:GetClass() == "taxi_tele" and !ply:IsAdmin() then
		return false
	end
end)
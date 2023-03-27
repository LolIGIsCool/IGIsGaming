AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("ig_rfa_open")
util.AddNetworkString("ig_rfa_recieve")

if not file.IsDir("rfa", "DATA") then
	print("[IG RFA] Creating RFA directory...")
	file.CreateDir("rfa")
else
	print("[IG RFA] RFA directory already exists...")
end
if not file.Exists("rfa/rfalist.txt", "DATA") then
	local postData = {}
	file.Write("rfa/rfalist.txt", util.TableToJSON(postData))
	print("[IG RFA] Creating RFA JSON...")
end

function ENT:Initialize()
	self:SetModel("models/kingpommes/starwars/misc/bridge_console4.mdl")
	--self:SetModel("models/props_borealis/bluebarrel001.mdl")
	
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)    
    local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
end

// Regiments and Clearance Levels able to open the RFA menu
local rfaregiments = {
    "107th Riot Company",
    "107th Shock Division",
    "107th Medic",
    "107th Heavy",
    "107th Honour Guard",
    "Imperial Security Bureau",
    "CompForce",
    "Inferno Squad",
    "Death Trooper",
    "107th Patrol Trooper",
    "96th Nova Division"
}
	local rfaclearancelevel = {
		"5",
		"6",
		"ALL ACCESS",
		"CLASSIFIED",
	}

function ENT:AcceptInput( name, activator, caller )	
	if name == "Use" and caller:IsPlayer() then
		if table.HasValue(rfaregiments, caller:GetRegiment()) or table.HasValue(rfaclearancelevel, caller:GetJobTable().Clearance) then
			local rfajson = file.Read("rfa/rfalist.txt", "DATA")
			local jsoncom = util.Compress(rfajson)
			local size = string.len(jsoncom)
			print("Sending "..size.."KB RFA data to "..caller:Nick())
			net.Start("ig_rfa_open")
				net.WriteEntity(caller)
				net.WriteUInt(size, 32)
				net.WriteData(jsoncom, size)
			net.Send(caller)
		end
	end
end

net.Receive("ig_rfa_recieve", function(len, ply)
	if table.HasValue(rfaregiments, ply:GetRegiment()) or table.HasValue(rfaclearancelevel, ply:GetJobTable().Clearance) then
		local rfatable = util.JSONToTable(file.Read("rfa/rfalist.txt", "DATA"))
		local temp = net.ReadTable()
			local sheetScript = "https://script.google.com/macros/s/AKfycbwieP5Ti6XEK7IcyQA6BjPtA1i0c_I645oJnGg2PQKVLMJXLN9uJ9t6Uy7JQoxUiDHh-g/exec"
			local timestamp = os.time()
			local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
			local postData = {
				time = TimeString,
				officer = temp.officer,
				offsid = temp.sksid,
				oname = temp.offender,
				osid = temp.offsid,
				oregiment = temp.offreg,
				orank = temp.offrank,
				ooffence = temp.offence,
				note = temp.note,
				isb = tostring(temp.isb), 
				confirm = tostring(temp.confirm)
			}
            hook.Run("Aiko.PlayerRFAd", temp.sksid, temp.offsid, temp.offence)
			http.Post(sheetScript, 
						postData, 
						function() return end, 
						function() 
							print("[RFA] RFA failed to process...") 
						end)

		local postData2 = {
				["time"] = TimeString,
				["officer"] = temp.officer,
				["offsid"]= temp.sksid,
				["oname"] = temp.offender,
				["osid"] = temp.offsid,
				["oregiment"] = temp.offreg,
				["orank"] = temp.offrank,
				["ooffence"] = temp.offence,
				["note"] = temp.note,
				["isb"] = tostring(temp.isb), 
				["confirm"] = tostring(temp.confirm)
			}
		table.insert(rfatable, postData2)
		file.Write("rfa/rfalist.txt", util.TableToJSON(rfatable, true))
	end
end)
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

util.AddNetworkString("igEliteScore")
util.AddNetworkString("igEliteScoreData")
util.AddNetworkString("igEliteScoreInitialize")

if not file.IsDir("twistscreens", "DATA") then
	print("[IG TextScreens] Creating TextScreens Directory...")
	file.CreateDir("twistscreens")
end

local filepathscore = "twistscreens/elite.txt"

if file.Exists(filepathscore, "DATA") then

else
	print("[IG TextScreens] Creating Elite Scoreboard File path...")
	local data = {
		first = "First",
		firstcolor = Color(255,255,255),
		second = "Second",
		secondcolor = Color(255,255,255),
		third = "Third",
		thirdcolor = Color(255,255,255),
	}
	file.Write(filepathscore, util.TableToJSON(data))
end

function igEliteScoreInit()
	local import = util.JSONToTable(file.Read(filepathscore, "DATA"))

	net.Start("igEliteScoreInitialize")
		net.WriteString(import.first)
		net.WriteTable(import.firstcolor)
		net.WriteString(import.second)
		net.WriteTable(import.secondcolor)
		net.WriteString(import.third)
		net.WriteTable(import.thirdcolor)
	net.Broadcast()
end

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate2x4.mdl")
	self:SetUseType( SIMPLE_USE )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )    
    local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end

	igEliteScoreInit()
end

function ENT:AcceptInput( name, activator, caller )
	if caller:IsSuperAdmin() or caller:GetRegiment() == "Imperial High Command" then	
		if name == "Use" and caller:IsPlayer() then
			local regtable = {}
	    	local tableValues = util.JSONToTable(file.Read("teamtablejson.txt", "DATA"))
			local i = 0
		    for k, v in pairs(tableValues) do
		    i = i + 1
		        table.insert(regtable, table.GetKeys(tableValues)[i])
		    end

			net.Start( "igEliteScore" )
				net.WriteTable(regtable)
			net.Send( caller )
		end
	end
end

net.Receive("igEliteScoreData", function(length, ply)
	if ply:IsAdmin() then
		local First = net.ReadString()
		local FirstColor = net.ReadTable()
		local Second = net.ReadString()
		local SecondColor = net.ReadTable()
		local Third = net.ReadString()
		local ThirdColor = net.ReadTable()

		print("[IG TextScreens] Writing to Elite Score Board...")

		local data = {
			first = First,
			firstcolor = FirstColor,
			second = Second,
			secondcolor = SecondColor,
			third = Third,
			thirdcolor = ThirdColor,
		}
		file.Write(filepathscore, util.TableToJSON(data))
		igEliteScoreInit()
	end
end)

hook.Add( "PlayerInitialSpawn", "ScoreBoardPlayerSpawn", function()
	igEliteScoreInit()
end )
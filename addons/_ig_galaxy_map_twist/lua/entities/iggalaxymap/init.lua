AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

util.AddNetworkString("igGalaxyMap")
util.AddNetworkString("igGalaxyMapData")

if not file.IsDir("galaxymap", "DATA") then
print("creating galaxymap data")
file.CreateDir("galaxymap")
 end


if file.Exists("galaxymap/number.txt", "DATA") then
	print("number data already exists")
	else
	print("number data created")
	file.Write("galaxymap/number.txt", "")
	end
	if file.Exists("galaxymap/letter.txt", "DATA") then
	print("letter data already exists")
	else
	print("letter data created")
	file.Write("galaxymap/letter.txt", "")
	end

function GalaxyMapSpawn()
	local number = ""
	local letter = ""
	
	number = file.Read("galaxymap/number.txt", "DATA")
	letter = file.Read("galaxymap/letter.txt", "DATA")

	print(letter)
	print(number)
	
	umsg.Start("GalaxyMapInitData");
		umsg.String(letter)
		umsg.String(number)
	umsg.End();
end

function ENT:Initialize()
 
	self:SetModel("models/props/cracked/galaxy_map_ig.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
         
    local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetUseType( SIMPLE_USE )

	GalaxyMapSpawn()
end

function ENT:AcceptInput( name, activator, caller )

	if caller:IsAdmin() or caller:GetRegiment() == "Imperial Navy" then	

		if name == "Use" and caller:IsPlayer() then
			net.Start( "igGalaxyMap" )
			net.Send( caller )
		end
	end
end

net.Receive("igGalaxyMapData", function()
	local letter = net.ReadString()
	local number = net.ReadString()

	file.Write("galaxymap/letter.txt", letter)
	file.Write("galaxymap/number.txt", number)

	GalaxyMapSpawn()
end)

hook.Add( "PlayerInitialSpawn", "GalaxyMapPlayerSpawn", function()
	GalaxyMapSpawn()
end )
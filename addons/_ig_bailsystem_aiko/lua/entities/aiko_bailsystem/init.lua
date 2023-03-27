AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

util.AddNetworkString("AikoBailSystem.OpenBailMenu")
util.AddNetworkString("AikoBailSystem.PayBail")
util.AddNetworkString("AikoBailSystem.AddChat")

local currentRFAs = currentRFAs || {}
function ENT:Initialize()
 
	self:SetModel("models/kingpommes/starwars/misc/bridge_console2.mdl")
	--self:SetModel( "models/props_borealis/bluebarrel001.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

end

function ENT:Use( activator, caller )
	PrintTable(currentRFAs)
	if AikoBailSystem.Config.BlacklistedRegiments[activator:GetRegiment()] then
		return activator:ChatPrint("You don't have permissions to use this.")
	end
	if !currentRFAs[caller:SteamID()] then
		return activator:ChatPrint("You aren't RFAd, you don't need to pay bail.")
	end
    net.Start("AikoBailSystem.OpenBailMenu")
	net.WriteString(currentRFAs[caller:SteamID()])
    net.Send(activator)
    return
end

-- Twist's RFA Intergrations :D

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
	"Death Trooper"
}
local rfaclearancelevel = {
	"5",
	"6",
	"ALL ACCESS",
	"CLASSIFIED",
}
hook.Add("Aiko.PlayerRFAd", "RFA Console Intergration", function(officer_steamid, offender_steamid, offence)
    local ply = player.GetBySteamID(officer_steamid)
    if table.HasValue(rfaregiments, ply:GetRegiment()) || table.HasValue(rfaclearancelevel, ply:GetJobTable().Clearance) then
        currentRFAs[offender_steamid] = offence
    end
end)

net.Receive("AikoBailSystem.PayBail", function(len, ply)

	local lastBail = ply.lastBail || 0

    if (lastBail + AikoBailSystem.Config.BailCooldown > CurTime()  &&  !(ply:IsSuperAdmin() || ply:IsDeveloper())) then return end
	local bailindex = net.ReadUInt(8)

	local reason, price = AikoBailSystem.Config.BailReasons[bailindex][1], AikoBailSystem.Config.BailReasons[bailindex][2]

	if price == nil then return end
	if not ply:SH_CanAffordPremium(price) then return end -- Make sure the player can afford bail
	ply:SH_AddPremiumPoints(-1 * price, "You have paid your bail.")
	currentRFAs[ply:SteamID()] = nil

	for k, v in pairs(player.GetAll()) do
		if (AikoBailSystem.Config.AlertedRegiments[v:GetRegiment()] || ( v:IsAdmin() || v:IsDeveloper() )) then
			net.Start("AikoBailSystem.AddChat")
			net.WriteString(reason)
			net.WriteString(ply:Nick())
			net.Send(v)
		end
	end

    ply.lastBail = CurTime()
end)
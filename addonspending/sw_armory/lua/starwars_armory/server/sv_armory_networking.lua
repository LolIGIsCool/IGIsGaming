util.AddNetworkString("Armory_SyncWeapons")
util.AddNetworkString("Armory_BuyWeapons")
util.AddNetworkString("Armory_DeployWeapons")
util.AddNetworkString("Armory_OpenMenu")


function SArmory.Action.SyncData(Player)
	net.Start("Armory_SyncWeapons")
		net.WriteTable(Player.ArmoryWeapons)
	net.Send(Player)
end

net.Receive('Armory_DeployWeapons', function(len, Player)
	local weapon = net.ReadString()
	if not weapon then return end
	for k, v in ipairs( ents.FindInSphere(Player:GetPos(),500) ) do
    if v:GetClass() == "starwars_armor" then
    SArmory.Action.DeployWeapon(Player, weapon)
    end
	end
end)

net.Receive("Armory_BuyWeapons", function(len, Player)
	local weapon = net.ReadString()
	if not weapon then return end
	for k, v in ipairs( ents.FindInSphere(Player:GetPos(),500) ) do
    if v:GetClass() == "starwars_armor" then
	SArmory.Action.PurchaseWeapon(Player, weapon)
    end
    end
end)
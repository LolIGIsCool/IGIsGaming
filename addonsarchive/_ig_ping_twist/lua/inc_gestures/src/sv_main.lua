-- developed for gmod.store
-- from incredible-gmod.ru with love <3
-- https://www.gmodstore.com/market/view/gestures 
util.PrecacheModel("models/hunter/blocks/cube025x025x025.mdl")
util.AddNetworkString("INC_GESTURES/Play")
util.AddNetworkString("INC_GESTURES/Ping")
util.AddNetworkString("INC_GESTURES/Ping-Client")

resource.AddFile("materials/ping/on_my_way.png")
resource.AddFile("materials/ping/general.png")
resource.AddFile("materials/ping/caution.png")
resource.AddFile("materials/ping/attack.png")
resource.AddFile("materials/ping/holding.png")
resource.AddFile("materials/ping/assistance.png")

local bits = 8

local cooldown = {}

net.Receive("INC_GESTURES/Ping", function(len, ply)
    local number = net.ReadInt(32)
    local trace = ply:GetEyeTrace()
    local name = ply:Nick()
    net.Start("INC_GESTURES/Ping-Client")
        net.WriteInt(number, 32)
        net.WriteTable(trace)
        net.WriteString(name)
    net.Send(ply:GetSquadMembers())
end)
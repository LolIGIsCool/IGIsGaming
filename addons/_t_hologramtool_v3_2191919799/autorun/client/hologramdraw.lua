local util_AddNetworkString = SERVER and util.AddNetworkString
local language_Add = CLIENT and language.Add
local net_Start = net.Start
local net_WriteUInt = net.WriteUInt
local net_WriteEntity = net.WriteEntity
local net_Broadcast = SERVER and net.Broadcast
local net_Receive = net.Receive
local pairs = pairs
local table_remove = table.remove
local table_Count = table.Count
local net_Send = SERVER and net.Send

TOOL.Category = "Ace's Tools"
TOOL.Name = "Hologram Maker"
TOOL.Command = nil
TOOL.ConfigName = ""

if SERVER then
    util_AddNetworkString("Eclipse.ShittyHologram.DoThing")
end

local holoEnts = {}

if (CLIENT) then
    language_Add("tool.hologramtool.name", "Hologram Maker")
    language_Add("tool.hologramtool.desc", "Enable/Disable hologram FX on an entity")
    language_Add("tool.hologramtool.0", "Left click to enable/disable hologram FX for the entity you're looking at. Right click to enable/disable hologram FX for yourself.")

    function TOOL.BuildCPanel(pnl)
        pnl:AddControl("Header", {
            Text = "Hologram Tool",
            Description = [[Left-Click to enable/disable hologram FX for the entity you're looking at.
		Right click to enable/disable hologram FX for yourself.
		]]
        })
    end
end

function TOOL:LeftClick(tr)
    if (CLIENT) then return true end
    local bIsHologram = holoEnts[tr.Entity]

    if (tr.Entity:IsValid() and not tr.Entity:IsWorld()) then
        holoEnts[tr.Entity] = not bIsHologram
        net_Start("Eclipse.ShittyHologram.DoThing")
        net_WriteUInt(1, 32)
        net_WriteEntity(tr.Entity)
        net_Broadcast()
        local l = "notification.AddLegacy(\"" .. (bIsHologram and "Disabled " or "Enabled ") .. "hologram FX for \" .. language.GetPhrase(\"#" .. tr.Entity:GetClass() .. "\") .. \".\",0,5);"
        l = l .. "surface.PlaySound(\"buttons/button14.wav\")"
        self:GetOwner():SendLua(l)

        return true
    end
end


if CLIENT then return end

net_Receive("Eclipse.ShittyHologram.DoThing", function(len, ply)
    -- Make sure we're not sending invalid entities
    for k, v in pairs(holoEnts) do
        if not v:IsValid() then
            table_remove(holoEnts, k)
            continue
        end
    end

    net_Start("Eclipse.ShittyHologram.DoThing")
    net_WriteUInt(table_Count(holoEnts), 32)

    for k, v in pairs(holoEnts) do
        net_WriteEntity(v)
    end

    net_Send(ply)
end)
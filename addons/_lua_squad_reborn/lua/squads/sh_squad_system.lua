
SQUAD.Groups = SQUAD.Groups or {}
SQUAD.PlyMeta = FindMetaTable("Player")

if SERVER then
    include("server/sv_squad.lua")
end

function SQUAD:Sync()
end

function SQUAD.PlyMeta:GetSquad()
    if (not SQUAD.Groups) then
        SQUAD.Groups = {}
    end

    return SQUAD.Groups[self:GetSquadName()] or nil
end

function SQUAD.PlyMeta:GetSquadName()
    return self._squad or ""
end

function SQUAD.PlyMeta:SameSquad(ply)
    if (ply:GetSquadName() == "") then return false end
    return ply:GetSquadName() == self:GetSquadName()
end

function SQUAD.PlyMeta:GetSquadMembers()
    if (not self:GetSquad()) then return {} end

    return self:GetSquad().Members or {}
end

function SQUAD.PlyMeta:SendTip(msg, icon, time)
    if SERVER then
        net.Start("Squad.SendTip")
        net.WriteString(msg)
        net.WriteInt(icon or 0, 4)
        net.WriteFloat(time or 3)
        net.Send(self)
    else
        notification.AddLegacy(msg, icon, time)
    end
end

net.Receive("Squad.SendTip", function()
    local msg = net.ReadString()
    local icon = net.ReadInt(4)
    local time = net.ReadFloat()
    LocalPlayer():SendTip(msg, icon, time)
end)

properties.Add( "invitePlayer", {
    MenuLabel = "Invite to Squad", -- Name to display on the context menu
    Order = 1, -- The order to display this property relative to other properties
    MenuIcon = "icon16/group_add.png", -- The icon to display next to the property

    Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
        if not IsValid( ent ) then return false end
        if not ent:IsPlayer() then return false end
        if (ply:GetSquadName() ~= "" and ent:GetSquadName() == "" and ent:GetNWBool("Squad.CanHire", true) and #ply:GetSquadMembers() < SQUAD.Config.MaxMembers) then
            return true
        end
    end,
    Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
        net.Start("Squad.SendInvitation")
        net.WriteEntity(ent)
        net.SendToServer()
    end,
    Receive = function( self, length, player ) -- The action to perform upon using the property ( Serverside )
    end 
} )
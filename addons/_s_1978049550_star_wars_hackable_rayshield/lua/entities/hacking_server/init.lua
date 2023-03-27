AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

util.AddNetworkString("openhackingmenu")
util.AddNetworkString("normalchoice")
util.AddNetworkString("remotechoice")
util.AddNetworkString("playerdead")
function ENT:Initialize()
 
	self:SetModel( "models/props/starwars/tech/cis_ship_switcher.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
    self:SetVar("used", false)
    self:SetVar("isdone", false)
    self:SetUseType( SIMPLE_USE )
    net.Receive("normalchoice", function()
        self:SetVar("used", false)
        self:SetVar("isdone", true)
        local activator = self:GetNWEntity("actindex")
        local ent = self:GetNWEntity("entlinked")
        ent:Remove()
        activator:PrintMessage(HUD_PRINTTALK, "Rayshield has been deactivated")
    end)
    net.Receive("remotechoice", function()
        local activator = self:GetNWEntity("actindex")
        local ent = self:GetNWEntity("entlinked")
        if (activator:HasWeapon("Shield_Disabler")) then
            activator:PrintMessage(HUD_PRINTTALK, "You cant remote control 2 servers at once")
            self:SetVar("used", false)
        else
            activator:Give("Shield_Disabler")
            activator:SetNWEntity("enttodis", ent)
            self:SetVar("used", false)
            self:SetVar("isdone", true)
        end
    end)
end
 
function ENT:Use( activator, caller )
    if (self:GetNWEntity("entlinked") != NULL) then
    if (activator:GetNWBool("isableto")) then
        if (self:GetVar("used")) then
            activator:PrintMessage(HUD_PRINTTALK, "This Server is already being hacked")
        else
            self:SetNWEntity("actindex", activator)
            if (self:GetVar("isdone") == false) then
                net.Start("openhackingmenu", 50, 100, 0.5)
                net.WriteBool( true )
                net.Send(activator)
                CheckAlivestuff(activator)
            else
                activator:PrintMessage(HUD_PRINTTALK, "This Server has already been hacked")
            end
        end
    else
        activator:PrintMessage(HUD_PRINTTALK, "You Dont have hacking tools")
    end
    else
        activator:PrintMessage(HUD_PRINTTALK, "The Server is not linked to any rayshield")
    end
end
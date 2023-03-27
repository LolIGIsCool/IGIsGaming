AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

util.AddNetworkString("IG_DYNAMIC_BOARD_OPEN")
util.AddNetworkString("IG_DYNAMIC_BOARD_EDIT")
util.AddNetworkString("IG_DYNAMIC_BOARD_INIT")

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "Title" )
    self:NetworkVar( "String", 1, "Type" )
    self:NetworkVar( "String", 2, "Clearance" )
    self:NetworkVar( "String", 3, "Clearance2" )
    self:NetworkVar( "Bool", 4, "WorldSpawn" )
end

function ENT:Initialize()
	self:SetModel("models/igmodels/textscreens/black-white.mdl")
	self:SetUseType( SIMPLE_USE )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS )    
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:AcceptInput( name, activator, caller )
	if name == "Use" and caller:IsPlayer() then
		if caller:IsSuperAdmin() then
			net.Start( "IG_DYNAMIC_BOARD_OPEN" )
				net.WriteInt(self:GetCreationID(), 16)
				net.WriteEntity(self)
			net.Send( caller )
		end
	end
end

function ENT:SendToEntity(temp, EntityPort, EntityID)
	self:SetTitle(temp["Title"])
	self:SetType(temp["AreaType"])
	self:SetClearance(temp["FirstClearance"])
	self:SetClearance2(temp["SecondClearance"])
end

net.Receive("IG_DYNAMIC_BOARD_EDIT", function(length, ply)
	if ply:IsSuperAdmin() then
		local temp = net.ReadTable()
		local EntityID = net.ReadInt(16)
		local EntityPort = net.ReadEntity()
		EntityPort:SendToEntity(temp, EntityPort, EntityID)
	end
end)

concommand.Add("ig_savetextscreens", function(player)
    if not (player:IsValid() and player:IsSuperAdmin()) then
        print("You are not a superadmin or you are not a player")
        return
    end
    local tblNPCs = {}
    if (file.Exists("twistscreens/dynamic.txt", "DATA")) then
        local importtable = util.JSONToTable(file.Read("twistscreens/dynamic.txt"))
        if (importtable) then
            for k,v in pairs(importtable) do
            	if importtable[k]["map"] == game.GetMap() then
            	else
            		table.insert(tblNPCs, importtable[k])
            	end
            end
        end
    end
    for _, theentity in pairs(ents.FindByClass("igdynamic")) do
        theentity.Data = {
        	["Title"] = theentity:GetTitle(),
        	["Type"] = theentity:GetType(),
        	["Clearance"] = theentity:GetClearance(),
        	["SecondClearance"] = theentity:GetClearance2(),
            ["pos"] = theentity:GetPos(),
            ["ang"] = theentity:GetAngles(),
            ["map"] = game.GetMap()
        }
        table.insert(tblNPCs, theentity.Data)
    end
    if not file.IsDir("twistscreens", "DATA") then
		print("[IG TextScreens] Creating TextScreens Directory...")
		file.CreateDir("twistscreens")
	end
    file.Write("twistscreens/dynamic.txt", util.TableToJSON(tblNPCs))
    print("Text Screens Saved by: " .. player:Nick())

end)

hook.Add("InitPostEntity", "IG_DYNAMIC_TEXT_SPAWN", function() 
    if (file.Exists("twistscreens/dynamic.txt", "DATA")) then
        local tblNPCs = util.JSONToTable(file.Read("twistscreens/dynamic.txt"))
        if (tblNPCs) then
            for _, dataNPC in pairs(tblNPCs) do
            	if dataNPC["map"] == game.GetMap() then
	                local theentity = ents.Create("igdynamic")
	                theentity:SetPos(dataNPC["pos"])
	                theentity:SetAngles(dataNPC["ang"])
	                theentity:SetTitle(dataNPC["Title"])
	                theentity:SetType(dataNPC["Type"])
	                theentity:SetClearance(dataNPC["Clearance"])
	                theentity:SetClearance2(dataNPC["SecondClearance"])
	                theentity:SetWorldSpawn(true)
	                theentity:Spawn()
	                theentity:SetMoveType(MOVETYPE_NONE)
	            end
            end
        end
    end
end)

concommand.Add("ig_reloadtextscreens", function(player)
    if not (player:IsValid() and player:IsSuperAdmin()) then
        print("You are not a superadmin or you are not a player")
        return
    end

    for _, theentity in pairs(ents.FindByClass("igdynamic")) do
        theentity:Remove()
    end

    if (file.Exists("twistscreens/dynamic.txt", "DATA")) then
        local tblNPCs = util.JSONToTable(file.Read("twistscreens/dynamic.txt"))
        if (tblNPCs) then
            for _, dataNPC in pairs(tblNPCs) do
            	if dataNPC["map"] == game.GetMap() then
	                local theentity = ents.Create("igdynamic")
	                theentity:SetPos(dataNPC["pos"])
	                theentity:SetAngles(dataNPC["ang"])
	                theentity:SetTitle(dataNPC["Title"])
	                theentity:SetType(dataNPC["Type"])
	                theentity:SetClearance(dataNPC["Clearance"])
	                theentity:SetClearance2(dataNPC["SecondClearance"])
	                theentity:SetWorldSpawn(true)
	                theentity:Spawn()
	                theentity:SetMoveType(MOVETYPE_NONE)
	            end
            end
        end
    end
end)
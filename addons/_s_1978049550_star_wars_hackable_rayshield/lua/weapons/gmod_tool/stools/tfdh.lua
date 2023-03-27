TOOL.Category = "Construction"
TOOL.Name = "#Tool.tfdh.name"
TOOL.Command = nil
TOOL.ConfigName = "" 

if ( CLIENT ) then
language.Add( "Tool.tfdh.name" , "Rayshield Link")
language.Add( "Tool.tfdh.desc" , "Left click on the prop you want to make a rayshield and then right click on the hackable server to link it")
language.Add( "Tool.tfdh.0", "Left-click: Select Rayshield | Right-click: link rayshield to server" )
end

local ent = NULL

function TOOL:LeftClick( trace )
	if !trace.Entity || !trace.Entity:IsValid() || trace.Entity:GetClass() != "prop_physics" then return false end
	if ( CLIENT ) then return true end
	ent = trace.Entity
	return true
end
 
function TOOL:RightClick( trace )
	if ( CLIENT ) then return true end
	if (ent != NULL && ent:IsValid()) then
		if !trace.Entity || !trace.Entity:IsValid() || trace.Entity:GetClass() != "hacking_server" then return false end
		local serv = trace.Entity
		serv:SetNWEntity("entlinked", ent)
		ent = NULL
		return true
	else
		local ply = self:GetOwner()
		ply:PrintMessage(HUD_PRINTTALK, "[ERROR] Select a rayshield first")
		return true
	end
end
 
function TOOL.BuildCPanel( panel )
	panel:AddControl("Header", { Text = "Hackable Rayshield tool", Description = "Used to link a prop with the hackable server" })
end
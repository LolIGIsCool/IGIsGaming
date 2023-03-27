-- Why hello there!

TOOL.Category		= "Vanilla"
TOOL.Name			= "Vanilla's Troop Deployment Tool"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.AdminOnly		= true

if ( CLIENT ) then
    language.Add( "Tool.vanilla_troop_deployment_tool.name", "Vanilla's Troop Deployment Tool" )
    language.Add( "Tool.vanilla_troop_deployment_tool.desc", "Deploy troops, in style!" )
    language.Add( "Tool.vanilla_troop_deployment_tool.left", "Target a spot on the floor to summon a ship")
end

TOOL.Information = {

    { name = "left" }

}

TOOL.ClientConVar[ "ship" ] = ""
TOOL.ClientConVar[ "droidcount" ] = "5"
TOOL.ClientConVar[ "droidtype" ] = ""
TOOL.ClientConVar[ "gun" ] = ""
TOOL.ClientConVar[ "health" ] = "50"
TOOL.ClientConVar[ "player" ] = "false"
TOOL.ClientConVar[ "name" ] = ""
TOOL.ClientConVar[ "height" ] = "5000"

function TOOL:LeftClick( trace )
    if (!trace.HitPos) then return false end
    if CLIENT then return true end

    local pos = trace.HitPos
    local ship = self:GetClientInfo("ship")

    local spawnloc = ents.Create("vanilla_spawnlocation")
    spawnloc:SetPos(pos)
    spawnloc:SetMoveType(MOVETYPE_NONE)
    spawnloc:Spawn()

    local shipent = ents.Create("vanilla_ship")
    shipent:SetPos(pos)
    shipent:SetAI(true)
    shipent:SetVar("dest",spawnloc)
    shipent:SetKeyValue("droidcount",self:GetClientInfo("droidcount"))
    shipent:SetKeyValue("droidtype",self:GetClientInfo("droidtype"))
    shipent:SetKeyValue("ship",self:GetClientInfo("ship"))
    shipent:SetKeyValue("gun",self:GetClientInfo("gun"))
    shipent:SetKeyValue("health",self:GetClientInfo("health"))
    shipent:SetKeyValue("player",self:GetClientInfo("player"))
    shipent:SetKeyValue("name",self:GetClientInfo("name"))
    shipent:SetKeyValue("height",self:GetClientInfo("height"))
    shipent:Spawn()

    undo.Create("Ship")
    undo.AddEntity(shipent)
    undo.AddEntity(spawnloc)
    undo.SetPlayer( self:GetOwner() )
    undo.SetCustomUndoText("Undone " .. ship)
    undo.Finish()
    return true
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)

    CPanel:SetName("Vanilla's Troop Deployment Tool")

    CPanel:Help("Version 1.2 [IG]")

    CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "vanilla_troopdeployment_tool", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

    CPanel:TextEntry("Ship Type", "vanilla_troop_deployment_tool_ship")
    CPanel:ControlHelp("Sets which ship to deploy the troops in. (USE A MODEL)")

    CPanel:NumSlider("Troop Count","vanilla_troop_deployment_tool_droidcount",1,50,0)
    CPanel:ControlHelp("Sets the amount of troops to spawn.")

    CPanel:TextEntry("Troop Type", "vanilla_troop_deployment_tool_droidtype")
    CPanel:ControlHelp("Sets the troop type to be spawned. (USE A NPC)")

    CPanel:TextEntry("Weapon", "vanilla_troop_deployment_tool_gun")
    CPanel:ControlHelp("Sets the type of gun the troop will be equipped with.")

    CPanel:NumSlider("Troop Health","vanilla_troop_deployment_tool_health",1,5000,0)
    CPanel:ControlHelp("Sets the amount of health for the troop.")

    CPanel:NumSlider("Spawn Height","vanilla_troop_deployment_tool_height",1,5000,0)
    CPanel:ControlHelp("Sets the spawn height. (2200 for orto plutonia)")

    CPanel:CheckBox("Use Players","vanilla_troop_deployment_tool_player")
    CPanel:ControlHelp("Use players instead of AI [GRABS PEOPLE WITH EVENT JOB]")

    CPanel:TextEntry("Name Starts With", "vanilla_troop_deployment_tool_name")
    CPanel:ControlHelp("Uses players that names start with x.")
end

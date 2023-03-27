-- Why hello there!

TOOL.Category		= "Vanilla"
TOOL.Name			= "Vanilla's Turbolaser Tool"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.AdminOnly		= true

if ( CLIENT ) then
    language.Add( "Tool.turbolaser.name", "Vanilla's Turbolaser Tool" )
    language.Add( "Tool.turbolaser.desc", "Shoot turbolasers" )
    language.Add( "Tool.turbolaser.left", "Shoot a turbolaser from the sky")
    language.Add( "Tool.turbolaser.right", "Shoot a turbolaser from the toolgun")
    language.Add( "Tool.turbolaser.reload", "Creates a turbolaser spawner at your location")
end

TOOL.Information = {

	{ name = "left" },
    { name = "right" },
    { name = "reload"}

}

TOOL.ClientConVar[ "force" ] = "1000"
TOOL.ClientConVar[ "damage" ] = "150"
TOOL.ClientConVar[ "magnitude" ] = "100"
TOOL.ClientConVar["colour"] = "Blue"
TOOL.ClientConVar[ "shots" ] = "3"
TOOL.ClientConVar[ "delay" ] = "0.5"
TOOL.ClientConVar[ "spread" ] = "0"
TOOL.ClientConVar[ "volume" ] = "511"
TOOL.ClientConVar[ "mute" ] = "false"
TOOL.ClientConVar[ "size" ] = "1"

function TOOL:TurboLaser( trace )
    if CLIENT then return true end

	local Force = self:GetClientNumber("force")
	local Damage = self:GetClientNumber("damage")
	local Magnitude = self:GetClientNumber("magnitude")
    local Colour = self:GetClientInfo("colour")
    local Volume = self:GetClientNumber("volume")
    local Mute = self:GetClientInfo("mute")
    local Size = self:GetClientNumber("size")

	if Force < 10 || Force > 10000
	|| Damage < 10 || Damage > 100000
	|| Magnitude < 10 || Magnitude > 500 then
		ply:PrintMessage(HUD_PRINTTALK,"Invalid values")
		return false
	end

	local ent = ents.Create("turbolaser")
	ent:SetKeyValue("Force", Force)
	ent:SetKeyValue("Damage", Damage)
	ent:SetKeyValue("Magnitude", Magnitude)
    ent:SetKeyValue("Colour", Colour)
    ent:SetKeyValue("Volume", Volume)
    ent:SetKeyValue("Mute", Mute)
    ent:SetKeyValue("Size", Size)

	return true, ent
end

function TOOL:LeftClick( trace )
	if self.AdminOnly && !self:GetOwner():IsAdmin() && !self:GetOwner():IsSuperAdmin() then return end
		if (!trace.HitPos) then return false end
		if (CLIENT) then return true end
		local Return, ent = self:TurboLaser( trace )
		if not Return then return false end
		local pos = trace.HitPos
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+( Vector( 0, 0, 1 ) * 5000 )
		tracedata.filter = self:GetOwner()
		local traceB = util.TraceLine(tracedata)
		ent:SetPos( traceB.HitPos + traceB.HitNormal * 16 )
		ent:SetAngles( Vector( 0, 0, -1 ):Angle() )
		ent:Spawn()
		ent:Activate()

		undo.Create( "Turbolaser" )
			undo.AddEntity( ent )
			undo.SetPlayer( self:GetOwner() )
			undo.SetCustomUndoText("Undone Turbolaser")
		undo.Finish()
end

function TOOL:RightClick( trace )
	if self.AdminOnly && !self:GetOwner():IsAdmin() && !self:GetOwner():IsSuperAdmin() then return end
		local Return, ent = self:TurboLaser( trace )
		if (CLIENT) then return false end
		if not Return then return false end
		ent:SetOwner( self:GetOwner() )
		ent:SetPos( self:GetOwner():GetShootPos() )
		ent:SetAngles( self:GetOwner():GetAngles())
		ent:Spawn()
		ent:Activate()

		undo.Create( "Turbolaser" )
			undo.AddEntity( ent )
			undo.SetPlayer( self:GetOwner() )
			undo.SetCustomUndoText("Undone Turbolaser")
		undo.Finish()
end

function TOOL:Reload( trace )
	if self.AdminOnly && !self:GetOwner():IsAdmin() && !self:GetOwner():IsSuperAdmin() then return end
		if (CLIENT) then return false end
		local spawner = ents.Create("turbolaserspawner")
		spawner:SetPos(self:GetOwner():GetShootPos())
		spawner:SetAngles(self:GetOwner():GetAngles())
		spawner:SetKeyValue("Delay",self:GetClientNumber("delay"))
		spawner:SetKeyValue("Shots",self:GetClientNumber("shots"))
		spawner:SetKeyValue("Force",self:GetClientNumber("force"))
		spawner:SetKeyValue("Damage",self:GetClientNumber("damage"))
		spawner:SetKeyValue("Magnitude",self:GetClientNumber("magnitude"))
		spawner:SetKeyValue("Colour",self:GetClientInfo("colour"))
		spawner:SetKeyValue("Spread",self:GetClientNumber("spread"))
        spawner:SetKeyValue("Volume",self:GetClientNumber("volume"))
        spawner:SetKeyValue("Mute",self:GetClientInfo("mute"))
        spawner:SetKeyValue("Size",self:GetClientNumber("size"))
		spawner:Spawn()
		spawner:Activate()

		undo.Create("Spawner")
			undo.AddEntity(spawner)
			undo.SetPlayer(self:GetOwner())
			undo.SetCustomUndoText("Undone Turbolaser Spawner")
		undo.Finish()
end

function TOOL:Think()
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)
    CPanel:SetName("Vanilla's Turbolaser Tool")

    CPanel:Help("Version 1.7b")

    CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "turbolaser", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

    CPanel:NumSlider("Speed","turbolaser_force","10","10000","0")
    CPanel:ControlHelp("Sets the speed of the turbolaser.")

    CPanel:NumSlider("Damage","turbolaser_damage","10","1000","0")
    CPanel:ControlHelp("Sets the damage of the turbolaser.")

    CPanel:NumSlider("Damage Radius","turbolaser_magnitude","10","500","0")
    CPanel:ControlHelp("Sets the radius of the turbolaser's explosion.")

    local Colour = CPanel:ComboBox("Colour", "turbolaser_colour")
    Colour:AddChoice("Blue")
    Colour:AddChoice("Red")
    Colour:AddChoice("Green")
    Colour:AddChoice("Orange")
    Colour:AddChoice("Yellow")
    Colour:AddChoice("Pink")
    Colour:AddChoice("Black")
    CPanel:ControlHelp("Sets the colour of the turbolaser.")

    CPanel:NumSlider("Number of Shots","turbolaser_shots","1","50","0")
    CPanel:ControlHelp("Sets the number of shots for the turbolaser spawner.")

    CPanel:NumSlider("Delay between Shots","turbolaser_delay","0.1","5","1")
    CPanel:ControlHelp("Sets the delay between shots for the turbolaser spawner. (In seconds)")

    CPanel:NumSlider("Spread","turbolaser_spread","0","10","1")
    CPanel:ControlHelp("Sets spread of the turbolasers spawned from the turbolaser spawner.")

    CPanel:NumSlider("Explosion Sound Distance","turbolaser_volume","1","511","0")
    CPanel:ControlHelp("Sets the sound distance of the turbolaser explosion.")

    CPanel:CheckBox("Mute Explosion","turbolaser_mute")
    CPanel:ControlHelp("Determines if the explosion sound should be muted.")

    CPanel:NumSlider("Turbolaser Scale","turbolaser_size","0.1","5","2")
    CPanel:ControlHelp("Sets the scale of the turbolaser. (<0.9 makes it smaller)")
end

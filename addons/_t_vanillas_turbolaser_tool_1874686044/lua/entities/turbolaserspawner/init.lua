AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
    self.VanillaTimer = tostring(self:EntIndex() .. self:GetName())
    self:Spawner()
end

function ENT:KeyValue(key,value)
    if key == "Delay" then
        self.Delay = tonumber(value)
    end
    if key == "Shots" then
        self.Shots = tonumber(value)
    end
    if key == "Force" then
        self.Force = tonumber(value)
    end
    if key == "Damage" then
        self.Damage = tonumber(value)
    end
    if key == "Magnitude" then
        self.Magnitude = tonumber(value)
    end
    if key == "Colour" then
        self.Colour = value
    end
    if key == "Spread" then
        self.Spread = tonumber(value)
    end
    if key == "Volume" then
        self.Volume = tonumber(value)
    end
    if key == "Mute" then
        self.Mute = value
    end
    if key == "Size" then
        self.vSize = tonumber(value)
    end
end

function ENT:TurboLaser( trace )

	local Force = self.Force
	local Damage = self.Damage
	local Magnitude = self.Magnitude
    local Colour = self.Colour
    local Volume = self.Volume
    local Mute = self.Mute
    local Size = self.vSize

	if Force < 10 || Force > 10000
	|| Damage < 10 || Damage > 1000
	|| Magnitude < 10 || Magnitude > 500 then
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

function ENT:Spawner()
    timer.Create(self.VanillaTimer,self.Delay,self.Shots,function()
        local Return, ent = self:TurboLaser( trace )
        if not Return then return false end
        ent:SetPos(self:GetPos())
        local SpreadChooser = math.random(0,1)
        if SpreadChooser == 1 then ent:SetAngles(self:GetAngles() + Angle(math.random(0,self.Spread),math.random(0,self.Spread),0)) end
        if SpreadChooser == 0 then ent:SetAngles(self:GetAngles() - Angle(math.random(0,self.Spread),math.random(0,self.Spread),0)) end
        ent:Spawn()
        ent:Activate()
    end)
end

function ENT:Think()
    if not timer.Exists(self.VanillaTimer) then
        self:Remove()
    end
end

function ENT:OnRemove()
    timer.Remove(self.VanillaTimer)
end

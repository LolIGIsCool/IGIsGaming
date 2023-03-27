--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:Initialize()
end

function ENT:ExhaustFX()
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
end

function ENT:EngineActiveChanged( bActive )
end

function ENT:OnRemove()
end

function ENT:SoundStop()
end

function ENT:AnimFins()
	local Driver = self:GetDriver()
	local Gunner = self:GetGunner()
	
	local HasGunner = IsValid( Gunner )
	
	if not IsValid( Driver ) and not HasGunner then return end
	
	if HasGunner then Driver = Gunner end
	
	local EyeAngles = self:WorldToLocalAngles( Driver:EyeAngles() )
	EyeAngles:RotateAroundAxis( EyeAngles:Up(), 0 )
	
	local Yaw = math.Clamp( EyeAngles.y,-180,180)
	local Pitch = math.Clamp( EyeAngles.p,-90,20 )
	
	self:ManipulateBoneAngles( 3, Angle(0,0,Pitch) )
	self:ManipulateBoneAngles( 2, Angle(0,Yaw,0) )
end


function ENT:AnimRotor()
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
end

local mat = Material( "sprites/light_glow02_add" )
function ENT:Draw()
	self:DrawModel()
	render.SetMaterial( mat )
end


--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:Initialize()
	self.Turret = ents.CreateClientProp()
	self.Turret:SetModel("models/kingpommes/starwars/deathstar/xx9c_static.mdl")
	self.Turret:SetModelScale(0.5)
	self.Turret:SetPos(Vector(420,0,-4945))
	self.Turret:SetAngles(Angle(0,0,0))
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	return self:LFSCalcViewThirdPerson( view )
end

function ENT:LFSCalcViewThirdPerson( view )
	local ply = LocalPlayer()
	if not IsValid( ply:GetVehicle() ) then return view end

	local radius = 0
	//radius = radius + 400 + 400 * ply:GetVehicle():GetCameraDistance()

	local TargetOrigin = Vector(550,0,-4945) - view.angles:Forward()/* * radius  + view.angles:Up() * radius * 0.2*/
	local WallOffset = 4

	local tr = util.TraceHull( {
		start = Vector(550,0,-4945),
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS

			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )

	view.origin = /*Vector(600,0,-4945)*/ tr.HitPos

	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	/*view.origin = Vector(600,0,-4945)
	view.angles = Angle(0,0,0)*/
	return view
end

function ENT:ExhaustFX()
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
end

function ENT:EngineActiveChanged( bActive )
end

function ENT:OnRemove()
	self:SoundStop()
	self.Turret:Remove()
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

	local Yaw = math.Clamp( EyeAngles.y,-45,45)
	local Pitch = math.Clamp( EyeAngles.p,0,45 )

	/*self.Turret:ManipulateBoneAngles( 0, Angle(0,Yaw,0) )
	self.Turret:ManipulateBoneAngles( 0, Angle(0,0,Pitch) )*/
	self.Turret:SetAngles(Angle(Pitch,Yaw,0))
end


function ENT:AnimRotor()
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
end

function ENT:Draw()
	self:DrawModel()
end

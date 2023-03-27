AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
local FLASH_INTENSITY = 3000
function ENT:Initialize()
	
	self.Entity:SetModel("models/forrezzur/flashgrenade.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	--self.Entity:PhysicsInitSphere( ( self:OBBMaxs() - self:OBBMins() ):Length()/4, "metal" )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self:EmitSound("weapons/tfa_starwars/Shock_Charge_01.wav")
	
	self.timeleft = CurTime() + 1.5 -- HOW LONG BEFORE EXPLOSION	
	self:Think()
end

 function ENT:Think()
	
	if self.timeleft < CurTime() and !self.deactivated then
		self:Explode()	
		self:Remove()
	end

	self.Entity:NextThink( CurTime() )
	return true
end

function ENT:EntityFacingFactor( theirent )
	local dir = theirent:EyeAngles():Forward()
	local facingdir = (self:GetPos() - (theirent.GetShootPos and theirent:GetShootPos() or theirent:GetPos())):GetNormalized()
	return (facingdir:Dot(dir)+1)/2
end

function ENT:EntityFacingUs( theirent )
	local dir = theirent:EyeAngles():Forward()
	local facingdir = (self:GetPos()-(theirent.GetShootPos and theirent:GetShootPos() or theirent:GetPos())):GetNormalized()
	if facingdir:Dot(dir)>-0.25 then return true end
end

function FlashEffect() if LocalPlayer():GetNetworkedFloat("FLASHED_END") > CurTime() then

		local pl 			= LocalPlayer();
		local FlashedEnd 		= pl:GetNetworkedFloat("FLASHED_END")
		local FlashedStart 	= pl:GetNetworkedFloat("FLASHED_START")
		
		local Alpha

		if(FlashedEnd - CurTime() > FLASHTIMER) then
			Alpha = 150;
		else
			local FlashAlpha = 1 - (CurTime() - (FlashedEnd - FLASHTIMER)) / (FlashedEnd - (FlashedEnd - FLASHTIMER));
			Alpha = FlashAlpha * 150;
		end
		
			surface.SetDrawColor(255, 255, 255, math.Round(Alpha))
			surface.DrawRect(0, 0, surface.ScreenWidth(), surface.ScreenHeight())
		end 
	end
	
hook.Add("HUDPaint", "FlashEffect", FlashEffect);

function ENT:Explode()

	self.Entity:EmitSound(Sound("Flashbang.Explode"));

	for _,pl in pairs(player.GetAll()) do

		local ang = (self.Entity:GetPos() - pl:GetShootPos()):GetNormalized():Angle()

		local tracedata = {};

		tracedata.start = pl:GetShootPos();
		tracedata.endpos = self.Entity:GetPos();
		tracedata.filter = pl;
		local tr = util.TraceLine(tracedata);
		if (!tr.HitWorld and self:EntityFacingUs(pl)) then
			local dist = pl:GetShootPos():Distance( self.Entity:GetPos() )
			local endtime = FLASH_INTENSITY / (dist * 2);
			if (endtime > 6) then
				endtime = 6;
			elseif (endtime < 1) then
				endtime = 0;
			end
			
			simpendtime = math.floor(endtime);
			tenthendtime = math.floor((endtime - simpendtime) * 10);

--			if (pl:GetNetworkedFloat("FLASHED_END") > CurTime()) then
--				pl:SetNetworkedFloat("FLASHED_END", endtime + pl:GetNetworkedFloat("FLASHED_END") + CurTime() - pl:GetNetworkedFloat("FLASHED_START"));
--			else
				pl:SetNetworkedFloat("FLASHED_END", endtime + CurTime());
--			end
			
			pl:SetNetworkedFloat("FLASHED_END_START", CurTime());
			pl:SetDSP(35)
		end
	end
	self.Entity:Remove();
end
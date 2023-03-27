ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Type = "vehicle"
ENT.Base = "fighter_base"

ENT.PrintName = "Geonosian Fighter"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: CIS"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.EntModel = "models/geon/geon1.mdl"
ENT.Vehicle = "Geonosis"
ENT.StartHealth = 500;
ENT.Allegiance = "CIS";
list.Set("SWVehicles", ENT.PrintName, ENT);


if SERVER then

ENT.FireSound = Sound("weapons/xwing_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),FireMode = CurTime(),};


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("geonosis");
	e:SetPos(tr.HitPos + Vector(0,0,5));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	
	self:SetNWInt("Health",self.StartHealth);
	self.CanRoll = true;
	self.WeaponLocations = {
		Main = self:GetPos()+self:GetForward()*250+self:GetUp()*55,
	}
	self.WeaponsTable = {};
	self.BoostSpeed = 2750;
	self.ForwardSpeed = 1800;
	self.UpSpeed = 750;
	self.AccelSpeed = 10;
	self.CanStandby = true;
	self.CanBack = false;
	self.CanRoll = true;
	self.CanStrafe = false;
	self.Cooldown = 2;
	self.HasLookaround = true;
	self.CanShoot = true;
	self.Bullet = CreateBulletStructure(100,"red");
	self.FireDelay = 0.2;

	self.BaseClass.Initialize(self)
end

end

if CLIENT then
	
	ENT.EnginePos = {}
	ENT.Sounds={
		Engine=Sound("ambient/atmosphere/ambience_base.wav"),
	}
	ENT.CanFPV = true;
	
	function ENT:FlightEffects()
		local normal = (self:GetForward() * -1):GetNormalized()
		local roll = math.Rand(-90,90)
		local p = LocalPlayer()		
		local FWD = self:GetForward();
		local id = self:EntIndex();

		for k,v in pairs(self.EnginePos) do
			local heat = self.FXEmitter:Add("sprites/heatwave",v)
			heat:SetVelocity(normal)
			heat:SetDieTime(0.05)
			heat:SetStartAlpha(255)
			heat:SetEndAlpha(255)
			heat:SetStartSize(15)
			heat:SetEndSize(10)
			heat:SetRoll(roll)
			heat:SetColor(255,100,100)
			
		end
	
	end
	
	function ENT:Think()
		self.BaseClass.Think(self);
		
		local p = LocalPlayer();
		local Flying = self:GetNWBool("Flying".. self.Vehicle);
		local TakeOff = self:GetNWBool("TakeOff");
		local Land = self:GetNWBool("Land");
		if(Flying) then
			self.EnginePos = {
				self:GetPos()+self:GetForward()*-100+self:GetUp()*50,
			}

			if(!TakeOff and !Land) then
				self:FlightEffects();
			end
		end
		
		
	end
	
	hook.Add("ScoreboardShow","GeonosisScoreDisable", function()
		local p = LocalPlayer();	
		local Flying = p:GetNWBool("FlyingGeonosis");
		if(Flying) then
			return false;
		end
	end)
	
    ENT.ViewDistance = 500;
    ENT.ViewHeight = 150;
    ENT.FPVPos = Vector(-47.5,0,92.5);

	function GeonosisReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingGeonosis");
		local self = p:GetNWEntity("Geonosis");
		if(Flying and IsValid(self)) then
			SW_HUD_DrawHull(500);
			SW_WeaponReticles(self);
			SW_HUD_DrawOverheating(self);
			
			local pos = self:GetPos()+self:GetUp()*85+self:GetForward()*-20;
			local x,y = SW_XYIn3D(pos);
			
			SW_HUD_Compass(self,x,y);
			SW_HUD_DrawSpeedometer();	
		end
	end
	hook.Add("HUDPaint", "GeonosisReticle", GeonosisReticle)

end
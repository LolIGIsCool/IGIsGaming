
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Type = "vehicle"
ENT.Base = "fighter_base"

ENT.PrintName = "T-47 Airspeeder"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Rebels"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

//ENT.EntModel = "models/snowspeeder/snowspeeder1.mdl"
ENT.EntModel = "models/aitd/Snow Speeder.mdl"
ENT.Vehicle = "SnowSpeeder"
ENT.StartHealth = 1000;
ENT.Allegiance = "Rebels";
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.FireSound = Sound("weapons/xwing_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),FireMode = CurTime(),};


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("snowspeeder");
	e:SetPos(tr.HitPos + Vector(0,0,5));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	
	self:SetNWInt("Health",self.StartHealth);
	self.CanRoll = false;
	self.CanStrafe = true;
	self.WeaponLocations = {
		Right = self:GetPos()+self:GetUp()*45+self:GetForward()*170+self:GetRight()*55,
		Left = self:GetPos()+self:GetUp()*45+self:GetForward()*170+self:GetRight()*-55,
	}
	self.WeaponsTable = {};
	self:SpawnWeapons();
	self.BoostSpeed = 1500;
	self.ForwardSpeed = 850;
	self.UpSpeed = 550;
	self.AccelSpeed = 7;
	self.CanStandby = true;
	self.Bullet = CreateBulletStructure(90,"red");
	self.FireDelay = 0.3;
	self.CanShoot = true;
	self.HasLookaround = true;
	
	
	//self.PilotVisible = true;
	//self.PilotPosition = {x=0,y=45,z=40}

	self.BaseClass.Initialize(self)
end

end

if CLIENT then

	function ENT:Draw() self:DrawModel() end
	
	ENT.EnginePos = {}
	ENT.Sounds={
		Engine=Sound("vehicles/snowspeeder/snowspeeder_engine.wav"),
	}

	ENT.CanFPV = true;
	
	hook.Add("ScoreboardShow","SnowSpeederScoreDisable", function()
		local p = LocalPlayer();	
		local Flying = p:GetNWBool("FlyingSnowSpeeder");
		if(Flying) then
			return false;
		end
	end)
	
    ENT.ViewDistance = 700;
    ENT.ViewHeight = 200;
    ENT.FPVPos = Vector(45,0,67.5);
	local View = {}
	function CalcView()
		
		local p = LocalPlayer();
		local self = p:GetNetworkedEntity("SnowSpeeder", NULL)
		if(IsValid(self)) then
			local fpvPos = self:GetPos()+self:GetUp()*67.5+self:GetForward()*45;	
			View = SWVehicleView(self,700,200,fpvPos,true);		
			return View;
		end
	end
	hook.Add("CalcView", "SnowSpeederView", CalcView)
	

	function SnowSpeederReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingSnowSpeeder");
		local self = p:GetNWEntity("SnowSpeeder");
		if(Flying and IsValid(self)) then
			SW_HUD_DrawHull(1000);
			SW_WeaponReticles(self);
			SW_HUD_DrawOverheating(self);
			
			local pos = self:GetPos()+self:GetUp()*60+self:GetForward()*60+self:GetRight()*-10;
			local x,y = SW_XYIn3D(pos);
			
			SW_HUD_Compass(self,x,y);
			SW_HUD_DrawSpeedometer();	
		end
	end
	hook.Add("HUDPaint", "SnowSpeederReticle", SnowSpeederReticle)

end
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Type = "vehicle"
ENT.Base = "fighter_base"

ENT.PrintName = "Blockade Runner"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Rebels"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = true;
ENT.AdminOnly = true;

ENT.EntModel = "models/blockrun/blockaderunner.mdl"
ENT.Vehicle = "Blockade"
ENT.StartHealth = 6000;
ENT.Allegiance = "Rebels"
list.Set("SWVehicles", ENT.PrintName, ENT);
if SERVER then

ENT.FireSound = Sound("vehicles/mf/mf_shoot2.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),FireMode = CurTime(),LightSpeed=CurTime(),Switch=CurTime(),};
ENT.HyperDriveSound = Sound("vehicles/hyperdrive.mp3");

AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("blockade");
	e:SetPos(tr.HitPos + Vector(0,0,10));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	
	self:SetNWInt("Health",self.StartHealth);
	self:SetNWInt("LightSpeed",0);
	self.CanRoll = false;
	self.CanStrafe = true;
	self.CanBack = true;
	self.CanStandby = true;

	self.WeaponsTable = {};
	//self:SpawnWeapons();
	self.BoostSpeed = 2500;
	self.ForwardSpeed = 1000;
	self.UpSpeed = 600;
	self.AccelSpeed = 8;
	
	self.OGForward = 1000;
	self.OGBoost = 2500;
	self.OGUp = 600;
	
	self.HasLightspeed = true;
	
	self.Bullet = CreateBulletStructure(300,"red");
	self.WeaponLocations = {}
	
	self.PilotOffset = {x=0,y=200,z=200};
	self.ExitModifier = {x=300,y=0,z=20}; 
	//self:SetModelScale(5);
	
	
	self.HasSeats = true;
    self.DisableThirdpersonSeats = true;
	self.SeatPos = {
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*150,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*150+self:GetRight()*50,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*150+self:GetRight()*100,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*150+self:GetRight()*150,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*150+self:GetRight()*-50,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*150+self:GetRight()*-100,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*150+self:GetRight()*-150,self:GetAngles(),Vector(300,0,0)},
		
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*150,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*150+self:GetRight()*50,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*150+self:GetRight()*100,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*150+self:GetRight()*150,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*150+self:GetRight()*-50,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*150+self:GetRight()*-100,self:GetAngles(),Vector(300,0,0)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*150+self:GetRight()*-150,self:GetAngles(),Vector(300,0,0)},
	}
    self.BaseClass.Initialize(self)
end


end

if CLIENT then

	function ENT:Draw() self:DrawModel() end
	
	ENT.EnginePos = {}
	ENT.Sounds={
		Engine=Sound("vehicles/mf/mf_fly5.wav"),
	}
	
	local Health = 0;
	ENT.NextView = CurTime();
	local LightSpeed = 0;
	function ENT:Think()
		self.BaseClass.Think(self);
		
		local p = LocalPlayer();
		local Flying = self:GetNWBool("Flying".. self.Vehicle);
		local IsFlying = p:GetNWBool("Flying"..self.Vehicle);
		local Wings = self:GetNWBool("Wings");
		local TakeOff = self:GetNWBool("TakeOff");
		local Land = self:GetNWBool("Land");
		
		if(Flying) then
			if(!TakeOff and !Land) then
				self:FlightEffects();
			end
			Health = self:GetNWInt("Health");
			LightSpeed = self:GetNWInt("LightSpeed");
		end

	end
	
    ENT.ViewDistance = 1500;
    ENT.ViewHeight = 650;
	
	function ENT:FlightEffects()
		local normal = (self:GetForward() * -1):GetNormalized()
		local roll = math.Rand(-90,90)
		local p = LocalPlayer()		
		local FWD = self:GetForward();
		local id = self:EntIndex();
		
		self.EnginePos = {
			self:GetPos()+self:GetForward()*-730+self:GetUp()*195+self:GetRight()*3,
			self:GetPos()+self:GetForward()*-730+self:GetUp()*195+self:GetRight()*147,
			self:GetPos()+self:GetForward()*-730+self:GetUp()*195+self:GetRight()*-142,
			
			self:GetPos()+self:GetForward()*-730+self:GetUp()*315+self:GetRight()*-212,
			self:GetPos()+self:GetForward()*-730+self:GetUp()*315+self:GetRight()*-67,
			self:GetPos()+self:GetForward()*-730+self:GetUp()*315+self:GetRight()*67,
			self:GetPos()+self:GetForward()*-730+self:GetUp()*315+self:GetRight()*212,
			
			self:GetPos()+self:GetForward()*-730+self:GetUp()*70+self:GetRight()*-212,
			self:GetPos()+self:GetForward()*-730+self:GetUp()*70+self:GetRight()*-67,
			self:GetPos()+self:GetForward()*-730+self:GetUp()*70+self:GetRight()*67,
			self:GetPos()+self:GetForward()*-730+self:GetUp()*70+self:GetRight()*212,

		}
		for k,v in pairs(self.EnginePos) do
				
			local blue = self.FXEmitter:Add("sprites/bluecore",v)
			blue:SetVelocity(normal)
			blue:SetDieTime(0.03)
			blue:SetStartAlpha(255)
			blue:SetEndAlpha(255)
			blue:SetStartSize(80)
			blue:SetEndSize(30)
			blue:SetRoll(roll)
			blue:SetColor(255,255,255)
			
			local dynlight = DynamicLight(id + 4096 * k);
			dynlight.Pos = v;
			dynlight.Brightness = 5;
			dynlight.Size = 250;
			dynlight.Decay = 1024;
			dynlight.R = 100;
			dynlight.G = 100;
			dynlight.B = 255;
			dynlight.DieTime = CurTime()+1;
			
		end
	
	end
	
	function BlockadeReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingBlockade");
		local self = p:GetNWEntity("Blockade");
		
		if(Flying and IsValid(self)) then
			SW_HUD_DrawHull(6000);
			SW_HUD_Compass(self);
			SW_HUD_DrawSpeedometer();
		end

	end
	hook.Add("HUDPaint", "BlockadeReticle", BlockadeReticle)

end
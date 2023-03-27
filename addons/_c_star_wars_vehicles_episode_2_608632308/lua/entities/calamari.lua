
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Base = "fighter_base"
ENT.Type = "vehicle"

ENT.PrintName = "Mon Calamari Cruiser"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Rebels"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.AdminOnly = true;
ENT.Allegiance = "Rebels"
ENT.EntModel = "models/swbf3/vehicles/reb_mcalamari_hangar.mdl"
ENT.Vehicle = "Calamari"
ENT.StartHealth = 45000;
ENT.DontLock = true;
ENT.IsCapitalShip = true;
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.FireSound = Sound("weapons/xwing_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),LightSpeed=CurTime(),Switch=CurTime(),};
ENT.HyperDriveSound = Sound("vehicles/hyperdrive.mp3");

AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("calamari");
	e:SetPos(tr.HitPos + Vector(0,0,1000));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()


	self:SetNWInt("Health",self.StartHealth);
	
	self.WeaponLocations = {
		Left = self:GetPos()+self:GetForward()*100+self:GetUp()*70+self:GetRight()*-70,
		Right = self:GetPos()+self:GetForward()*100+self:GetUp()*70+self:GetRight()*70,
	}
	self.WeaponsTable = {};
	self.BoostSpeed = -350;
	self.ForwardSpeed = -250;
	self.UpSpeed = 150;
	self.AccelSpeed = 8;
	self.CanStandby = true;
	self.CanBack = true;
	self.CanRoll = false;
	self.CanStrafe = false;
	self.Cooldown = 2;
	self.HasWings = false;
	self.CanShoot = false;
	self.Bullet = CreateBulletStructure(75,"red");
	self.FireDelay = 0.15;
	self.WarpDestination = Vector(0,0,0);
	if(WireLib) then
		Wire_CreateInputs(self, { "Destination [VECTOR]", })
	else
		self.DistanceMode = true;
	end
	
	self.OGForward = 150;
	self.OGBoost = 100;
	self.OGUp = 100;

	self.ExitModifier = {x=0,y=-2500,z=600};

	self.BaseClass.Initialize(self);

	self:SetBodygroup(1,1)
	self:GetPhysicsObject():SetMass(10000000)
	self:GetPhysicsObject():EnableGravity(false);
	self:GetPhysicsObject():EnableDrag(false);
end

function ENT:TestLoc(pos)
	
	local e = ents.Create("prop_physics");
	e:SetPos(pos);
	e:SetModel("models/props_borealis/bluebarrel001.mdl");
	e:SetParent(self);
	e:Spawn();
	e:Activate();

end

function ENT:StartLightSpeed()
	self.LightspeedPassengers = {};
	self.LightSpeed = true;
	self.LightSpeedTimer = CurTime() + 3;
	self.NextUse.LightSpeed = CurTime() + 20;
	local mb,mb2 = self:GetModelBounds();
	for k,v in pairs(ents.FindInBox(self:LocalToWorld(mb),self:LocalToWorld(mb2))) do
		if(v.IsSWVehicle and v!=self) then
		
			v.BeingWarped = true;
			v.ReturnToStandby = v.CanStandby;
			v.CanStandby = false;
			
			v:SetParent(self);
			if(v:GetClass() == "x-wing") then
				v:RemoveLandingGear();
			end
			
			self.LightspeedPassengers[k] = v;
		end
	end
end


function ENT:Think()

	local mb,mb2 = self:GetModelBounds();
	for k,v in pairs(ents.FindInBox(self:LocalToWorld(mb),self:LocalToWorld(mb2))) do
		if(v.IsSWVehicle and v != self) then
			local Health = v:GetNWInt("Health");
			if(Health<v.StartHealth) then
				nHealth = v.VehicleHealth+5;
				v:SetNWInt("Health",nHealth);
				v.VehicleHealth = nHealth
				if(IsValid(v.Pilot)) then
					v.Pilot:SetNWInt("SW_Health",v.VehicleHealth);
				end
			end
			v.Land = false;
			v.TakeOff = false;
			v.Docked = true;
			local phys = v:GetPhysicsObject();
			if(IsValid(phys)) then
				phys:SetMass(10000);
			end
		end
	end

	
	if(self.Inflight) then
		if(IsValid(self.Pilot)) then
		
			if(self.Pilot:KeyDown(IN_WALK) and self.NextUse.LightSpeed < CurTime()) then
				if(!self.LightSpeed and !self.HyperdriveDisabled) then
					self:StartLightSpeed();
				end
			end

			
			if(WireLib) then
				if(self.Pilot:KeyDown(IN_RELOAD) and self.NextUse.Switch < CurTime()) then
					if(!self.DistanceMode) then
						self.DistanceMode = true;
						self.Pilot:ChatPrint("LightSpeed Mode: Distance");
					else
						self.DistanceMode = false;
						self.Pilot:ChatPrint("LightSpeed Mode: Destination");
					end
					self.NextUse.Switch = CurTime() + 1;
				end
			end
			
		end
		if(self.LightSpeed) then
			if(self.DistanceMode) then
				self:PunchingIt(self:GetPos()+self:GetForward()*-15000);
			else
				self:PunchingIt(self.WarpDestination);
			end
		end
	end
	
	self.BaseClass.Think(self);
end

function ENT:PunchingIt(Dest)
	if(!self.PunchIt) then
		if(self.LightSpeedTimer > CurTime()) then
			self.ForwardSpeed = 0;
			self.BoostSpeed = 0;
			self.UpSpeed = 0;
			self.Accel.FWD = 0;
			self:SetNWInt("LightSpeed",1);
			for k,v in pairs(self.LightspeedPassengers) do
				if(IsValid(v)) then
					v:SetNWInt("LightSpeed",1);
				end
			end
			if(!self.PlayedSound) then
				self:EmitSound(self.HyperDriveSound,100);
				self.PlayedSound = true;
			end
			//util.ScreenShake(self:GetPos()+self:GetForward()*-730+self:GetUp()*195+self:GetRight()*3,5,5,10,5000)
		else
			self.Accel.FWD = -5000;
			self.LightSpeedWarp = CurTime()+0.5;
			self.PunchIt = true;
			self:SetNWInt("LightSpeed",2);
			for k,v in pairs(self.LightspeedPassengers) do
				if(IsValid(v)) then
					v:SetNWInt("LightSpeed",2);
				end
			end
		end
	
	else
		if(self.LightSpeedWarp < CurTime()) then
			
			self.LightSpeed = false;
			self.PunchIt = false;
			self.ForwardSpeed = self.OGForward;
			self.BoostSpeed = self.OGBoost;
			self.UpSpeed = self.OGUp;
			self:SetNWInt("LightSpeed",0);
			local fx = EffectData()
				fx:SetOrigin(self:GetPos())
				fx:SetEntity(self)
			util.Effect("propspawn",fx)
			self:EmitSound("ambient/levels/citadel/weapon_disintegrate2.wav", 500)
			
			
			self.Accel.FWD = 0;
			
			self:SetPos(Dest);
			local mb,mb2 = self:GetModelBounds();
			for k,v in pairs(self.LightspeedPassengers) do
				if(IsValid(v) and v.IsSWVehicle and v != self) then
					local fx = EffectData()
						fx:SetOrigin(v:GetPos())
						fx:SetEntity(v)
					util.Effect("propspawn",fx)
					
					v:SetParent(NULL);
					if(v:GetClass() == "x-wing") then
						v:SpawnLandingGear();
					end
					v.BeingWarped = false;
					if(v.ReturnToStandby) then
						v.CanStandby = true;
					end
					v:SetNWInt("LightSpeed",0);
				end
			end
			
			
			self.PlayedSound = false;
			
		end
	end
end

function ENT:TriggerInput(k,v)
	if(k == "Destination") then
		self.WarpDestination = v;
	end
end

local FlightPhys = {
	secondstoarrive	= 1;
	maxangular		= 5000;
	maxangulardamp	= 10000;
	maxspeed			= 1000000;
	maxspeeddamp		= 500000;
	dampfactor		= 0.8;
	teleportdistance	= 5000;
};
local ZAxis = Vector(0,0,1);
function ENT:PhysicsSimulate(phys,delta)
	local FWD = self:GetForward()*-1;
	local UP = ZAxis;
	local RIGHT = FWD:Cross(UP):GetNormalized();
	if(self.Inflight) then
		phys:Wake();
		if(self.Pilot:KeyDown(IN_FORWARD) and (self.Wings or self.Pilot:KeyDown(IN_SPEED))) then
			self.num = self.BoostSpeed;
		elseif(self.Pilot:KeyDown(IN_FORWARD)) then
			self.num = self.ForwardSpeed;
		elseif(self.Pilot:KeyDown(IN_BACK) and self.CanBack) then
			self.num = (self.ForwardSpeed / 2)*-1;
		else
			self.num = 0;
		end

		self.Accel.FWD = math.Approach(self.Accel.FWD,self.num,self.Acceleration);
		
		if(self.Pilot:KeyDown(IN_MOVERIGHT)) then
			self.TurnYaw = -7.5;
		elseif(self.Pilot:KeyDown(IN_MOVELEFT)) then
			self.TurnYaw = 7.5;
		else
			self.TurnYaw = 0;
		end
		//local ang = self:GetAngles() + self.TurnYaw;
		
		if(self.Pilot:KeyDown(IN_JUMP)) then
			self.num3 = self.UpSpeed;
		elseif(self.Pilot:KeyDown(IN_DUCK)) then
			self.num3 = -self.UpSpeed;
		else
			self.num3 = 0;
		end
		self.Accel.UP = math.Approach(self.Accel.UP,self.num3,self.Acceleration*0.9);
		
		--######### Do a tilt when turning, due to aerodynamic effects @aVoN
		local velocity = self:GetVelocity();
		local aim = self.Pilot:GetAimVector();
		//local ang = aim:Angle();
		
		/*
		local weight_roll = (phys:GetMass()/1000)/1.5
		local pos = self:GetPos()
		local ExtraRoll = math.Clamp(math.deg(math.asin(self:WorldToLocal(pos).y)),-25-weight_roll,25+weight_roll); -- Extra-roll - When you move into curves, make the shuttle do little curves too according to aerodynamic effects
		local mul = math.Clamp((velocity:Length()/1700),0,1); -- More roll, if faster.
		local oldRoll = ang.Roll;
		ang.Roll = (ang.Roll + self.Roll - ExtraRoll*mul) % 360;
		if (ang.Roll!=ang.Roll) then ang.Roll = oldRoll; end -- fix for nan values that cause despawing/crash.
		*/
	
		FlightPhys.angle = Angle(0,self:GetAngles().y + self.TurnYaw,0); --+ Vector(90 0, 0)
		FlightPhys.deltatime = deltatime;
		if(self.CanStrafe) then
			FlightPhys.pos = self:GetPos()+(FWD*self.Accel.FWD)+(UP*self.Accel.UP)+(RIGHT*self.Accel.RIGHT);
		else
			FlightPhys.pos = self:GetPos()+(FWD*self.Accel.FWD)+(UP*self.Accel.UP);
		end

		if(!self.CriticalDamage) then
			phys:ComputeShadowControl(FlightPhys);
		end
	else
		if(self.ShouldStandby and self.CanStandby) then
			FlightPhys.angle = self.StandbyAngles or Angle(0,self:GetAngles().y,0);
			FlightPhys.deltatime = deltatime;
			FlightPhys.pos = self:GetPos()+UP;
			phys:ComputeShadowControl(FlightPhys);		
		end
	end
		
end
end

if CLIENT then
	
	ENT.CanFPV = false;
	ENT.Sounds={
		Engine=Sound("ambient/atmosphere/ambience_base.wav"),
	}
	
	function ENT:Initialize()
		self.Emitter = ParticleEmitter(self:GetPos());
		self.BaseClass.Initialize(self);
	end
	function ENT:Draw() self:DrawModel() end;
	local LightSpeed = 0;
	function ENT:Think()
		self.BaseClass.Think(self);
		local p = LocalPlayer();
		local IsFlying = p:GetNWEntity(self.Vehicle);
		local Flying = self:GetNWBool("Flying".. self.Vehicle);
		if(IsFlying) then
			LightSpeed = self:GetNWInt("LightSpeed");
		end
		
		if(Flying) then
			self.EnginePos = {
				self:GetPos()+self:GetForward()*-5400+self:GetUp()*620+self:GetRight()*410,
				self:GetPos()+self:GetForward()*-5400+self:GetUp()*620+self:GetRight()*-410,
				self:GetPos()+self:GetForward()*-5400+self:GetUp()*890+self:GetRight()*410,
				self:GetPos()+self:GetForward()*-5400+self:GetUp()*890+self:GetRight()*-410,
			}
			self:Effects();
		end
	end	
	
    ENT.ViewDistance = 8000;
    ENT.ViewHeight = 350;

	function ENT:Effects()

		local p = LocalPlayer();
		local roll = math.Rand(-45,45);
		local normal = (self.Entity:GetForward() * 1):GetNormalized();
		local id = self:EntIndex();
		local FWD = self:GetForward();
		for k,v in pairs(self.EnginePos) do

			local heatwv = self.Emitter:Add("sprites/heatwave",v);
			heatwv:SetVelocity(normal*2);
			heatwv:SetDieTime(0.1);
			heatwv:SetStartAlpha(255);
			heatwv:SetEndAlpha(255);
			heatwv:SetStartSize(100);
			heatwv:SetEndSize(100);
			heatwv:SetColor(255,255,255);
			heatwv:SetRoll(roll);
			
			local blue = self.Emitter:Add("sprites/bluecore",v)
			blue:SetVelocity(normal)
			blue:SetDieTime(0.05)
			blue:SetStartAlpha(255)
			blue:SetEndAlpha(200)
			blue:SetStartSize(100)
			blue:SetEndSize(100)
			blue:SetRoll(roll)
			blue:SetColor(255,255,255)
			
			local dynlight = DynamicLight(id + 4096 * k);
			dynlight.Pos = v;
			dynlight.Brightness = 5;
			dynlight.Size = 150;
			dynlight.Decay = 1024;
			dynlight.R = 100;
			dynlight.G = 100;
			dynlight.B = 255;
			dynlight.DieTime = CurTime()+1;

		end
	end

	
	function CalamariReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingCalamari");
		local self = p:GetNWEntity("Calamari");
		if(Flying and IsValid(self)) then
			

			local x = ScrW()/10;
			local y = ScrH()/4*3.5;
			SW_HUD_DrawHull(45000,x,y);		
			if(IsValid(self)) then
				if(LightSpeed == 2) then
					DrawMotionBlur( 0.4, 20, 0.01 );
				end
			end
			
		end
	end
	hook.Add("HUDPaint", "CalamariReticle", CalamariReticle)

end

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Type = "vehicle"
ENT.Base = "fighter_base"

ENT.PrintName = "Cargo Shuttle"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Empire"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.EntModel = "models/starwars/syphadias/ships/cargo_shuttle/cargo_shuttle_landed.mdl"
ENT.FlyClosed = "models/starwars/syphadias/ships/cargo_shuttle/cargo_shuttle_closed.mdl";
ENT.FlyOpen = "models/starwars/syphadias/ships/cargo_shuttle/cargo_shuttle_open.mdl";
ENT.Vehicle = "CargoShuttle"
ENT.StartHealth = 8000;
ENT.Allegiance = "Empire";
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then
ENT.HyperDriveSound = Sound("vehicles/hyperdrive.mp3");
ENT.FireSound = Sound("weapons/tie_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),LightSpeed = CurTime(),Switch=CurTime()};


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("cargo_shuttle");
	e:SetPos(tr.HitPos + Vector(0,0,10));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	
	self:SetNWInt("Health",self.StartHealth);
	self.CanRoll = true;
	self.WeaponLocations = {
		RightBottom = self:GetPos()+self:GetForward()*690+self:GetUp()*220+self:GetRight()*142.5,
		LeftBottom = self:GetPos()+self:GetForward()*690+self:GetUp()*220+self:GetRight()*-142.5,
		RightTop = self:GetPos()+self:GetForward()*690+self:GetUp()*245+self:GetRight()*142.5,
		LeftTop = self:GetPos()+self:GetForward()*690+self:GetUp()*245+self:GetRight()*-142.5,
	}
	self.WeaponsTable = {};
	//self:SpawnWeapons();
	self.BoostSpeed = 2000;
	self.ForwardSpeed = 1250;
	self.UpSpeed = 500;
	self.AccelSpeed = 5;
	self.CanStandby = false;
	self.Cooldown = 2;
	self.Overheat = 0;
	self.Overheated = false;
	self.CanShoot = true;
	self.CanRoll = false;
    self.CanStrafe = true;
	self.AlternateFire = true;
	self.FireGroup = {"RightBottom","LeftBottom","RightTop","LeftTop"}
    self.FireDelay = 0.4;
	self.HasWings = true;
	self.ExitModifier = {x = 0, y = 500, z = 15};
	self.HasLookaround = false;
	self.LandOffset = Vector(0,0,20);
	self.PilotVisible = false;
    self.PilotPosition = {x=19,y=115,z=92.5};
	self.HasLightspeed = true;
	self.Bullet = CreateBulletStructure(65,"green");

	self.BaseClass.Initialize(self)
end

function ENT:Enter(p)
 
    if(!self.Inflight) then
        self:SetModel(self.FlyClosed);
        self:RestartPhysics();
    end
    self.BaseClass.Enter(self,p);
end

function ENT:Exit(kill)
        
    self.BaseClass.Exit(self,kill)
    if(self.TakeOff or self.Land) then
        self:SetModel(self.EntModel);
        self:RestartPhysics();
    end
end
    
function ENT:ToggleWings()
    if(!IsValid(self)) then return end;
	if(self.NextUse.Wings < CurTime()) then
		if(self.Wings) then
			self:SetModel(self.FlyClosed);
			self.Wings = false;
		else
			self.Wings = true;
			self:SetModel(self.FlyOpen);
		end
        self:RestartPhysics();
		self:SetNWBool("Wings",self.Wings);
		if(IsValid(self.Pilot)) then
			self.Pilot:SetNWBool("SW_Wings",self.Wings);
		end
		self.NextUse.Wings = CurTime() + 1;
	end
end
    
function ENT:RestartPhysics()
    self:PhysicsInit(SOLID_VPHYSICS);
    if(self.Inflight) then
        if(IsValid(self:GetPhysicsObject())) then
            self:GetPhysicsObject():EnableMotion(true);
            self:GetPhysicsObject():Wake();
        end
    end
    self:StartMotionController();     
end
    
end
if CLIENT then

	ENT.EnginePos = {}
	ENT.Sounds={
		Engine=Sound("vehicles/mf/mf_fly5.wav"),
	}
	
	local TakeOff;
	local Land;
	ENT.NextView = CurTime();
    local LightSpeed = 0;
	function ENT:Think()
		

		local p = LocalPlayer();
		local Flying = self:GetNWBool("Flying".. self.Vehicle);
		local IsFlying = p:GetNWBool("Flying"..self.Vehicle);
		local Wings = self:GetNWBool("Wings");
		TakeOff = self:GetNWBool("TakeOff");
		Land = self:GetNWBool("Land");
        if(IsFlying) then
			LightSpeed = self:GetNWInt("LightSpeed");
		end
		if(Flying) then

            self.EnginePos = {
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*32.5,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*43.75,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*55,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*65,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*75,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*86.25,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*97.5,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*107.5,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*117.5,

                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*-32.5,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*-43.75,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*-55,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*-65,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*-75,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*-86.25,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*-97.5,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*-107.5,
                self:GetPos()+self:GetForward()*-820+self:GetUp()*200+self:GetRight()*-117.5,
            }
			if(!TakeOff and !Land) then
				self:FlightEffects();
			end

		end
		self.BaseClass.Think(self);
		
	end

    ENT.ViewDistance = 2000;
    ENT.ViewHeight = 550;
    ENT.FPVPos = Vector(775,0,265);
	ENT.CanFPV = true;
    
	function CargoShuttleReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingCargoShuttle");
		local self = p:GetNWEntity("CargoShuttle");
		

		if(Flying and IsValid(self)) then
			SW_HUD_DrawHull(4000);
			SW_WeaponReticles(self);
			SW_HUD_DrawOverheating(self);
			SW_HUD_Compass(self);
			SW_HUD_DrawSpeedometer();
		end
		if(IsValid(self)) then
			if(LightSpeed == 2) then
				DrawMotionBlur( 0.4, 20, 0.01 );
			end
		end
	end
	hook.Add("HUDPaint", "CargoShuttleReticle", CargoShuttleReticle)

	function ENT:FlightEffects()
		local normal = (self:GetForward() * -1):GetNormalized()
		local roll = math.Rand(-90,90)
		local p = LocalPlayer()		
		local id = self:EntIndex();

		for k,v in pairs(self.EnginePos) do

            local red = self.FXEmitter:Add("sprites/orangecore1",v)
            red:SetVelocity(normal)
            red:SetDieTime(FrameTime()*1.25)
            red:SetStartAlpha(255)
            red:SetEndAlpha(255)
            red:SetStartSize(25)
            red:SetEndSize(20)
            red:SetRoll(roll)
            red:SetColor(255,255,255)
				
		end
			
		for i=1,2 do
            local dynlight = DynamicLight(id + 4096*i);
            dynlight.Pos = self.EnginePos[9*i];
            dynlight.Brightness = 5;
            dynlight.Size = 200;
            dynlight.Decay = 1024;
            dynlight.R = 80;
            dynlight.G = 80;
            dynlight.B = 255;
            dynlight.DieTime = CurTime()+1;
        end
	end
	
end
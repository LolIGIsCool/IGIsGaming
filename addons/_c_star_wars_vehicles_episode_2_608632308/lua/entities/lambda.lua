ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Base = "fighter_base"
ENT.Type = "vehicle"

ENT.PrintName = "Lambda-class Shuttle"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Empire"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.EntModel = "models/starwars/lordtrilobite/ships/lambda_shuttle/lambda_shuttle_landed.mdl"
ENT.Vehicle = "LambdaShuttle"
ENT.StartHealth = 4000;
ENT.Allegiance = "Empire";

ENT.WingsModel = "models/starwars/lordtrilobite/ships/lambda_shuttle/lambda_shuttle_fly_down.mdl"
ENT.ClosedModel = "models/starwars/lordtrilobite/ships/lambda_shuttle/lambda_shuttle_fly_up.mdl"
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.FireSound = Sound("weapons/tie_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),LightSpeed=CurTime(),Switch=CurTime(),};
ENT.HyperDriveSound = Sound("vehicles/hyperdrive.mp3");

AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("lambda");
	e:SetPos(tr.HitPos + Vector(0,0,0));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw+180,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()

	self:SetNWInt("Health",self.StartHealth);
	
	self.WeaponLocations = {
        RightR = self:GetPos()+self:GetForward()*217.5+self:GetUp()*160+self:GetRight()*242.5,
        LeftL = self:GetPos()+self:GetForward()*217.5+self:GetUp()*160+self:GetRight()*-242.5,
        RightL = self:GetPos()+self:GetForward()*217.5+self:GetUp()*160+self:GetRight()*230,
        LeftR = self:GetPos()+self:GetForward()*217.5+self:GetUp()*160+self:GetRight()*-230,
            
        WingRightR = self:GetPos()+self:GetForward()*217.5+self:GetUp()*102.5+self:GetRight()*253.5,
        WingRightL = self:GetPos()+self:GetForward()*217.5+self:GetUp()*102.5+self:GetRight()*220,
        WingLeftL = self:GetPos()+self:GetForward()*217.5+self:GetUp()*102.5+self:GetRight()*-253.5,
        WingLeftR = self:GetPos()+self:GetForward()*217.5+self:GetUp()*102.5+self:GetRight()*-220,
            
	}
	self.WeaponsTable = {};
	self.BoostSpeed = 2500;
	self.ForwardSpeed = 1000;
	self.UpSpeed = 600;
	self.AccelSpeed = 7;
	self.CanStandby = false;
	self.CanBack = true;
	self.CanRoll = false;
	self.CanStrafe = true;
	self.Cooldown = 2;
	self.CanShoot = true;
	self.Bullet = CreateBulletStructure(65,"green");
	self.FireDelay = 0.2;
	self.AlternateFire = true;
	self.FireGroup = {"RightR","RightL","LeftL","LeftR"};
	self.HasWings = true;
    self.HasLightspeed = true;
    self.CanEject = false;

	self.ExitModifier = {x=0,y=250,z=180};
	self.PilotOffset = {x=0,y=250,z=180};

    self.PilotVisible = true;
    self.PilotPosition = {x=-35,y=325,z=190}
    self.HasSeats = true;
	self.SeatPos = {
        FrontR = {self:GetPos()+self:GetForward()*320+self:GetRight()*35+self:GetUp()*182.5,self:GetAngles()+Angle(0,-90,0),Vector(200,0,183.5)},
        BackL = {self:GetPos()+self:GetForward()*277.5+self:GetRight()*-50+self:GetUp()*190,self:GetAngles()+Angle(0,-90,0),Vector(200,0,183.5)},
        BackR = {self:GetPos()+self:GetForward()*277.5+self:GetRight()*50+self:GetUp()*190,self:GetAngles()+Angle(0,-90,0),Vector(200,0,183.5)},
            
		{self:GetPos()+self:GetForward()*17.5+self:GetUp()*202.5+self:GetRight()*60,self:GetAngles(),Vector(17.5,-28,185)},
		{self:GetPos()+self:GetForward()*47.5+self:GetUp()*202.5+self:GetRight()*60,self:GetAngles(),Vector(47.5,-28,185)},
		{self:GetPos()+self:GetForward()*75+self:GetUp()*202.5+self:GetRight()*60,self:GetAngles(),Vector(75,-28,185)},
		{self:GetPos()+self:GetForward()*105+self:GetUp()*202.5+self:GetRight()*60,self:GetAngles(),Vector(105,-28,185)},
		{self:GetPos()+self:GetForward()*135+self:GetUp()*202.5+self:GetRight()*60,self:GetAngles(),Vector(135,-28,185)},
		{self:GetPos()+self:GetForward()*162.5+self:GetUp()*202.5+self:GetRight()*60,self:GetAngles(),Vector(162.5,-28,185)},
		{self:GetPos()+self:GetForward()*192.5+self:GetUp()*202.5+self:GetRight()*60,self:GetAngles(),Vector(192.5,-28,185)},
            
		{self:GetPos()+self:GetForward()*17.5+self:GetUp()*202.5+self:GetRight()*-60,self:GetAngles()+Angle(0,-180,0),Vector(17.5,28,185)},
		{self:GetPos()+self:GetForward()*47.5+self:GetUp()*202.5+self:GetRight()*-60,self:GetAngles()+Angle(0,-180,0),Vector(47.5,28,185)},
		{self:GetPos()+self:GetForward()*75+self:GetUp()*202.5+self:GetRight()*-60,self:GetAngles()+Angle(0,-180,0),Vector(75,28,185)},
		{self:GetPos()+self:GetForward()*105+self:GetUp()*202.5+self:GetRight()*-60,self:GetAngles()+Angle(0,-180,0),Vector(105,28,185)},
		{self:GetPos()+self:GetForward()*135+self:GetUp()*202.5+self:GetRight()*-60,self:GetAngles()+Angle(0,-180,0),Vector(135,28,185)},
		{self:GetPos()+self:GetForward()*162.5+self:GetUp()*202.5+self:GetRight()*-60,self:GetAngles()+Angle(0,-180,0),Vector(162.5,28,185)},
		{self:GetPos()+self:GetForward()*192.5+self:GetUp()*202.5+self:GetRight()*-60,self:GetAngles()+Angle(0,-180,0),Vector(192.5,28,185)},
	};
	self.HasLookaround = true;
	self.BaseClass.Initialize(self);
    self:SetSkin(1);
    for k,v in pairs(self.Weapons) do
        if(k == "WingLeft" or k == "WingRight") then
            v.Disabled = true;
        end
    end
end

    
function ENT:Enter(p)
    if(!IsValid(self.Pilot)) then
        self:SetModel(self.ClosedModel);
        self:PhysicsInit(SOLID_VPHYSICS);
        self:SkinSwitch(true);
        if(IsValid(self:GetPhysicsObject())) then
            self:GetPhysicsObject():EnableMotion(true);
            self:GetPhysicsObject():Wake();
        end
        self:StartMotionController();
    end
    self.BaseClass.Enter(self,p);
end
    
function ENT:Exit(kill)
    local p = self.Pilot;
    self.BaseClass.Exit(self,kill);
    if(self.Land or self.TakeOff) then
        self:SetModel(self.EntModel);
        self:PhysicsInit(SOLID_VPHYSICS);
        if(IsValid(self:GetPhysicsObject())) then
            self:GetPhysicsObject():EnableMotion(true);
            self:GetPhysicsObject():Wake();
        end
        self:StartMotionController();
        if(IsValid(p)) then
            p:SetEyeAngles(self:GetAngles()+Angle(0,180,0));
        end
    end
    self:SkinSwitch(false);
end
    
function ENT:SkinSwitch(b)
    if(b) then
        if(self.VehicleHealth <= self.StartHealth/2) then
            self:SetSkin(2);
        else
            self:SetSkin(0);
        end
    else
        if(self.VehicleHealth <= self.StartHealth/2) then
            self:SetSkin(3);
        else
            self:SetSkin(1);
        end
    end
            
end
    
function ENT:ToggleWings()
    if(!IsValid(self)) then return end;
	if(self.NextUse.Wings < CurTime()) then
		if(self.Wings) then
			self:SetModel(self.ClosedModel);
            self.FireGroup = {"RightR","RightL","LeftL","LeftR"};
            self.Bullet = CreateBulletStructure(65,"green");
			self.Wings = false;
		else
			self.Wings = true;
			self:SetModel(self.WingsModel);
            self.Bullet = CreateBulletStructure(75,"green");
            self.FireGroup = {"WingRightR","WingRightL","WingLeftL","WingLeftR"};
		end
        for k,v in pairs(self.Weapons) do
            if(!self.Wings and (k=="WingLeftL" or k=="WingLeftR" or k == "WingRightL" or k=="WingRightR")) then
                v.Disabled = true;
            elseif(self.Wings and (k=="LeftL" or k=="LeftR" or k == "RightL" or k=="RightR")) then
                v.Disabled = true;
            end
        end
		self:PhysicsInit(SOLID_VPHYSICS);
        if(IsValid(self:GetPhysicsObject())) then
            self:GetPhysicsObject():EnableMotion(true);
            self:GetPhysicsObject():Wake();
        end
        self:StartMotionController();
		self:SetNWBool("Wings",self.Wings);
		if(IsValid(self.Pilot)) then
			self.Pilot:SetNWBool("SW_Wings",self.Wings);
		end
		self.NextUse.Wings = CurTime() + 1;
	end
end

function ENT:Use(p)
	if(not self.Inflight) then
		if(!p:KeyDown(IN_WALK)) then
            local min = self:GetPos()+self:GetForward()*335+self:GetUp()*185+self:GetRight()*55;
            local max = self:GetPos()+self:GetForward()*235+self:GetUp()*275+self:GetRight()*-55
            for k,v in pairs(ents.FindInBox(min,max)) do
               if(v == p) then
                    self:Enter(p);
                    break;
                end
            end	
		else
			self:Passenger(p);
		end
	else
		if(p != self.Pilot) then
			self:Passenger(p);
		end
	end
end

function ENT:OnTakeDamage(dmg) --########## Shuttle's aren't invincible are they? @RononDex
    self.BaseClass.OnTakeDamage(self,dmg);
	if(dmg:GetAttacker() != self) then
		local health=self:GetNetworkedInt("Health")-(dmg:GetDamage()/2)


        if(health<=self.StartHealth/2) then
            self:SkinSwitch(self.Inflight);
        end
        
		if(health<=(self.StartHealth*0.33)) then
			self.HyperdriveDisabled = true;
		end
	end
end




end

if CLIENT then
	
	ENT.CanFPV = true;
	ENT.Sounds={
		Engine=Sound("ambient/atmosphere/ambience_base.wav"),
    }
	
	function ENT:Draw() self:DrawModel() end;
	
	function ENT:Think()
		self.BaseClass.Think(self);
		local p = LocalPlayer();
		local IsFlying = p:GetNWEntity("LambdaShuttle");
		local Flying = self:GetNWBool("Flying".. self.Vehicle);
		if(Flying) then
			self.EnginePos = {
				self:GetPos()+self:GetForward()*-395+self:GetUp()*160+self:GetRight()*67.5,
				self:GetPos()+self:GetForward()*-395+self:GetUp()*160+self:GetRight()*-67.5,
			}
			self:FlightEffects();
		end
	end
	
	function ENT:FlightEffects()
		local normal = (self:GetForward() * -1):GetNormalized()
		local roll = math.Rand(-90,90)
		local p = LocalPlayer()		
		local FWD = self:GetForward();
		local id = self:EntIndex();
		
		for k,v in pairs(self.EnginePos) do
			
			
			local dynlight = DynamicLight(id + 4096 * k);
			dynlight.Pos = v;
			dynlight.Brightness = 7;
			dynlight.Size = 350;
			dynlight.Decay = 1024;
			dynlight.R = 75;
			dynlight.G = 75;
			dynlight.B = 255;
			dynlight.DieTime = CurTime()+1;
			
		end
	
	end
	
    ENT.ViewDistance = 1300;
    ENT.ViewHeight = 650;
    ENT.FPVPos = Vector(325,35,235);
	
	function LambdaShuttleReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingLambdaShuttle");
		local self = p:GetNWEntity("LambdaShuttle");
		if(Flying and IsValid(self)) then
			SW_HUD_DrawHull(4000);
			SW_WeaponReticles(self);
			SW_HUD_DrawOverheating(self);
            
            local pos = self:GetPos()+self:GetForward()*365+self:GetUp()*225;
            local x,y = SW_XYIn3D(pos);
			SW_HUD_Compass(self,x,y);
			SW_HUD_DrawSpeedometer();
			SW_HUD_WingsIndicator("shuttle",x,y);
		end
	end
	hook.Add("HUDPaint", "LambdaShuttleReticle", LambdaShuttleReticle)

    
	hook.Add("ScoreboardShow","LambdaShuttleScoreDisable", function()
		local p = LocalPlayer();	
		local Flying = p:GetNWBool("FlyingLambdaShuttle");
		if(Flying) then
			return false;
		end
	end)
end
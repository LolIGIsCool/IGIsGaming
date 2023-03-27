ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Type = "vehicle"
ENT.Base = "fighter_base"

ENT.PrintName = "YT HEL-105 Freighter"
ENT.Author = "Liam / Cody"
ENT.Category = "Star Wars"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminOnly = true;

ENT.EntModel = "models/props/hel105/hel105.mdl"
ENT.FlyModel = "models/props/hel105/hel105.mdl"
ENT.Vehicle = "Hel105"
ENT.StartHealth = 5000;
ENT.Allegiance = "Neutral";

list.Set("SWVehicles", ENT.PrintName, ENT);
if SERVER then

ENT.FireSound = Sound("vehicles/mf/mf_shoot2.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),LightSpeed=CurTime(),Switch=CurTime(),};


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("hel105");
	e:SetPos(tr.HitPos + Vector(0,0,10));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	
	self:SetNWInt("Health",self.StartHealth);
	self.CanRoll = false;
	self.CanStrafe = true;
	self.CanBack = true;
	self.WeaponLocations = {
		TopRight = self:GetPos()+self:GetUp()*140+self:GetForward()*250+self:GetRight()*7,
		BottomRight = self:GetPos()+self:GetUp()*140+self:GetForward()*250+self:GetRight()*7,
		TopLeft = self:GetPos()+self:GetUp()*140+self:GetForward()*250+self:GetRight()*-9,
		BottomLeft = self:GetPos()+self:GetUp()*140+self:GetForward()*250+self:GetRight()*-9,
	}
	self.WeaponsTable = {};
	//self:SpawnWeapons();
	self.BoostSpeed = 1500;
	self.ForwardSpeed = 1500;
	self.UpSpeed = 600;
	self.AccelSpeed = 10;
	self.ExitModifier = {x=-5,y=-125,z=3}
	self.SeatPos = {
        {self:GetPos()+self:GetUp()*20+self:GetForward()*50,self:GetAngles()},
        {self:GetPos()+self:GetUp()*20+self:GetRight()*50+self:GetForward()*50,self:GetAngles()},
        {self:GetPos()+self:GetUp()*20+self:GetRight()*-50+self:GetForward()*50,self:GetAngles()},
       
        {self:GetPos()+self:GetUp()*20+self:GetForward()*75,self:GetAngles()},
        {self:GetPos()+self:GetUp()*20+self:GetRight()*50+self:GetForward()*75,self:GetAngles()},
        {self:GetPos()+self:GetUp()*20+self:GetRight()*-50+self:GetForward()*75,self:GetAngles()},
       
        {self:GetPos()+self:GetUp()*20+self:GetForward()*100,self:GetAngles()},
        {self:GetPos()+self:GetUp()*20+self:GetRight()*50+self:GetForward()*100,self:GetAngles()},
        {self:GetPos()+self:GetUp()*20+self:GetRight()*-50+self:GetForward()*100,self:GetAngles()},
       
        {self:GetPos()+self:GetUp()*20+self:GetForward()*125,self:GetAngles()},
        {self:GetPos()+self:GetUp()*20+self:GetRight()*50+self:GetForward()*125,self:GetAngles()},
        {self:GetPos()+self:GetUp()*20+self:GetRight()*-50+self:GetForward()*125,self:GetAngles()},
   
    }
    self:SpawnSeats();
	self.CanShoot = true;
	self.DontOverheat = true;
	self.FireDelay = 0.15
	self.AlternateFire = true;
	self.FireGroup = {"TopRight","TopLeft","BottomRight","BottomLeft"}
	self.HasWings = true;
	self.Bullet = CreateBulletStructure(100,"red");
	
	self:SetBodygroup(1,0);
	
	self.BaseClass.Initialize(self)

end

function ENT:ToggleWings()
 
    if(self.NextUse.Wings < CurTime()) then
        if(self.Wings) then
            self:SetBodygroup(1,1);
            self.Wings = false;
        else
            self:SetBodygroup(1,0);
            self.Wings = true;
        end
        self.NextUse.Wings = CurTime() + 1;
    end
end

function ENT:SpawnSeats()
    self.Seats = {};
    for k,v in pairs(self.SeatPos) do
        local e = ents.Create("prop_vehicle_prisoner_pod");
        e:SetPos(v[1]);
        e:SetAngles(v[2]+Angle(0,-90,0));
        e:SetParent(self);     
        e:SetModel("models/nova/airboat_seat.mdl");
        e:SetRenderMode(RENDERMODE_TRANSALPHA);
        e:SetColor(Color(255,255,255,0));  
        e:Spawn();
        e:Activate();
        e:SetUseType(USE_OFF);
        e:GetPhysicsObject():EnableMotion(false);
        e:GetPhysicsObject():EnableCollisions(false);
        e.IsHel105Seat = true;
        e.Hel105 = self;
 
        self.Seats[k] = e;
    end
 
end
 
hook.Add("PlayerEnteredVehicle","Hel105SeatEnter", function(p,v)
    if(IsValid(v) and IsValid(p)) then
        if(v.IsHel105Seat) then
            p:SetNetworkedEntity("Hel105",v:GetParent());
        end
    end
end);
 
hook.Add("PlayerLeaveVehicle", "Hel105SeatExit", function(p,v)
    if(IsValid(p) and IsValid(v)) then
        if(v.IsHel105Seat) then
            local e = v.Hel105;
            if(IsValid(e)) then
                p:SetPos(e:GetPos() + e:GetRight()*e.ExitModifier.x + e:GetForward() * e.ExitModifier.y + e:GetUp() * e.ExitModifier.z);
            end
            p:SetNetworkedEntity("Hel105",NULL);
        end
    end
end);
 
function ENT:Passenger(p)
    if(self.NextUse.Use > CurTime()) then return end;
    for k,v in pairs(self.Seats) do
        if(v:GetPassenger(1) == NULL) then
            p:EnterVehicle(v);
            return;        
        end
    end
end

function ENT:Use(p)
    if(not self.Inflight) then
        if(!p:KeyDown(IN_WALK)) then
            self:Enter(p);
        else
            self:Passenger(p);
        end
    else
        if(p != self.Pilot) then
            self:Passenger(p);
        end
    end
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
	ENT.CanFPV = true;
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

		end
		
		
	end
	
	ENT.HasCustomCalcView = true;
	local View = {}
	local function CalcView()
		
		local p = LocalPlayer();
		local self = p:GetNWEntity("Hel105")
		local pos,face;
		if(IsValid(self)) then
			local fpvPos = self:GetPos()+self:GetRight()*320+self:GetUp()*140+self:GetForward()*160;
			View = SWVehicleView(self,1000,250,fpvPos);		
			return View;
		end
	end
	hook.Add("CalcView", "Hel105View", CalcView)
	
	function ENT:FlightEffects()
		local normal = (self:GetForward() * -1):GetNormalized()
		local roll = math.Rand(-90,90)
		local p = LocalPlayer()		
		local FWD = self:GetForward();
		local id = self:EntIndex();
		
		self.EnginePos = {
			self:GetPos()+self:GetUp()*50+self:GetRight()*-218+self:GetForward()*-252;
			self:GetPos()+self:GetUp()*50+self:GetRight()*-170+self:GetForward()*-282;
			self:GetPos()+self:GetUp()*50+self:GetRight()*-118+self:GetForward()*-312;
			
			self:GetPos()+self:GetUp()*50+self:GetRight()*218+self:GetForward()*-252;
			self:GetPos()+self:GetUp()*50+self:GetRight()*170+self:GetForward()*-282;
			self:GetPos()+self:GetUp()*50+self:GetRight()*118+self:GetForward()*-312;
		}
		--[[for k,v in pairs(self.EnginePos) do
				
			local blue = self.FXEmitter:Add("sprites/bluecore",v)
			blue:SetVelocity(normal)
			blue:SetDieTime(FrameTime()*1.25)
			blue:SetStartAlpha(255)
			blue:SetEndAlpha(255)
			blue:SetStartSize(37.5)
			blue:SetEndSize(25)
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
			
		end]]--
	
	end
	
	local HUD = surface.GetTextureID("vgui/falcon_cockpit")
	local Glass = surface.GetTextureID("models/props_c17/frostedglass_01a_dx60")
	function Hel105Reticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingHel105");
		local self = p:GetNWEntity("Hel105");
		

		if(Flying and IsValid(self)) then

			local FPV = self:GetFPV();
			
			if(FPV) then
				SW_HUD_FPV(HUD);
			end
			
			SW_HUD_DrawHull(5000);
			SW_WeaponReticles(self);
			
			local x = ScrW()/4*1.3;
			local y = ScrH()/4*3.1;
			SW_HUD_Compass(self,x,y);
			SW_HUD_DrawSpeedometer();
		end
	end
	hook.Add("HUDPaint", "Hel105Reticle", Hel105Reticle)

end
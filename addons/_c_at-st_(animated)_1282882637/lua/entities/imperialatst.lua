ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Base = "speeder_base"
ENT.Type = "vehicle"

ENT.PrintName = "AT-ST"
ENT.Author = "Cody Evans"
--- BASE AUTHOR: Liam0102 ---
ENT.Category = "Star Wars Vehicles: Empire"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.AutomaticFrameAdvance =  true; 
ENT.Allegiance = "Empire"
ENT.Vehicle = "ImperialATST"; 
ENT.EntModel = "models/helios/vehicles/atst.mdl"; 


ENT.StartHealth = 5000;

list.Set("SWVehicles", ENT.PrintName, ENT);
if SERVER then

ENT.NextUse = {Use = CurTime(),Fire = CurTime()};
ENT.FireSound = Sound("atst/atst_shoot.wav");


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("imperialatst");
	e:SetPos(tr.HitPos + Vector(0,0,20));
	e:SetModelScale( e:GetModelScale() * 1.2, 0 )
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw+0,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	self.BaseClass.Initialize(self);
	local driverPos = self:GetPos()+self:GetUp()*282+self:GetForward()*25+self:GetRight()*0;
	local driverAng = self:GetAngles()+Angle(0,-90,0);
	self.SpeederClass = 2;
	self:SpawnChairs(driverPos,driverAng,false)
	self.ForwardSpeed = 130;
	self.BoostSpeed = 130;
	self.AccelSpeed = 10;
	self.HoverMod = 10;
	self.CanBack = false;
	self.StartHover = 10;
	self.WeaponLocations = {}
	self.Bullet = CreateBulletStructure(100,"red");
	self:SpawnWeapons();
	self.StandbyHoverAmount = 10;	
	self.ExitModifier = {x=0,y=200,z=0}
end

function ENT:Enter(p,driver)
    self.BaseClass.Enter(self,p,driver);
    self:Rotorwash(false);
end

function ENT:FireBlast(pos,gravity,vel,ang)
    if(self.NextUse.FireBlast < CurTime()) then
        local e = ents.Create("atst_blast");
        e:SetPos(pos);
        e:Spawn();
        e:Activate();
        e:Prepare(self,Sound("weapons/grenade_launcher1.wav"),gravity,vel,ang);
        e:SetColor(Color(255,255,255,1));
        self.NextUse.FireBlast = CurTime() + 2;
    end
end

local ZAxis = Vector(0,0,1);

function ENT:Think()
	self:NextThink(CurTime())
	self.BaseClass.Think(self)
	
    if(self.Inflight) then
	    if self:GetNWInt("Speed") >= 10 and self:GetNWInt("Speed") < 20 then
			self:ResetSequence( self:LookupSequence( "walking" ) );
			self:SetPlaybackRate( 0.05 )
	    elseif self:GetNWInt("Speed")  >= 20 and self:GetNWInt("Speed") < 40 then
			self:ResetSequence( self:LookupSequence( "walking" ) );
			self:SetPlaybackRate( 0.1 )
	    elseif self:GetNWInt("Speed")  >= 40 and self:GetNWInt("Speed") < 60 then
			self:ResetSequence( self:LookupSequence( "walking" ) );
			self:SetPlaybackRate( 0.2 )
	    elseif self:GetNWInt("Speed")  >= 60 and self:GetNWInt("Speed") < 130 then
			self:ResetSequence( self:LookupSequence( "walking" ) );
			self:SetPlaybackRate( 0.7 )
	    end
	
	    if self:GetNWInt("Speed") <= 0 then
		    self:SetSequence( self:LookupSequence( "walking" ) );
			self:ResetSequenceInfo()
		    self:SetPlaybackRate( 0 );
	    end
	
        if(IsValid(self.Pilot)) then
	
	    local saveangle = self.Pilot:GetAimVector():Angle()
	    local weaponangle = self:WorldToLocalAngles( saveangle )
	    local aim = weaponangle;	
		local rocketpos,rocketang = self:GetBonePosition(self:LookupBone("head_right_gun")) 
			
		local p = aim.p*1;
		if(p >= -150 and p <= -30) then
			p = -30;
		end
			
        self:ManipulateBoneAngles(self:LookupBone("head_front_gun"), Angle(p,0,0) );
		self:ManipulateBoneAngles(self:LookupBone("head_right_gun"), Angle(p,0,8.5) );
		self:ManipulateBoneAngles(self:LookupBone("head"), Angle(0,-aim.z,-aim.y) );
	
	    if(self.Pilot:KeyDown(IN_ATTACK)) then
				self:FireWeapons();
		elseif(self.Pilot:KeyDown(IN_ATTACK2)) then
				self:FireBlast(rocketpos+self:GetRight()*20+self:GetForward()*10,true,0.1,rocketang:Up()*1000,25);
		end
			lastZ = aim.z;
			self:NextThink(CurTime());
			return true;
		end
	end
end
	
function ENT:Exit(driver,kill)
	self.BaseClass.Exit(self,driver,kill);
	self:SetSequence( self:LookupSequence( "walking" ) );
	self:ResetSequenceInfo()
	self:SetPlaybackRate( 0 )
end
	
function ENT:FireWeapons()

	if(self.NextUse.Fire < CurTime()) then
		
		local headPoss, headAngg = self:GetBonePosition(self:LookupBone("head_front_gun"))
		local e = bonePoss;
		
		local WeaponPos = {
			Vector(headPoss)+self:GetRight()*10+self:GetForward()*10+self:GetUp()*15,
			Vector(headPoss)+self:GetRight()*-10+self:GetForward()*10+self:GetUp()*15,
		}
		for k,v in pairs(WeaponPos) do
			tr = util.TraceLine({
				start = headPoss,
				endpos = headPoss + headAngg:Up()*10000,
				filter = {self},
			})
			
			self.Bullet.Src		= v;
			self.Bullet.Attacker = self.Pilot or self;	
			self.Bullet.Dir = (tr.HitPos - v);

			self:FireBullets(self.Bullet)
		end
		self:EmitSound(self.FireSound, 120, math.random(90,110));
		self.NextUse.Fire = CurTime() + 0.3;
	end
end

function ENT:PhysicsSimulate( phys, deltatime )
	self.BackPos = self:GetPos()+self:GetForward()*-10+self:GetUp()*10;
	self.FrontPos = self:GetPos()+self:GetForward()*10+self:GetUp()*10;
	self.MiddlePos = self:GetPos()+self:GetUp()*10; // Middle one
	if(self.Inflight) then
		local UP = ZAxis;
		self.RightDir = self.Entity:GetRight();
		self.FWDDir = self.Entity:GetForward();
		
		self:RunTraces(); // Ignore

		self.ExtraRoll = Angle(0,0,self.YawAccel / 1*-.1);
	end
	self.BaseClass.PhysicsSimulate(self,phys,deltatime);
end

end

if CLIENT then
	ENT.Sounds={
		Engine=Sound("atst/atst_walk.wav"),
	}
	
	local Health = 0;
	local Speed = 0;
	function ENT:Think()
		self.BaseClass.Think(self);
		local p = LocalPlayer();
		local Flying = p:GetNWBool("Flying"..self.Vehicle);
		if(Flying) then
			Health = self:GetNWInt("Health");
			Speed = self:GetNWInt("Speed");
		end
		
	end

	ENT.HasCustomCalcView = true;
	local View = {}
	function CalcView()
		
		local p = LocalPlayer();
		local self = p:GetNWEntity("ImperialATST", NULL)
		local DriverSeat = p:GetNWEntity("DriverSeat",NULL);

		if(IsValid(self)) then
			if(IsValid(DriverSeat)) then
				local pos = self:GetPos()+LocalPlayer():GetAimVector():GetNormal()*-200+self:GetUp()*500+self:GetRight()*30;
				local face = ((self:GetPos() + Vector(0,0,400))- pos):Angle();
				    View.origin = pos;
				    View.angles = face;
				return View;
			end
		end
	end
	hook.Add("CalcView", "ImperialATSTView", CalcView)
	
	function ImperialATSTReticle()
	
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingImperialATST");
		local self = p:GetNWEntity("ImperialATST");
		if(Flying and IsValid(self)) then		
		
			local headPoss, headAngg = self:GetBonePosition(self:LookupBone("head_front_gun"))
	
	        surface.SetDrawColor( color_white )		
		
		    local WeaponPos = {
			    Vector(headPoss),
		    }
			
			tr = util.TraceLine({
				start = headPoss,
				endpos = headPoss + headAngg:Up()*10000,
				filter = {self},
			})
			
		    local	vpos = tr.HitPos;
		    local	screen = vpos:ToScreen();
		    local x,y;
		
			 x = 0;
			 y = 0;
			for k,v in pairs(screen) do
				if(k == "x") then
					x = v;
				elseif(k == "y") then
					y = v;
				end
			end
			
		    local w = ScrW()/100*2;
		    local h = w;
		    x = x - w/2;
		    y = y - h/2;
			
			surface.SetMaterial( Material( "hud/reticle.png", "noclamp" ) )
			surface.DrawTexturedRectUV( x , y, w, h, 0, 0, 1, 1 )
			
			SW_Speeder_DrawHull(5000)

		end
	end
	hook.Add("HUDPaint", "ImperialATSTReticle", ImperialATSTReticle)
	
	
end
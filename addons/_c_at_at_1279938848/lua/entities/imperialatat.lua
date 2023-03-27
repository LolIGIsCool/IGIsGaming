ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Base = "impwalkerfix"
ENT.Type = "vehicle"

ENT.PrintName = "AT-AT"
ENT.Author = "Cody Evans"
--- BASE AUTHOR: Liam0102 ---
ENT.Category = "Star Wars Vehicles: Empire"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.AutomaticFrameAdvance =  true; 

ENT.Vehicle = "ImperialATAT"; 
ENT.EntModel = "models/helios/vehicles/atat.mdl"; 


ENT.StartHealth = 50000;

list.Set("SWVehicles", ENT.PrintName, ENT);
if SERVER then

ENT.NextUse = {Use = CurTime(),Fire = CurTime()};
ENT.FireSound = Sound("atat/atat_shoot.wav");


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("imperialatat");
	e:SetPos(tr.HitPos + Vector(0,0,20));
	e:SetModelScale( e:GetModelScale() * 2.3, 0 )
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw+0,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	self.BaseClass.Initialize(self);
	local driverPos = self:GetPos()+self:GetUp()*1000+self:GetForward()*55+self:GetRight()*0;
	local driverAng = self:GetAngles()+Angle(0,-90,0);
	self.Walker2Class = 3;
	self:SpawnChairs(driverPos,driverAng,false)
	self.ForwardSpeed = 50;
	self.BoostSpeed = 50;
	self.AccelSpeed = 10;
	self.HoverMod = 10;
	self.CanBack = false;
	self.StartHover = 20;
	self.WeaponLocations = {}
	self.Bullet = WALKER2CreateBulletStructure(100,"red");
	self:SpawnWeapons();
	self.StandbyHoverAmount = 10;	
	self.SeatPos = {
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*90,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*70,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*50,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*30,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*10,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*-10,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*-30,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*-50,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*-70,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*25+self:GetForward()*-90,self:GetAngles()+Angle(0,180,0)},
		
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*90,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*70,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*50,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*30,self:GetAngles()+Angle(0,180,0)},		
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*10,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*-10,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*-30,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*-50,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*-70,self:GetAngles()+Angle(0,180,0)},
		{self:GetPos()+self:GetUp()*1000+self:GetRight()*-25+self:GetForward()*-90,self:GetAngles()+Angle(0,180,0)},
	}
	self:SpawnSeats();
	self.ExitModifier = {x=0,y=400,z=0}
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
		e.IsImperialATATSeat = true;
		e.ImperialATAT = self;
		self.Seats[k] = e;
	end
end

function ENT:FireBlast(pos,gravity,vel,ang)
    if(self.NextUse.FireBlast < CurTime()) then
        local e = ents.Create("atat_blast");
        e:SetPos(pos);
        e:Spawn();
        e:Activate();
        e:Prepare(self,Sound("atat/atat_shoot.wav"),gravity,vel,ang);
        e:SetColor(Color(255,255,255,1));
		
		self:EmitSound(self.FireSound, 120, math.random(90,115));
    end
end

function ENT:Enter(p,driver)
    self.BaseClass.Enter(self,p,driver);
end

hook.Add("PlayerEnteredVehicle","ImperialATATSeatEnter", function(p,v)
	if(IsValid(v) and IsValid(p)) then
		if(v.IsImperialATATSeat) then
			p:SetNetworkedEntity("ImperialATAT",v:GetParent());
		end
	end
end);

hook.Add("PlayerLeaveVehicle", "ImperialATATSeatExit", function(p,v)
	if(IsValid(p) and IsValid(v)) then
		if(v.IsImperialATATSeat) then
			local e = v.ImperialATAT;
			if(IsValid(e)) then
				p:SetPos(e:GetPos() + e:GetRight()*e.ExitModifier.x + e:GetForward() * e.ExitModifier.y + e:GetUp() * e.ExitModifier.z);
			end
			p:SetNetworkedEntity("ImperialATAT",NULL);
		end
	end
end);

function ENT:PassengerEnter(p)
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
			self:Enter(p,true);
		else
			self:PassengerEnter(p);
		end
	else
		if(p != self.Pilot) then
			self:PassengerEnter(p);
		end
	end
end

local ZAxis = Vector(0,0,1);

function ENT:Think()
	self:NextThink(CurTime())
	self.BaseClass.Think(self)
	
    if(self.Inflight) then
	    if self:GetNWInt("Speed") >= 0 and self:GetNWInt("Speed") < 10 then
			self:ResetSequence( self:LookupSequence( "walking" ) );
			self:SetPlaybackRate( 0.25 )
	    elseif self:GetNWInt("Speed")  >= 10 and self:GetNWInt("Speed") < 15 then
			self:ResetSequence( self:LookupSequence( "walking" ) );
			self:SetPlaybackRate( 0.35 )
	    elseif self:GetNWInt("Speed")  >= 20 and self:GetNWInt("Speed") < 35 then
			self:ResetSequence( self:LookupSequence( "walking" ) );
			self:SetPlaybackRate( 0.45 )
	    elseif self:GetNWInt("Speed")  >= 35 and self:GetNWInt("Speed") < 50 then
			self:ResetSequence( self:LookupSequence( "walking" ) );
			self:SetPlaybackRate( 0.5 )
	    end
	
	    if self:GetNWInt( "Speed" ) <= 0 then
	    	if (self.Pilot:KeyDown(IN_MOVERIGHT))then
		 	    self:ResetSequence(self:LookupSequence( "walking" ))
			    self:SetPlaybackRate( -0.4 )
	    	elseif (self.Pilot:KeyDown(IN_MOVELEFT))then
		 	    self:ResetSequence(self:LookupSequence( "walking" ))
		 	    self:SetPlaybackRate( 0.4 )
			else
		 	    self:SetSequence( self:LookupSequence( "walking" ) );
			    self:ResetSequenceInfo()
		        self:SetPlaybackRate( 0 );
			end
		end
		
		if(self.Pilot:KeyDown(IN_JUMP)) then
		    self.num = 0;
		end
	
        if(IsValid(self.Pilot)) then
	
	    local saveangle = self.Pilot:GetAimVector():Angle()
	    local weaponangle = self:WorldToLocalAngles( saveangle )
	    local aim = weaponangle;
		local LeftGunPos,LeftGunAng = self:GetBonePosition(self:LookupBone("gunA2_part2")) 
		local RightGunPos,RightGunAng = self:GetBonePosition(self:LookupBone("gunB2_part2"))
			
		local p = aim.p*1;
		if(p <= 20 and p >= 92) then
				p = 92;
			elseif(p >= -100 and p <= -50) then
				p = -50;
		end
			
        self:ManipulateBoneAngles(self:LookupBone("neck_part1"), Angle(0,aim.y,p) );	
	
	    if(self.Pilot:KeyDown(IN_ATTACK2)) then
			self:FireWeapons();
		elseif(self.Pilot:KeyDown(IN_ATTACK) and self.NextUse.FireBlast < CurTime()) then
			self:FireBlast(LeftGunPos+self:GetUp()*-50+self:GetForward()*50+self:GetRight()*30,false,100,LeftGunAng:Right()*1000,500);
			self:FireBlast(RightGunPos+self:GetUp()*-50+self:GetForward()*50+self:GetRight()*30,false,100,RightGunAng:Right()*1000,500);
			self.NextUse.FireBlast = CurTime() + 2;
		end
			lastY = aim.y;
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
		
		local bonePossA, boneAnggA = self:GetBonePosition(self:LookupBone("gunB1"))
		local bonePossB, boneAnggB = self:GetBonePosition(self:LookupBone("gunA1"))
		local headPoss, headAngg = self:GetBonePosition(self:LookupBone("head"))
		local e = bonePoss;
		
		local WeaponPos = {
			Vector(bonePossA),
			Vector(bonePossB),
		}
		for k,v in pairs(WeaponPos) do
			tr = util.TraceLine({
				start = headPoss,
				endpos = headPoss + headAngg:Right()*1000000 +headAngg:Forward()*1000,
				filter = {self},
			})
			
			self.Bullet.Src		= v;
			self.Bullet.Attacker = self.Pilot or self;	
			self.Bullet.Dir = (tr.HitPos - v);

			self:FireBullets(self.Bullet)
		end
		self:EmitSound(self.FireSound, 120, math.random(90,110));
		self.NextUse.Fire = CurTime() + 0.5;
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
		Walk=Sound("atat/atat_walk.wav"),
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
		local self = p:GetNWEntity("ImperialATAT", NULL)
		local DriverSeat = p:GetNWEntity("DriverSeat",NULL);
		local ImperialATATSeat = p:GetNWEntity("ImperialATATSeat",NULL);

		if(IsValid(self)) then
			if(IsValid(DriverSeat)) then
				local pos = self:GetPos()+LocalPlayer():GetAimVector():GetNormal()*-650+self:GetUp()*1550;
				local face = ((self:GetPos() + Vector(0,0,1400))- pos):Angle();
					View.origin = pos;
					View.angles = face;
				return View;
			end
			
			if(IsValid(ImperialATATSeat)) then
				local pos = self:GetPos()+LocalPlayer():GetAimVector():GetNormal()*700+self:GetUp()*1220;
				local face = ((self:GetPos() + Vector(0,0,1200))- pos):Angle();
					View.origin = pos;
					View.angles = face;
				return View;
			end
		end
	end
	hook.Add("CalcView", "ImperialATATView", CalcView)

	function ImperialATATReticle()
	
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingImperialATAT");
		local self = p:GetNWEntity("ImperialATAT");
		if(Flying and IsValid(self)) then		
		
			local headPoss, headAngg = self:GetBonePosition(self:LookupBone("head"))
	
	        surface.SetDrawColor( color_white )		
		
		    local WeaponPos = {
			    Vector(headPoss),
			    Vector(headPoss),
		    }
			
			tr = util.TraceLine({
				start = headPoss,
				endpos = headPoss + headAngg:Right()*100000,
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
			
			surface.SetDrawColor( color_white )		
		
		    local WeaponPos = {
			    Vector(headPoss),
		    }
			
			tr = util.TraceLine({
				start = headPoss + self:GetUp()*-170,
				endpos = headPoss + headAngg:Right()*100000,
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
			
			surface.SetMaterial( Material( "hud/missile_reticle.png", "noclamp" ) )
			surface.DrawTexturedRectUV( x , y, w, h, 0, 0, 1, 1 )
			
			SW_Walker2_DrawHull(50000)
			
		end
	end
	hook.Add("HUDPaint", "ImperialATATReticle", ImperialATATReticle)
	
end
AddCSLuaFile();

local _blackberry = _blackberry or {};
_blackberry.movable_door = _blackberry.movable_door or {};
local cfg = axl.movable_door.cfg;
 
DEFINE_BASECLASS( "base_anim" );
ENT.PrintName = "[A.X.L] Movable door";
ENT.Author = "Lestrigon";
ENT.Information = "";
ENT.Category = "A.X.L Movable door";

ENT.Spawnable = false;
ENT.AdminOnly = true;
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT;

local soundPresets = {
	[0] = {
		"doors/default_move.wav", "doors/default_stop.wav", "doors/default_locked.wav"
	},
	[1] = {
		"doors/door_chainlink_move1.wav", "doors/door_chainlink_close2.wav", "doors/default_locked.wav"
	},
	[2] = {
		"doors/door_metal_gate_move1.wav", "doors/door_metal_gate_close1.wav", "doors/default_locked.wav"
	},
	[3] = {
		"doors/door_metal_rusty_move1.wav", "doors/door_metal_large_chamber_close1.wav", "doors/default_locked.wav"
	},
	[4] = {
		"doors/door_metal_thin_move1.wav", "doors/door_metal_thin_close2.wav", "doors/door_metal_thin_open1.wav"
	},
	[5] = {
		"doors/metal_move1.wav", "doors/metal_stop1.wav", "doors/default_locked.wav"
	}
};

function ENT:Initialize()
	if (CLIENT) then return false; end;

	self:SetModel(self.model or "models/hunter/plates/plate1x3.mdl");
	
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(USE_TOGGLE);

	local physObj = self:GetPhysicsObject()

	if (IsValid(physObj)) then
		physObj:EnableMotion(false);
		physObj:Sleep();
		self.physObj = physObj;
	end;

	self:SetMoveType(MOVETYPE_NOCLIP);
	self:SetMoveType(MOVETYPE_PUSH);
	self.openState = nil;
	self.startPos = Vector(0, 0, 0);
end;

function ENT:ToggleOpen()
	self.openState = self.openState or false;
	self.openState = !self.openState;
	self.end_sound = false;
	if (self.openState) then
		self:EmitSound(soundPresets[self.axl_sound or 0][1]);
		self.startTimer = CurTime();
	else
		self:EmitSound(soundPresets[self.axl_sound or 0][1]);
		self.startTimer = CurTime();
	end;
end;

function ENT:GetOffsetVector() return Vector( self:GetOffsetX(), self:GetOffsetY(), self:GetOffsetZ() ) end

function ENT:GetOffsetX()      return math.Clamp( self:GetClientNumber( "offsetx" ), -cvarMaxOffX:GetFloat(), cvarMaxOffX:GetFloat() ) end
function ENT:GetOffsetY()      return math.Clamp( self:GetClientNumber( "offsety" ), -cvarMaxOffY:GetFloat(), cvarMaxOffY:GetFloat() ) end
function ENT:GetOffsetZ()      return math.Clamp( self:GetClientNumber( "offsetz" ), -cvarMaxOffZ:GetFloat(), cvarMaxOffZ:GetFloat() ) end

function ENT:Use(activator)
	if (!activator:IsPlayer()) then return false; end;
	if ((self.startTimer or 0) + math.Clamp(self.axl_use_timeout or 0, 3, 10) > CurTime()) then self:EmitSound(soundPresets[self.axl_sound or 0][3]); return false; end;
	if (self.axl_open_on_use == 0) then self:EmitSound(soundPresets[self.axl_sound or 0][3]); return false; end;
	self:ToggleOpen();
end;

function ENT:EmitCloseSound()
	self:EmitSound(soundPresets[self.axl_sound or 0][2]);
end;

function ENT:MoveLeft(height, width, depth, angles)
	if (self.openState and self:GetPos().x > self.startPos.x-width) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.01, self:GetPos(), self.startPos - Vector(width, 0, 0)));
	elseif (!self.openState and self:GetPos().x < self.startPos.x) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.005, self:GetPos(), self.startPos + Vector(width, 0, 0)));
	else
		if (!self.end_sound) then
			self:EmitCloseSound();
			self.end_sound = true;
		end;
	end;
end;

function ENT:MoveRight(height, width, depth, angles)
	if (self.openState and self:GetPos().x < self.startPos.x+width) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.01, self:GetPos(), self.startPos + Vector(width, 0, 0)));
	elseif (!self.openState and self:GetPos().x > self.startPos.x) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.005, self:GetPos(), self.startPos - Vector(width, 0, 0)));
	else
		if (!self.end_sound) then
			self:EmitCloseSound();
			self.end_sound = true;
		end;
	end;
end;

function ENT:MoveDown(height, width, depth, angles)
	/*local lenght = height;
	if ((angles[1] == 0 or angles[1] == 360) and (angles[3] == 0 or angles[3] == 360)) then
		lenght = depth;
	end;*/
	//print(height, width, depth)
	if (self.openState and self:GetPos().z > self.startPos.z-depth) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.01, self:GetPos(), self.startPos - Vector(0, 0, depth)));
	elseif (!self.openState and self:GetPos().z < self.startPos.z) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.005, self:GetPos(), self.startPos + Vector(0, 0, depth)));
	else
		if (!self.end_sound) then
			self:EmitCloseSound()
			self.end_sound = true;
		end;
	end;
end;

function ENT:MoveUp(height, width, depth, angles)
	if (self.openState and self:GetPos().z < self.startPos.z+depth) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.01, self:GetPos(), self.startPos + Vector(0, 0, depth)));
		//self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.01, self:GetPos(), self:GetPos());
	elseif (!self.openState and self:GetPos().z > self.startPos.z) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.005, self:GetPos(), self.startPos - Vector(0, 0, depth)));
	else
		if (!self.end_sound) then
			self:EmitCloseSound()
			self.end_sound = true;
		end;
	end;
end;

function ENT:MoveForward(height, width, depth)
	if (self.openState and self:GetPos().y < self.startPos.y+height) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.01, self:GetPos(), self.startPos + Vector(0, height, 0)));
	elseif (!self.openState and self:GetPos().y > self.startPos.y) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.005, self:GetPos(), self.startPos - Vector(0, height, 0)));
	else
		if (!self.end_sound) then
			self:EmitCloseSound();
			self.end_sound = true;
		end;
	end;
end;
function ENT:MoveBack(height, width, depth)
	if (self.openState and self:GetPos().y > self.startPos.y-height) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.01, self:GetPos(), self.startPos - Vector(0, height, 0)));
	elseif (!self.openState and self:GetPos().y < self.startPos.y) then
		self:SetPos(LerpVector(math.Clamp(self.axl_speed or 0, 0, 2)/100+0.005, self:GetPos(), self.startPos + Vector(0, height, 0)));
	else
		if (!self.end_sound) then
			self:EmitCloseSound();
			self.end_sound = true;
		end;
	end;
end;

function ENT:OnTakeDamage(dmgInfo)
	if (!cfg["enable_health"]) then return; end;
	if (!dmgInfo:GetAttacker():IsPlayer()) then return; end;
	if (dmgInfo:GetDamage() > 200) then return; end;
	self:SetNWString("axl_health", math.Clamp(self:GetNWString("axl_health", self:GetNWString("axl_door_health", 100)) - dmgInfo:GetDamage(), 0, self:GetNWString("axl_door_health", 100)));

	self:EmitSound("physics/metal/metal_barrel_impact_hard"..math.random(1,7)..".wav");
	if (self:GetNWString("axl_health", 0) <= 0) then
		self:EmitSound("physics/metal/metal_box_break"..math.random(1,2)..".wav");
		self:Remove();
	end;
end;

function ENT:Think()
	if (!IsValid(self.physObj)) then return; end;
	local v_min, v_max = self:WorldSpaceAABB();

	local height = v_min[1] - v_max[1];
	height = height < 0 and height * -1;
	local width = v_min[2] - v_max[2];
	width = width < 0 and width * -1;
	local depth = v_min[3] - v_max[3];
	depth = depth < 0 and depth * -1;

	if (self.openState == nil) then
		self.startPos = self:GetPos();
	end;
	local angles = self:GetAngles():SnapTo("x", 45);
	angles = angles:SnapTo("y", 90);
	angles = angles:SnapTo("z", 90);

	local rotation = angles[3];
	if (rotation == 90 or rotation == -90) then
		local o_height = height;
		local o_width = width;
		height = o_width;
		width = o_height;
	end;

	/*local rotation = angles[1];
	if (rotation == 90 or rotation == -90) then
		local o_width = width;
		local o_depth = depth;
		width = o_depth;
		depth = o_width;
	end;*/
	
	/*---------------------------------------------------------------------------
	Correction
	---------------------------------------------------------------------------*/
	if (self.axl_autopos == 0) then
		height = self.axl_moveDistance;
		width = self.axl_moveDistance;
		depth = self.axl_moveDistance;
	end;
	if (self.axl_moveDistance > 150) then self.axl_moveDistance = 150; end;

	if (self.axl_direction == 0) then
		self:MoveLeft(height, width, depth, angles);
	elseif (self.axl_direction == 1) then
		self:MoveRight(height, width, depth, angles);
	elseif (self.axl_direction == 2) then
		self:MoveUp(height, width, depth, angles);
	elseif (self.axl_direction == 3) then
		self:MoveDown(height, width, depth, angles);
	elseif (self.axl_direction == 4) then
		self:MoveForward(height, width, depth, angles);
	else
		self:MoveBack(height, width, depth, angles);
	end

	if (self.openState and self.axl_autoclose == 1 and self.startTimer + self.axl_autoclose_time < CurTime()) then
		self:ToggleOpen();
	end;

	self:NextThink(CurTime() + 0.001);
	return true;
end;

function ENT:PhysgunPickup(ply)
    return self.openState == nil and true or false;
end

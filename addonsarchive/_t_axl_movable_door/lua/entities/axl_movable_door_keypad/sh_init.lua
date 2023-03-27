ENT.Base = "base_gmodentity";
ENT.Type = "anim";

ENT.Model = Model("models/props_lab/keypad.mdl");

ENT.Spawnable = true;

ENT.Scale = 0.02;
ENT.Value = "";

ENT.PrintName = "[A.X.L]  Keypad";
ENT.Author = "Lestrigon";
ENT.Information = "";
ENT.Category = "A.X.L Movable door";

ENT.Spawnable = false;
ENT.AdminOnly = true;
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT;

ENT.IsAXLKeypad = true;

function ENT:Initialize()
	self:SetModel(self.Model);

	if (CLIENT) then
		self.Mins = self:OBBMins();
		self.Maxs = self:OBBMaxs();

		self.Width2D, self.Height2D = (self.Maxs.y - self.Mins.y) / self.Scale , (self.Maxs.z - self.Mins.z) / self.Scale;
	end

	if (SERVER) then
		self:PhysicsInit(SOLID_VPHYSICS);

		local phys = self:GetPhysicsObject();

		if IsValid(phys) then
			phys:Wake();
			phys:EnableMotion(false);
		end;

		self:SetNWBool("IsInstalled", false);
		self.installCode = "";
		self:SetNWBool("IsFingerPrint", false);
		self:SetNWString("Mode", "install_required");
		self.fingerStore = {};

	end;
end;
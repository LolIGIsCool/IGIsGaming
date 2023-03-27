AddCSLuaFile("cl_init.lua");
AddCSLuaFile("cl_maths.lua");
AddCSLuaFile("cl_panel.lua");
AddCSLuaFile("sh_init.lua");

include("sh_init.lua");

axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;

function ENT:Action()
	for k,v in pairs(ents.GetAll()) do // Door open
		if (!IsValid(v) or v:GetClass() != "axl_movable_door_main") then continue; end;
		if (FPP.entGetOwner(v) != FPP.entGetOwner(self)) then continue; end;
		if (tostring(v.axl_door_id) != tostring(self:GetNWString("axl_id"))) then continue; end;

		v:ToggleOpen();
	end;
end;

function ENT:ErrorInstall()
	if (((self.timeOut or 0) + self:GetNWInt("axl_timeout", 0)) > SysTime()) then return; end;
	self.timeOut = SysTime();
	self:EmitSound(cfg["keypad_err"]);
	self:SetNWString("alert", "INSTALL REQUIRED");
	self:SetNWInt("alert_color", 3);
	self:SetNWBool("locked", true);
	timer.Simple(self:GetNWInt("axl_timeout", 0), function()
		if (!self or !IsValid(self)) then return; end;
		self:SetNWString("alert", "");
		self:SetNWBool("locked", false);
	end);
end;

function ENT:EnterToProgrammMode()
	if (self:GetNWString("Mode") == "installing") then
		self:SetNWString("alert", "");
		self:SetNWBool("locked", false);
		self:SetNWBool("Mode", "normal");
		return;
	end;

	self:SetNWBool("Mode", "installing");
	self:EmitSound(cfg["keypad_ok"]);
	self:SetNWString("alert", "RECOVERY MODE");
	self:SetNWInt("alert_color", 4);
	self:SetNWBool("locked", true);
end;

netstream.Hook("axl.movable_door.keypadFingerprint", function(ply, data)
	local ent = data[1];
	local data = data[2];	
	if (!ent or !IsValid(ent) or ent:IsPlayer() or FPP.entGetOwner(ent) != ply or ent:GetClass() != "axl_movable_door_keypad") then return; end;
	if (!data or !istable(data) or table.Count(data) < 2) then return; end;

	local action = data[1];
	local data = data[2];

	ent.fingerStore[data] = !(action == "remove");
	ent:SetNWBool("IsFingerPrint", true);
end);

netstream.Hook("axl.movable_door.keypadAction", function(ply, data)
	local ent = data[1];
	local code = data[2];
	if (!ent or !IsValid(ent) or ent:GetClass() != "axl_movable_door_keypad") then return; end;
	if (!code or !istable(code)) then return; end;
	if (ent:GetPos():DistToSqr(ply:GetPos()) > 200*200) then return; end;

	if (((ent.timeOut or 0) + ent:GetNWInt("axl_timeout", 0)) > SysTime()) then return; end;
	if (ent:GetNWString("Mode") == "install_required") then
		ent.timeOut = SysTime();
		ent:EmitSound(cfg["keypad_err"]);
		ent:SetNWString("alert", "INSTALL REQUIRED");
		ent:SetNWInt("alert_color", 3);
		ent:SetNWBool("locked", true);
		timer.Simple(ent:GetNWInt("axl_timeout", 0), function()
			if (!ent or !IsValid(ent)) then return; end;
			ent:SetNWString("alert", "");
			ent:SetNWBool("locked", false);
		end);
		return;
	end;

	local _t = {};
	for k,v in pairs(code) do
		_t[v] = k;
	end
	local endCode = "";
	for k,v in pairs(_t) do
		endCode = endCode .. v;
	end;
	if (ent:GetNWString("Mode") == "install") then
		if (table.Count(code) < 2) then
			ent.timeOut = SysTime();
			ent:EmitSound(cfg["keypad_err"]);
			ent:SetNWString("alert", "TOO SHORT");
			ent:SetNWInt("alert_color", 2);
			timer.Simple(ent:GetNWInt("axl_timeout", 0), function()
				if (!ent or !IsValid(ent)) then return; end;
				ent:SetNWString("alert", "");
				ent:SetNWBool("locked", false);
			end)
			return;
		end;

		ent.timeOut = SysTime();
		ent:SetNWBool("IsInstalled", true);
		ent:SetNWBool("Mode", "normal");
		ent.installCode = tostring(endCode);
		ent:EmitSound(cfg["keypad_ok"]);
		ent:SetNWString("alert", "SETUP COMPLETE");
		ent:SetNWInt("alert_color", 1);
		ent:SetNWBool("locked", true);
		timer.Simple(ent:GetNWInt("axl_timeout", 0), function()
			if (!ent or !IsValid(ent)) then return; end;
			ent:SetNWString("alert", "");
			ent:SetNWBool("locked", false);
		end)
		return;
	end;

	if (ent:GetNWBool("IsFingerPrint", false)) then
		if (FPP.entGetOwner(ent) == ply) then
			ent.timeOut = SysTime();
			ent:EmitSound(cfg["keypad_ok"]);
			ent:SetNWString("alert", "FINGERPRINT GRANTED");
			ent:SetNWInt("alert_color", 1);
			timer.Simple(ent:GetNWInt("axl_timeout", 0), function()
				if (!ent or !IsValid(ent)) then return; end;
				ent:SetNWString("alert", "");
				ent:SetNWBool("locked", false);
			end)

			ent:Action();
			return;
		end;
		if (ent.fingerStore[ply:SteamID()] or ent.fingerStore[ply:GetJobTable().Count] or ent.fingerStore[ply:GetJobTable().Clearance] ) then
			ent.timeOut = SysTime();
			ent:EmitSound(cfg["keypad_ok"]);
			ent:SetNWString("alert", "FINGERPRINT GRANTED");
			ent:SetNWInt("alert_color", 1);
			timer.Simple(ent:GetNWInt("axl_timeout", 0), function()
				if (!ent or !IsValid(ent)) then return; end;
				ent:SetNWString("alert", "");
				ent:SetNWBool("locked", false);
			end)

			ent:Action();
			return;
		end;
	end;

	if (tostring(ent.installCode or "") != tostring(endCode)) then
		ent.timeOut = SysTime();
		ent:EmitSound(cfg["keypad_err"]);
		ent:SetNWString("alert", "ACCESS DENIED");
		ent:SetNWInt("alert_color", 2);
		timer.Simple(ent:GetNWInt("axl_timeout", 0), function()
			if (!ent or !IsValid(ent)) then return; end;
			ent:SetNWString("alert", "");
			ent:SetNWBool("locked", false);
		end)
		return;
	else
		ent.timeOut = SysTime();
		ent:EmitSound(cfg["keypad_ok"]);
		ent:SetNWString("alert", "ACCESS GRANTED");
		ent:SetNWInt("alert_color", 1);
		timer.Simple(ent:GetNWInt("axl_timeout", 0), function()
			if (!ent or !IsValid(ent)) then return; end;
			ent:SetNWString("alert", "");
			ent:SetNWBool("locked", false);
		end)

		ent:Action();
		return;
	end;
end);
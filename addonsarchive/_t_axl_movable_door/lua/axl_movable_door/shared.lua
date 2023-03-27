axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;

/*---------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------*/
if (CLIENT) then
	axl_local_inv_entsStore = {};
	local entsToTrace = {
		"axl_movable_door_main", "axl_movable_door_button", "axl_movable_door_keypad"
	};
	local function isView(ent)
		local viewEnt = LocalPlayer():GetEyeTrace().Entity;
		return viewEnt == ent;
	end;

	local function DrawDoorHUD()
		for k,v in pairs(axl_local_inv_entsStore) do
			if (v == nil) then continue; end;
			if (v:GetClass() != "axl_movable_door_main") then continue; end;
			v._axl_a = v._axl_a or 0;
			v._axl_t = v._axl_t or 0;
			if (LocalPlayer():GetPos():DistToSqr(v:GetPos()) < 200*200 and isView(v)) then
				v._axl_a = Lerp(FrameTime()*3, v._axl_a, 1);
				v._axl_t = CurTime();
			end;

			if ((LocalPlayer():GetPos():DistToSqr(v:GetPos()) > 200*200 or !isView(v)) and v._axl_t + 5 > CurTime()) then
				v._axl_a = Lerp(FrameTime()*6, v._axl_a, 0);
			end;

			local pos = v:GetPos():ToScreen();
			-- Draw info

			draw.SimpleTextOutlined(v:GetNWString("axl_door_name"), "AXL MD 24", pos.x, pos.y, ColorAlpha(cfg["color"], 255*v._axl_a), 1, 1, 1, Color(0, 0, 0, 255*v._axl_a));
			draw.SimpleTextOutlined("unqiue id : "..v:GetNWString("axl_door_id"), "AXL MD 15", pos.x, pos.y+19, Color(255, 255, 255, 255*v._axl_a), 1, 1, 1, Color(0, 0, 0, 255*v._axl_a));
			if (cfg["enable_health"]) then
				draw.SimpleTextOutlined("Health", "AXL MD 15", pos.x-75, pos.y+19*2+2, Color(255, 255, 255, 255*v._axl_a), 0, 0, 1, Color(0, 0, 0, 255*v._axl_a));
				draw.SimpleTextOutlined(math.floor(v:GetNWString("axl_health", v:GetNWString("axl_door_health", 100))).." / "..v:GetNWString("axl_door_health", 100), "AXL MD 15", pos.x+75, pos.y+19*2+2, Color(255, 255, 255, 255*v._axl_a), 2, 0, 1, Color(0, 0, 0, 255*v._axl_a));
				draw.RoundedBox(0, pos.x - 75, pos.y + 19*2, 150, 2, Color(0, 0, 0, 150*v._axl_a));
				draw.RoundedBox(0, pos.x - 75, pos.y + 19*2, 150/v:GetNWString("axl_door_health", 100)*v:GetNWString("axl_health", v:GetNWString("axl_door_health", 100)), 2, ColorAlpha(cfg["color"], 150*v._axl_a));
			end;
		end;
	end;

	local function DrawButtonHUD()
		for k,v in pairs(axl_local_inv_entsStore) do
			if (v == nil) then continue; end;
			if (v:GetClass() != "axl_movable_door_button") then continue; end;
			v._axl_a = v._axl_a or 0;
			v._axl_t = v._axl_t or 0;
			if (LocalPlayer():GetPos():DistToSqr(v:GetPos()) < 200*200 and isView(v)) then
				v._axl_a = Lerp(FrameTime()*3, v._axl_a, 1);
				v._axl_t = CurTime();
			end;

			if ((LocalPlayer():GetPos():DistToSqr(v:GetPos()) > 200*200 or !isView(v)) and v._axl_t + 5 > CurTime()) then
				v._axl_a = Lerp(FrameTime()*6, v._axl_a, 0);
			end;

			local pos = v:GetPos():ToScreen();
			-- Draw info

			draw.SimpleTextOutlined(v:GetNWString("axl_name"), "AXL MD 24", pos.x, pos.y, ColorAlpha(cfg["color"], 255*v._axl_a), 1, 1, 1, Color(0, 0, 0, 255*v._axl_a));
			draw.SimpleTextOutlined("unqiue id : "..v:GetNWString("axl_id"), "AXL MD 15", pos.x, pos.y+19, Color(255, 255, 255, 255*v._axl_a), 1, 1, 1, Color(0, 0, 0, 255*v._axl_a));

		end;
	end;

	local function DrawKeypadHUD()
		for k,v in pairs(axl_local_inv_entsStore) do
			if (v == nil) then continue; end;
			if (v:GetClass() != "axl_movable_door_keypad") then continue; end;
			v._axl_a = v._axl_a or 0;
			v._axl_t = v._axl_t or 0;
			if (LocalPlayer():GetPos():DistToSqr(v:GetPos()) < 200*200 and isView(v)) then
				v._axl_a = Lerp(FrameTime()*3, v._axl_a, 1);
				v._axl_t = CurTime();
			end;

			if ((LocalPlayer():GetPos():DistToSqr(v:GetPos()) > 200*200 or !isView(v)) and v._axl_t + 5 > CurTime()) then
				v._axl_a = Lerp(FrameTime()*6, v._axl_a, 0);
			end;

			local pos = v:GetPos():ToScreen();
			pos.y = pos.y + 95 - 95*(200)/math.Clamp(v:GetPos():Distance(LocalPlayer():GetPos()), 0, 200);

			draw.SimpleTextOutlined(v:GetNWString("axl_name"), "AXL MD 24", pos.x, pos.y, ColorAlpha(cfg["color"], 255*v._axl_a), 1, 1, 1, Color(0, 0, 0, 255*v._axl_a));
			draw.SimpleTextOutlined("unqiue id : "..v:GetNWString("axl_id"), "AXL MD 15", pos.x, pos.y+24, Color(255, 255, 255, 255*v._axl_a), 1, 1, 1, Color(0, 0, 0, 255*v._axl_a));

			if (v:GetNWBool("IsFingerPrint", false)) then
				draw.SimpleTextOutlined("Fingerprint are enabled", "AXL MD 15", pos.x, pos.y+24*2, Color(255, 255, 255, 255*v._axl_a), 1, 1, 1, Color(0, 0, 0, 255*v._axl_a));
			end;
		end;
	end;

	hook.Add("HUDPaint", "axl.movable_door.hud", function()
		for k,v in pairs(axl_local_inv_entsStore) do
			if (!v or !IsValid(v) or !IsEntity(v) or v:IsWorld()) then axl_local_inv_entsStore[k] = nil; continue; end;
		end;
		local viewEnt = LocalPlayer():GetEyeTrace().Entity;
		if (viewEnt and IsValid(viewEnt) and !viewEnt:IsWorld() and !viewEnt:IsPlayer() and table.HasValue(entsToTrace, viewEnt:GetClass()) and !table.HasValue(axl_local_inv_entsStore, viewEnt)) then
			table.insert(axl_local_inv_entsStore, viewEnt);
		end;
		DrawDoorHUD();
		DrawButtonHUD();
		DrawKeypadHUD();
	end);


	local toggled = false;
	hook.Add("Think", "axl.movable_door.keypad", function()	// Item pickup 76561198065942036 
		local keys = {}; 
		for k, v in pairs({KEY_E}) do
			keys[v] = false;
		end;
		for k, v in pairs(keys) do
			keys[k] = input.IsKeyDown(k);
		end;

		allPressed = true;
		for k, v in pairs(keys) do
			if (!v) then
				allPressed = false;
			end;
		end;

		if (allPressed and !toggled) then
			toggled = true;
			local entity_item = LocalPlayer():GetEyeTrace().Entity;
			if (entity_item and IsValid(entity_item) and entity_item:GetClass() == "axl_movable_door_keypad" and entity_item:GetPos():DistToSqr(LocalPlayer():GetPos()) <= 100*100 ) then
				entity_item:ClientPress();
			end;
		elseif (!allPressed and toggled) then
			toggled = false;
		end;
	end);

end;
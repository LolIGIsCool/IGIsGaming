axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;
local core = axl.movable_door;

for k, v in pairs({11, 13, 15, 17, 19, 21, 24}) do
	surface.CreateFont("AXL MD "..v, {font = "Roboto", size = v, weight = 400});
end;

local x, y, sx, sy = ScrW(), ScrH(), ScrW()*0.3, ScrH()*0.7;

function core:OpenFingerSettings()
	if (core.menu and IsValid(core.menu)) then core.menu:Close(); end;

	local frame = vgui.Create("DFrame");
	core.menu = frame;

	frame:SetSize(sx, sy);
	frame:SetPos(x/2-sx/2, y/2-sy/2);
	frame:MakePopup();
	frame:SetTitle("");
	//frame:SetDraggable(false);
	frame:ShowCloseButton(false);
	frame.Paint = function(self, w, h)
		draw.RoundedBox(6, 0, 0, w, h, Color(35, 35, 40));
		draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 150));

		draw.RoundedBox(6, 0, 0, w, 20+19, Color(0, 0, 0, 150));

		draw.SimpleText("Keypad editor", "AXL MD 19", w/2, 10, Color(255, 255, 255), 1, 0);
		draw.SimpleText("Fingerprint access settings", "AXL MD 17", w/2, 10+10*2+19, Color(255, 255, 255, 255), 1, 0);
	end;

	local width, _ = surface.GetTextSize("Jobs");
	local btn_panel = vgui.Create("DButton", frame);
	btn_panel:SetSize(40,40);
	btn_panel:SetPos(sx-40, 0);
	btn_panel:SetText("");
	btn_panel.Paint = function(self, w, h)
		self.lerp = Lerp(FrameTime()*5, self.lerp or 0, self.Active and 1 or 0);
		draw.RoundedBox(6, w/2-10, h/2-10, 20, 20, Color(255, 255, 255, 1+5*self.lerp));
		draw.SimpleText("X", "AXL MD 15", w/2, h/2, Color(255, 255, 255, 75 - 75*self.lerp), 1, 1);
		draw.SimpleText("X", "AXL MD 15", w/2, h/2, ColorAlpha(cfg["color"], 255*self.lerp), 1, 1);
	end;
	btn_panel.OnCursorEntered = function(self)
		self.Active = true;
	end;
	btn_panel.OnCursorExited = function(self)
		self.Active = false;
	end;
	btn_panel.DoClick = function()
		if (core.menu and IsValid(core.menu)) then core.menu:Close(); end;
	end;

	surface.SetFont("AXL MD 15");
	local width1, _ = surface.GetTextSize("Players");
	local btn_panel = vgui.Create("DButton", frame);
	btn_panel:SetSize(width1,18);
	btn_panel:SetPos(10, 10*4+19+17);
	btn_panel:SetText("");
	btn_panel.Paint = function(self, w, h)
		self.lerp = Lerp(FrameTime()*5, self.lerp or 0, self.Active and 1 or 0);
		draw.SimpleText("Players", "AXL MD 15", 0, 0, Color(255, 255, 255, 255 - 255*self.lerp), 0, 0);
		draw.SimpleText("Players", "AXL MD 15", 0, 0, ColorAlpha(cfg["color"], 255*self.lerp), 0, 0);
		draw.RoundedBox(0, 0, h-1, w, 1, Color(255, 255, 255, 10+25*self.lerp));
	end;
	btn_panel.OnCursorEntered = function(self)
		self.Active = true;
	end;
	btn_panel.OnCursorExited = function(self)
		self.Active = false;
	end;
	btn_panel.DoClick = function()
		core:BuildFriendList(core.menu);
	end;

	local width, _ = surface.GetTextSize("Jobs");
	local btn_panel = vgui.Create("DButton", frame);
	btn_panel:SetSize(width,18);
	btn_panel:SetPos(10*3+width1, 10*4+19+17);
	btn_panel:SetText("");
	btn_panel.Paint = function(self, w, h)
		self.lerp = Lerp(FrameTime()*5, self.lerp or 0, self.Active and 1 or 0);
		draw.SimpleText("Jobs", "AXL MD 15", 0, 0, Color(255, 255, 255, 255 - 255*self.lerp), 0, 0);
		draw.SimpleText("Jobs", "AXL MD 15", 0, 0, ColorAlpha(cfg["color"], 255*self.lerp), 0, 0);
		draw.RoundedBox(0, 0, h-1, w, 1, Color(255, 255, 255, 10+25*self.lerp));
	end;
	btn_panel.OnCursorEntered = function(self)
		self.Active = true;
	end;
	btn_panel.OnCursorExited = function(self)
		self.Active = false;
	end;
	btn_panel.DoClick = function()
		core:BuildJobList(core.menu);
	end;

	local width2, _ = surface.GetTextSize("Clearances");
	local btn_panel = vgui.Create("DButton", frame);
	btn_panel:SetSize(width2,18);
	btn_panel:SetPos(10*9+width, 10*4+19+17);
	btn_panel:SetText("");
	btn_panel.Paint = function(self, w, h)
		self.lerp = Lerp(FrameTime()*5, self.lerp or 0, self.Active and 1 or 0);
		draw.SimpleText("Clearances", "AXL MD 15", 0, 0, Color(255, 255, 255, 255 - 255*self.lerp), 0, 0);
		draw.SimpleText("Clearances", "AXL MD 15", 0, 0, ColorAlpha(cfg["color"], 255*self.lerp), 0, 0);
		draw.RoundedBox(0, 0, h-1, w, 1, Color(255, 255, 255, 10+25*self.lerp));
	end;
	btn_panel.OnCursorEntered = function(self)
		self.Active = true;
	end;
	btn_panel.OnCursorExited = function(self)
		self.Active = false;
	end;
	btn_panel.DoClick = function()
		core:BuildClearList(core.menu);
	end;

	frame.players = vgui.Create("DScrollPanel", frame);
	frame.players:SetSize(sx-20, frame:GetTall()-110);
	frame.players:SetPos(10, 100);
	frame.players.Paint = function(self, w, h)
	end;

	frame.players.item_list = vgui.Create( "DIconLayout", frame.players )
	frame.players.item_list:Dock(FILL);
	frame.players.item_list:SetSpaceX(0);
	frame.players.item_list:SetSpaceY(2);

	local sbar = frame.players:GetVBar();
	sbar:SetWide(2);
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end

	core:BuildFriendList(frame);
end;

function core:BuildFriendList(frame)
	frame.players.item_list:Clear();

	for k,v in pairs(player.GetAll()) do
		
		local btn_panel = vgui.Create("DButton", frame.players.item_list);
		btn_panel:SetSize(sx-24,22);
		btn_panel:SetText("");
		btn_panel.allowed = core._FPM_store[v:SteamID()] or false;
		btn_panel.Paint = function(self, w, h)
			self.lerp = Lerp(FrameTime()*5, self.lerp or 0, self.Active and 1 or 0);
			self.lerp2 = Lerp(FrameTime()*5, self.lerp2 or 0, self.allowed and 1 or 0);

			draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 50+50*self.lerp));
			draw.RoundedBox(6, 0, 0, w, h, Color(0, 150, 0, 75*self.lerp2));

			draw.SimpleText(v:Name(), "AXL MD 15", 10, h/2, Color(255, 255, 255, 150 - 150*self.lerp), 0, 1);
			draw.SimpleText(v:Name(), "AXL MD 15", 10, h/2, ColorAlpha(self.allowed and Color(255, 255, 255) or cfg["color"], 255*self.lerp), 0, 1);

			draw.SimpleText("GRANTED", "AXL MD 13", w-10, h/2, Color(255, 255, 255, 255*self.lerp2), 2, 1);
		end;
		btn_panel.OnCursorEntered = function(self)
			self.Active = true;
		end;
		btn_panel.OnCursorExited = function(self)
			self.Active = false;
		end;
		btn_panel.DoClick = function(self)
			self.allowed = !self.allowed;
			netstream.Start("axl.movable_door.keypadFingerprint", {core._FPM_ent, {self.allowed and "add" or "remove", v:SteamID()}});
		end;
	end;
	timer.Simple(0.2, function() if IsValid(frame) then frame.players:Rebuild(); end; end);
end;

function core:BuildJobList(frame)
	frame.players.item_list:Clear();

	for k,v in pairs(TeamTable) do
		for a,b in pairs(v) do
		
			local btn_panel = vgui.Create("DButton", frame.players.item_list);
			btn_panel:SetSize(sx-24,22);
			btn_panel:SetText("");
			btn_panel.allowed = core._FPM_store[v.Count] or false;
			btn_panel.Paint = function(self, w, h)
				self.lerp = Lerp(FrameTime()*5, self.lerp or 0, self.Active and 1 or 0);
				self.lerp2 = Lerp(FrameTime()*5, self.lerp2 or 0, self.allowed and 1 or 0);

				draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 50+50*self.lerp));
				draw.RoundedBox(6, 0, 0, w, h, Color(0, 150, 0, 75*self.lerp2));

				draw.SimpleText(k.." - "..b.Name, "AXL MD 15", 10, h/2, Color(255, 255, 255, 150 - 150*self.lerp), 0, 1);
				draw.SimpleText(k.." - "..b.Name, "AXL MD 15", 10, h/2, ColorAlpha(self.allowed and Color(255, 255, 255) or cfg["color"], 255*self.lerp), 0, 1);

				draw.SimpleText("GRANTED", "AXL MD 13", w-10, h/2, Color(255, 255, 255, 255*self.lerp2), 2, 1);
			end;
			btn_panel.OnCursorEntered = function(self)
				self.Active = true;
			end;
			btn_panel.OnCursorExited = function(self)
				self.Active = false;
			end;
			btn_panel.DoClick = function(self)
				self.allowed = !self.allowed;
				netstream.Start("axl.movable_door.keypadFingerprint", {core._FPM_ent, {self.allowed and "add" or "remove", b.Count}});
			end;
		end
	end;
	timer.Simple(0.2, function() if IsValid(frame) then frame.players:Rebuild(); end; end);
end;

local LelClearTable = {"0","1","2","3","4","5","6","ALL ACCESS","AREA ACCESS"}

function core:BuildClearList(frame)
	frame.players.item_list:Clear();

	for k,v in pairs(LelClearTable) do
		
		local btn_panel = vgui.Create("DButton", frame.players.item_list);
		btn_panel:SetSize(sx-24,22);
		btn_panel:SetText("");
		btn_panel.allowed = core._FPM_store[v] or false;
		btn_panel.Paint = function(self, w, h)
			self.lerp = Lerp(FrameTime()*5, self.lerp or 0, self.Active and 1 or 0);
			self.lerp2 = Lerp(FrameTime()*5, self.lerp2 or 0, self.allowed and 1 or 0);

			draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 50+50*self.lerp));
			draw.RoundedBox(6, 0, 0, w, h, Color(0, 150, 0, 75*self.lerp2));

			draw.SimpleText(v, "AXL MD 15", 10, h/2, Color(255, 255, 255, 150 - 150*self.lerp), 0, 1);
			draw.SimpleText(v, "AXL MD 15", 10, h/2, ColorAlpha(self.allowed and Color(255, 255, 255) or cfg["color"], 255*self.lerp), 0, 1);

			draw.SimpleText("GRANTED", "AXL MD 13", w-10, h/2, Color(255, 255, 255, 255*self.lerp2), 2, 1);
		end;
		btn_panel.OnCursorEntered = function(self)
			self.Active = true;
		end;
		btn_panel.OnCursorExited = function(self)
			self.Active = false;
		end;
		btn_panel.DoClick = function(self)
			self.allowed = !self.allowed;
			netstream.Start("axl.movable_door.keypadFingerprint", {core._FPM_ent, {self.allowed and "add" or "remove", v}});
		end;
	end;
	timer.Simple(0.2, function() if IsValid(frame) then frame.players:Rebuild(); end; end);
end;

netstream.Hook("axl.movable_door.FingerprintMenu", function(data)
	core._FPM_ent = data[1];
	core._FPM_store = data[2];
	core.OpenFingerSettings();
end);
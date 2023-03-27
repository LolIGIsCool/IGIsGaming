axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;

local COLOR_GREEN = Color(0, 255, 0);
local COLOR_RED = 	Color(255, 0, 0);

surface.CreateFont("KeypadAbort", {font = "Roboto", size = 45, weight = 900})
surface.CreateFont("KeypadButtons", {font = "Roboto", size = 35, weight = 900})
surface.CreateFont("KeypadOK", {font = "Roboto", size = 55, weight = 900})

function ENT:ClientPress()
	local w, h = self.Width2D, self.Height2D;
	local x, y = self:CalculateCursorPos();
	self.ActiveLines = self.ActiveLines or {};
	local circleSize = (w-15*4)/3;
	
	if (self:GetNWBool("locked")) then return; end;

	if (!self._inUse) then
		for i = 1, 3 do // BG Cursor
			for n = 1, 3 do
				self.lerps[i..n] = self.lerps[i..n] or 0;
				local sx, sy = 15+(circleSize+15)*(n-1), 15+75+15+125+15+(i-1)*(circleSize+15);
				local ex, ey = sx+circleSize, sy+circleSize;
				if 	sx < x and ex > x and
					sy < y and ey > y 
				then
					self._inUse = true;
				end;
			end;
		end;
	else
		self._inUse = !(self._inUse or false);
	end;

	if (x > 0 and y > 0) then
		/*---------------------------------------------------------------------------
		OPEN BUTTON
		---------------------------------------------------------------------------*/
		if 	25 < x and w-25 > x and
			115 < y and 115+50 > y 
		then
			self:SendToServer();
		end;

		/*---------------------------------------------------------------------------
		CLEAR BUTTON
		---------------------------------------------------------------------------*/
		if 	25 < x and w-25 > x and
			115+50+15 < y and 115+15+50*2 > y 
		then
			self.ActiveLines = {};
			self._inUse = false;
			self:EmitSound(cfg["keypad_ok"]);
		end;
	end;
end;

function ENT:SendToServer()
	if (self:GetNWBool("locked", false)) then return; end;
	netstream.Start("axl.movable_door.keypadAction", {self, self.ActiveLines});
	self.ActiveLines = {};
	self._inUse = false;
end;

function ENT:Paint(w, h, x, y)
	self._lastX = (x == 0) and self._lastX or x;
	self._lastY = (y == 0) and self._lastY or y;
	self.dActive = (x == 0 and y == 0) and 0 or 1;
	self.dLerp = Lerp(FrameTime()*5, self.dLerp or 0, self.dActive);
	self.lerps = self.lerps or {};
	self.lerps2 = self.lerps2 or {};
	self.ActiveLines = self.ActiveLines or {};
	self.lastActiveTime = self.dActive == 1 and 0 or (self.lastActiveTime != 0) and self.lastActiveTime or CurTime();
	if (self.dActive == 0 and table.Count(self.ActiveLines) > 0 and self.lastActiveTime+1 < CurTime()) then
		self.ActiveLines = {};
		self._inUse = false;
	end;
	local circleSize = (w-15*4)/3;

	if (self:GetNWInt("alert", "") != "") then
		self.notify = 1;
	else
		self.notify = 0;
	end;

	
	self.overlayLerp = Lerp(FrameTime()*6, self.overlayLerp or 0, self.notify);

	local function GetCirclePos(x, y)
		x = x or 0;
		y = y or 0;
		return 15+(circleSize+15)*(x-1)+circleSize/2, 15+75+15+125+15+(y-1)*(circleSize+15)+circleSize/2;
	end;

	/*---------------------------------------------------------------------------
	IN USE
	---------------------------------------------------------------------------*/
	if (self._inUse) then
		for i = 1, 3 do // BG Cursor
			for n = 1, 3 do
				self.lerps[i..n] = self.lerps[i..n] or 0;
				local sx, sy = 15+(circleSize+15)*(n-1), 15+75+15+125+15+(i-1)*(circleSize+15);
				local ex, ey = sx+circleSize, sy+circleSize;
				if 	sx < x and ex > x and
					sy < y and ey > y 
				then
					if (!self.ActiveLines[i..":"..n]) then
						self.ActiveLines[i..":"..n] = table.Count(self.ActiveLines) + 1;
						self:EmitSound(cfg["keypad_use"]);
					end;
				end;
			end;
		end;
	end;
	/*---------------------------------------------------------------------------
	END IN USE
	---------------------------------------------------------------------------*/

	draw.RoundedBox(0, 0, 0, w, h, cfg["keypad_color"]);

	draw.RoundedBox(0, 15, 15, w-30, 75, Color(0, 0, 0, 75));
	draw.RoundedBox(0, 15, 15+75+15, w-30, 130, Color(0, 0, 0, 35));

	////// OPEN
	draw.RoundedBox(0, 15+10, 15+75+15+10, w-50, 50, Color(0, 0, 0, 65));
	if 	25 < x and w-25 > x and
		115 < y and 115+50 > y 
	then
		draw.RoundedBox(0, 15+10, 15+75+15+10, w-50, 50, Color(0, 0, 0, 50));
	end;
	////// CLEAR
	draw.RoundedBox(0, 15+10, 15+75+15+10*2+50, w-50, 50, Color(0, 0, 0, 65));
	if 	25 < x and w-25 > x and
		115+50+15 < y and 115+15+50*2 > y 
	then
		draw.RoundedBox(0, 15+10, 15+75+15+10*2+50, w-50, 50, Color(0, 0, 0, 50));
	end;

	if (self:GetNWString("Mode") == "install_required") then
		draw.SimpleText("INSTALL REQUIRED", "KeypadButtons", w/2, 15+75/2, Color(255, 255, 255, 255-255*self.overlayLerp), 1, 1);
	elseif (self:GetNWString("Mode") == "install") then
		draw.SimpleText("INSTALLING...", "KeypadButtons", w/2, 15+75/2, Color(255, 255, 255, 255-255*self.overlayLerp), 1, 1);
	else
		draw.SimpleText("LOCKED", "KeypadAbort", w/2, 15+75/2, Color(255, 255, 255, 255-255*self.overlayLerp), 1, 1);
	end;

	if (self:GetNWString("Mode") == "install") then
		draw.SimpleText("Set key", "KeypadButtons", w/2, 15+75+15+10+50/2, cfg["color"], 1, 1);
	else
		draw.SimpleText("Ok", "KeypadButtons", w/2, 15+75+15+10+50/2, Color(255, 255, 255, 150), 1, 1);
	end;
	
	draw.SimpleText("Clear", "KeypadButtons", w/2, 15+75+15+10*2+50+50/2, Color(255, 255, 255, 150), 1, 1);


	local smCircle = circleSize*0.3;
	local mdircle = circleSize*0.7*self.dLerp;
	local outCircle = circleSize*(0.2+0.4*self.dLerp);

	/**/
	local onx, ony = 0, 0;
	local i = 1;
	local drawTable = {};
	for k, v in pairs(self.ActiveLines) do
		drawTable[v] = string.Explode(":",k);
	end;

	for k,v in pairs(drawTable) do
		local nx, ny = v[2], v[1];

		//print("SX - "..nx.." SY - "..ny.." EX - "..onx.." EY - "..ony.."")
		if (i > 1) then
			local sx, sy = GetCirclePos(tonumber(nx), tonumber(ny));
			local ex, ey = GetCirclePos(tonumber(onx), tonumber(ony));
			surface.SetDrawColor( 0, 0, 0, 150*self.dLerp );
			surface.DrawLine(sx, sy, ex, ey);
			surface.DrawLine(sx+1, sy+1, ex+1, ey+1);
			surface.DrawLine(sx-1, sy-1, ex-1, ey-1);
		end;
		if (i >= 9) then
			self._inUse = false;
			self:SendToServer();
		end;
		if (i == table.Count(self.ActiveLines) and self._inUse) then
			local sx, sy = GetCirclePos(tonumber(nx), tonumber(ny));
			surface.SetDrawColor( 0, 0, 0, 150*self.dLerp );
			surface.DrawLine(sx, sy, self._lastX, self._lastY);
			surface.DrawLine(sx+1, sy+1, self._lastX+1, self._lastY);
			surface.DrawLine(sx-1, sy, self._lastX-1, self._lastY);
			continue;
		end;
		i = i + 1;
		onx, ony = nx, ny;
	end;

	for i = 1, 3 do // BG Cursor
		for n = 1, 3 do
			self.lerps[i..n] = self.lerps[i..n] or 0;
			local sx, sy = 15+(circleSize+15)*(n-1), 15+75+15+125+15+(i-1)*(circleSize+15);
			local ex, ey = sx+circleSize, sy+circleSize;
			if 	sx < x and ex > x and
				sy < y and ey > y 
			then
				self.lerps[i..n] = Lerp(FrameTime()*8, self.lerps[i..n] or 0, 1);
			else 
				if (math.floor((self.lerps[i..n] or 0)*10) > 0) then
					self.lerps[i..n] = Lerp(FrameTime()*8, self.lerps[i..n] or 0, 0);
				end;
			end
			draw.RoundedBox(circleSize/2*self.lerps[i..n], 15+(circleSize+15)*(n-1)+circleSize/2-(circleSize/2)*self.lerps[i..n], 15+75+15+125+15+(i-1)*(circleSize+15)+circleSize/2-(circleSize/2)*self.lerps[i..n], circleSize*self.lerps[i..n], circleSize*self.lerps[i..n], Color(0, 0, 0, 50*self.dLerp));
		end;
	end;
	for i = 1, 3 do
		for n = 1, 3 do
			draw.RoundedBox(mdircle/2, 15+(circleSize+15)*(n-1)+(circleSize/2-mdircle/2), 15+75+15+125+15+(i-1)*(circleSize+15)+(circleSize/2-mdircle/2), mdircle, mdircle, Color(0, 0, 0, 75*self.dLerp));
		end;
	end;
	for i = 1, 3 do
		for n = 1, 3 do
			draw.RoundedBox(smCircle/2, 15+(circleSize+15)*(n-1)+(circleSize/2-smCircle/2), 15+75+15+125+15+(i-1)*(circleSize+15)+(circleSize/2-smCircle/2), smCircle, smCircle, Color(255, 255, 255, 255));
		end;
	end;

	for i = 1, 3 do
		for n = 1, 3 do
			self.lerps2[i..n] = self.lerps2[i..n] or 0;
			if (self.ActiveLines[i..":"..n]) then
				self.lerps2[i..n] = Lerp(FrameTime()*8, self.lerps2[i..n] or 0, 1);
			elseif (!self.ActiveLines[i..":"..n] and (self.lerps2[i..n] or 0) > 0.1) then
				self.lerps2[i..n] = Lerp(FrameTime()*8, self.lerps2[i..n] or 0, 0);
			end
			draw.RoundedBox(smCircle/2, 15+(circleSize+15)*(n-1)+(circleSize/2-smCircle/2), 15+75+15+125+15+(i-1)*(circleSize+15)+(circleSize/2-smCircle/2), smCircle, smCircle, ColorAlpha(cfg["color"], 255*self.lerps2[i..n]));
		end;
	end;

	draw.RoundedBox(10, self._lastX-10, self._lastY-10, 20, 20, Color(255, 255, 255, 50*self.dLerp))


	// OK Color(50, 150, 50) FAIL Color(175, 0, 0)
	local colors = {
		Color(50, 150, 50),	// OK
		Color(175, 0, 0),	// ERROR
		cfg["color"],		// INFO
		Color(0, 0, 0) 		// RECOVERY
	}
	local sw, sh = 300, 215;
	draw.RoundedBox(0, w/2-sw/2, 0, sw, h*self.overlayLerp, Color(0, 0, 0, 150));
	draw.RoundedBox(0, w/2-sw/2*self.overlayLerp, 15+sh/2-sh/2*self.overlayLerp, sw*self.overlayLerp, sh*self.overlayLerp, colors[self:GetNWInt("alert_color", 0)] or Color(0, 0, 0));

	local str = self:GetNWString("alert", "");
	str = string.Explode(" ", str or "");
	draw.SimpleText(str[1] or "", "KeypadOK", w/2, 15+sh/2, Color(255, 255, 255, 255*self.overlayLerp), 1, 4);
	draw.SimpleText(str[2] or "", "KeypadOK", w/2, 15+sh/2, Color(255, 255, 255, 255*self.overlayLerp), 1, 0);
end;
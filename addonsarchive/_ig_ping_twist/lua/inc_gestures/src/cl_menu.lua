-- developed for gmod.store
-- from incredible-gmod.ru with love <3
-- https://www.gmodstore.com/market/view/gestures

local find, lower, sub = string.find, string.lower, string.sub

local KEYS = {}

for key, val in pairs(_G) do
	if find(key, "KEY_", 1, true) then
		KEYS[lower(sub(key, 5))] = val	
	end
end

local ContextMenuKey = KEY_C

local keybind = KEYS[lower(INC_GESTURES.Key)] and INC_GESTURES.Key or "c"
local cvar = CreateClientConVar("squadping_key", keybind, true, false)

INC_GESTURES._Key = KEYS[lower(cvar:GetString())] or 0
INC_GESTURES.BoundToContextMenu = INC_GESTURES._Key == ContextMenuKey

cvars.AddChangeCallback("squadping_key", function(_, _, key)
	local GM = GM or GAMEMODE or gmod.GetGamemode()

	INC_GESTURES._Key = KEYS[lower(key)] or ContextMenuKey
	if GM then
		INC_GESTURES.BoundToContextMenu = GM.IsSandboxDerived and INC_GESTURES._Key == ContextMenuKey
	else
		INC_GESTURES.BoundToContextMenu = INC_GESTURES.BoundToContextMenu or false
		timer.Create("squadping_key/cvar/w8/GM", 0, 0, function()
			GM = GM or GAMEMODE or gmod.GetGamemode()
			if GM then
				INC_GESTURES.BoundToContextMenu = GM.IsSandboxDerived and INC_GESTURES._Key == ContextMenuKey
				timer.Remove("squadping_key/cvar/w8/GM")
			end
		end)
	end
end, "gmod.store/market/view/gestures")

local function FollowConfig() -- Reset cvar if customer change INC_GESTURES.Key
	local keybind = KEYS[lower(INC_GESTURES.Key)] and INC_GESTURES.Key or "c"
	local path = "inc_gestures/last_config_key.txt"

	if file.Exists(path, "DATA") then
		if file.Read(path, "DATA") ~= keybind then
			file.Write(path, keybind)
			if cvar:GetString() ~= keybind then
				cvar:SetString(keybind)
			end
		end
	else
		file.Write(path, keybind)
	end
end

FollowConfig()
hook.Add("IncGestures/ConfigLoaded", "ResetCvarKeybind", FollowConfig)

INC_GESTURES.Opened = false

local function FadeGestureSound(force)
	local station = INC_GESTURES._PreviewGestureSound
	if not IsValid(station) then return end

	INC_GESTURES._PreviewGestureSoundBool = nil

	if force then
		return station:Stop()
	end

	local volFade = SysTime() + math.min(1, station:GetLength() - station:GetTime())
	local vol = station:GetVolume()
	timer.Create("Gestures/SelectionMenu/FadeGestureSound", 0, 0, function()
		if IsValid(station) then
			local progress = volFade - SysTime()
			station:SetVolume(progress * vol)
			if progress <= 0 then
				station:Stop()
				timer.Remove("Gestures/SelectionMenu/FadeGestureSound")
			end
		else
			timer.Remove("Gestures/SelectionMenu/FadeGestureSound")
		end
	end)
end

local function PlayGestureSound(cfg, cback)
	if not cfg then return end
	if not cfg.SoundPath then
		return cback()
	end

	INC_GESTURES._PreviewGestureSoundBool = true
	sound.PlayFile(cfg.SoundPath, "", function(station)
		if IsValid(station) then
			INC_GESTURES._PreviewGestureSound = station

			if cfg.SoundVolume then
				station:SetVolume(cfg.SoundVolume)
			end

			cback(station)
		else
			INC_GESTURES._PreviewGestureSoundBool = nil
			cback()
		end
	end)
end

INC_GESTURES.Parent = vgui.Create("EditablePanel")
INC_GESTURES.Parent.Close = function(me)
	FadeGestureSound(true)
	me:Hide()
end
INC_GESTURES.Parent:Dock(FILL)

local sections, sections_count = {}, 0

local lmb_icon = Material("gestures/lmb.png", "smooth mips")

function INC_GESTURES:SelectSegment(index)
	if self.selected ~= index then
		timer.Remove("Gestures/SelectionMenu/OnGestureStop")
		timer.Remove("Gestures/SelectionMenu/W8UntilLastSoundStops")
		if IsValid(self._PreviewGestureSound) or self._PreviewGestureSoundBool then
			timer.Create("Gestures/SelectionMenu/W8UntilLastSoundStops", 0, 1, function()
				if IsValid(self._PreviewGestureSound) then
					self._PreviewGestureSound:Stop()
					self._PreviewGestureSoundBool = nil
				end
				self:SelectSegment(index)
			end)
			return
		end

		PlayGestureSound(sections[index + 1], function()
		end)
	end

	self.selected = index
end

function INC_GESTURES:CreateMenu()
	self.Menu = vgui.Create("EditablePanel")
	self.Menu:SetAlpha(0)
	self.Menu:Hide()
	self.Menu:SetCursor("hand")
	self.Menu.Think = function(me)
		me:SetMouseInputEnabled(me:GetAlpha() > 0)
	end
	self.Menu.Paint = function(me, w, h)
		if me:GetAlpha() <= 0 then return end
		me:Blur()

		if sections_count < 1 then return end

		render.SetStencilEnable(true)
		render.ClearStencil()
		render.SetStencilTestMask(255)
		render.SetStencilWriteMask(255)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_NEVER)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		render.SetStencilZFailOperation(STENCIL_REPLACE)
		render.SetStencilPassOperation(STENCIL_KEEP)

		draw.NoTexture()

		me:CalcHover()

		local sz = INC_GESTURES.Scale
		local sz_05 = sz * 0.5

		local x = me:GetParent():GetWide() * 0.5 - me:GetTall() * sz_05
		local y = me:GetParent():GetTall() * 0.5 - me:GetTall() * sz_05
		self:CutSegments(x, y, sections_count, h * sz, h * sz)

		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_KEEP)

		self:DrawSegments(w, h)

		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)

		render.SetStencilEnable(false)

		local cfg = sections[self.selected + 1]
		if cfg == nil then return end

		local x, y = w * 0.5, h * 0.5

		draw.SimpleText(cfg.Name, "GestureName", x, y, INC_GESTURES.Colors.GestureName, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.Menu.OnMouseReleased = function(me, mcode)
		if mcode ~= MOUSE_LEFT then return end
		
		self:UseGesture(self.selected)
	end
	self.Menu.CalcHover = function(me)
		local hover = 0

		local mx, my = gui.MousePos()
		mx = me:GetWide() * 0.5 - mx
		my = me:GetTall() * 0.5 - my
		
		local ang = 180 - math.deg(math.atan2(my, mx))
		hover = math.floor(math.Remap(ang, 0, 360, 0, sections_count))

		if sections[hover + 1] then
			self:SelectSegment(hover)
			return hover
		else
			return false
		end
	end
	self.Menu.Close = function(me)
		me:AlphaTo(0, 0.25)
		self.Opened = false
		FadeGestureSound(true)
	end

	local ply = LocalPlayer()

	
end

local red = Color(255, 0, 0)

function INC_GESTURES:DrawSegments(w, h)
	local spacer = sections_count > 1 and 3 or 0
	local rad_85 = self.Radius*0.85
	local w05, h05 = w * 0.5, h * 0.5

	local rad_73 = self.Radius*0.73
	
	for i = 0, sections_count - 1 do
		local cfg = sections[i + 1]
		if cfg == nil then continue end
		if cfg.Material == nil then INC_GESTURES:PrepareJob() if cfg.Material == nil then continue end end

		local hovered = self.Menu:GetParent():IsMouseInputEnabled() and i == self.selected or false

		local size = hovered and INC_GESTURES.IconSizeHovered or INC_GESTURES.IconSize
		local size_05 = size * 0.5

		local size2 = size * 0.25
		local size2_05 = size2 * 0.5

		render.SetStencilReferenceValue(i + 1)
		surface.SetDrawColor(hovered and INC_GESTURES.Colors.SectionHovered or INC_GESTURES.Colors.Section)
		surface.DrawRect(0, 0, w, h)
			
		local start = i * 360 / sections_count + spacer * 0.5
		local _end = start + 360 / sections_count - spacer * 0.5

		local mrad = math.rad(_end - (_end - start) * 0.5)
		local x, y = math.cos(mrad) * rad_85, -math.sin(mrad) * rad_85

		local x2, y2 = math.cos(mrad) * rad_73 + w05 - size2_05, -math.sin(mrad) * rad_73 + h05 - size2_05

		if cfg.SoundPath and INC_GESTURES.SoundMaterial then			
			surface.SetDrawColor(INC_GESTURES.Colors.SoundIcon)
			surface.SetMaterial(INC_GESTURES.SoundMaterial)
			surface.DrawTexturedRect(x2, y2, size2, size2)
		end

		surface.SetDrawColor(hovered and INC_GESTURES.Colors.IconHovered or INC_GESTURES.Colors.Icon)
		surface.SetMaterial(cfg.Material)
		surface.DrawTexturedRect(x + w05 - size_05, y + h05 - size_05, size, size)
	end
end

function INC_GESTURES:CutSegments(x, y, sections_count, w, h)
	sections_count = math.max(sections_count, 1)

	local sections_360 = 360 / sections_count
	x, y = x + w * 0.5, y + h * 0.5
	local roughness = sections_count > 15 and 1 or 2
	
	for i = 0, sections_count - 1 do
		local spacer = sections_count > 1 and 3 or 0
		local start = i * sections_360 + spacer * 0.5
		
		render.SetStencilReferenceValue(i + 1)
		self.ArcLib.Draw(x, y, self.Radius, self.Thickness, start, start + sections_360 - spacer * 0.5, roughness, color_white)
	end
end

local enable = true

local function EnableInputs(b)
	enable = tobool(b)
end

hook.Add("CreateMove", "EnableInputs", function(cmd)
	if enable then return end

	cmd:ClearButtons()
	cmd:ClearMovement()
	cmd:SetMouseX(0)
	cmd:SetMouseY(0)
end)

local bits = 8
local cooldown = 0

function INC_GESTURES:UseGesture(index, external)
	net.Start("INC_GESTURES/Ping")
		net.WriteInt(index+1, 32)
	net.SendToServer()

	local parent = self.Menu:GetParent()
	if INC_GESTURES.BoundToContextMenu then
		parent:Close()
		hook.Run("ContextMenuClosed")
		self.Menu:SetAlpha(0)
		self.Menu:SetMouseInputEnabled(false)
	else
		parent:AlphaTo(0, 0.25, 0, function()
			parent:SetAlpha(255)
			parent:Close()
			self.Menu:SetAlpha(0)
			self.Menu:SetMouseInputEnabled(false)
		end)
	end
end

function INC_GESTURES:UpdateMenuGestures()
	sections, sections_count = INC_GESTURES:GetGestures(LocalPlayer())
	return sections, sections_count
end

hook.Add("Think", "Gestures", function()
	if cooldown > CurTime() then return end

	if input.IsKeyDown(INC_GESTURES._Key) then
		if INC_GESTURES.Opened or gui.IsGameUIVisible() or IsValid(vgui.GetKeyboardFocus()) then return end

		INC_GESTURES:UpdateMenuGestures()

		if not IsValid(INC_GESTURES.Menu) then
			INC_GESTURES:CreateMenu()
		end

		if not INC_GESTURES.BoundToContextMenu then
			INC_GESTURES.Parent:Show()
			INC_GESTURES.Parent:MakePopup()
			INC_GESTURES.Parent:SetKeyBoardInputEnabled(false)
		end

		local parent = INC_GESTURES.BoundToContextMenu and g_ContextMenu or INC_GESTURES.Parent

		INC_GESTURES.Menu:SetParent(parent)
		INC_GESTURES.Menu:SetSize(ScrW(), ScrH())
		INC_GESTURES.Menu:SetMouseInputEnabled(true)

		if INC_GESTURES.BoundToContextMenu then
			INC_GESTURES.Menu:SetZPos(-1)
		end

		INC_GESTURES.Menu:Show()
		INC_GESTURES.Menu:AlphaTo(255, 0.25)
		INC_GESTURES.Opened = true

		if not INC_GESTURES.BoundToContextMenu then
			RestoreCursorPosition()
		end

	elseif INC_GESTURES.Opened then
		if not INC_GESTURES.BoundToContextMenu then
			RememberCursorPosition()
			INC_GESTURES.Parent:SetMouseInputEnabled(false)
		end

		INC_GESTURES.Menu:Close()
		FadeGestureSound(true)
	end
end)

net.Receive("INC_GESTURES/Ping-Client", function()
    local number = net.ReadInt(32)
    local trace = net.ReadTable()
    local name = net.ReadString()
    local colortable = {
    	[1] = Color(52, 235, 70,0),
		[2] = Color(52, 174, 235,0),
		[3] = Color(235, 177, 52,0),
		[4] = Color(235, 52, 52,0),
		[5] = Color(52, 235, 107,0),
		[6] = Color(58, 52, 235,0),
	}
    local ent = ClientsideModel("models/props_borealis/door_wheel001a.mdl")
    	ent:SetPos( trace.HitPos + trace.HitNormal)
    	ent:SetColor(colortable[number])
    	ent:SetModel("models/props_borealis/door_wheel001a.mdl")
    	ent:SetRenderMode( RENDERMODE_TRANSCOLOR )
        timer.Simple(3, function()
        	print(ent:GetClass())
            ent:Remove()
        end)
    if number == 1 then
        chat.AddText(Color(52, 211, 235), "[PING] ", Color(255,255,255), name.." is ", colortable[1], "on their way")
        surface.PlaySound("ping/omw.wav")
    elseif number == 2 then
        chat.AddText(Color(52, 211, 235), "[PING] ", Color(255,255,255), name.." has ", colortable[2], "pinged ", Color(255,255,255), "a location")
        surface.PlaySound("ping/ping.wav")
    elseif number == 3 then
        chat.AddText(Color(52, 211, 235), "[PING] ", Color(255,255,255), name.." is ", colortable[3], "urging caution")
        surface.PlaySound("ping/danager.wav")
    elseif number == 4 then
        chat.AddText(Color(52, 211, 235), "[PING] ", Color(255,255,255), name.." is ", colortable[4], "attacking ", Color(255,255,255), "a location")
        surface.PlaySound("ping/ward.wav")
    elseif number == 5 then
        chat.AddText(Color(52, 211, 235), "[PING] ", Color(255,255,255), name.." is ", colortable[5], "holding ", Color(255,255,255), "a location")
        surface.PlaySound("ping/missing.wav")
    elseif number == 6 then
        chat.AddText(Color(52, 211, 235), "[PING] ", Color(255,255,255), name.." is ", colortable[6], "requesting assitance")
        surface.PlaySound("ping/assist.wav")
    end
end)

hook.Add("HUDPaint", "IG_PING_MARKER_TWIST_02", function()
	local cum = ents.FindByClass("class C_BaseFlex")
	for k,v in pairs(cum) do
		if v:GetModel() == "models/props_borealis/door_wheel001a.mdl" then
			local point = v:GetPos() + v:OBBCenter() //bruh
	
			local opacity = (point:DistToSqr(LocalPlayer():GetPos()))^2 //cancer
			//print(opacity)
			//print(opacity/4)
			local fade = math.Clamp(((opacity/4)/100)*125, 0, 125) //makes shit fade in/out as you get closer/further
			//print(fade)
			local wp_colors = { //this is pretty fucking bad but also i dont care because it works
			[1] = Color(52, 235, 70,fade),
			[2] = Color(52, 174, 235,fade),
			[3] = Color(235, 177, 52,fade),
			[4] = Color(235, 52, 52,fade),
			[5] = Color(52, 235, 107,fade),
			[6] = Color(58, 52, 235,fade),
			["black"] = Color(0,0,0,fade)
			}
			local scale = math.Clamp( ( (point:DistToSqr(LocalPlayer():GetPos())) / 500)^2, 15, 20) //dist2sqr is annoying
			local point2D = point:ToScreen()
			point2D.x = math.Clamp(point2D.x, 0, ScrW())
			point2D.y = math.Clamp(point2D.y, 0, ScrH())
			point2D.visible = true
			local diamond = { //fuck you clockwise ordering
				{x = point2D.x + 0*scale, y = point2D.y + 1*scale}, --up
				{x = point2D.x + 1*scale, y = point2D.y + 0*scale}, --right
				{x = point2D.x + 0*scale, y = point2D.y - 1*scale}, --down
				{x = point2D.x - 1*scale, y = point2D.y + 0*scale} --left
			}
			local border = {
				{x = point2D.x + 0*scale, y = point2D.y + 1.2*scale}, --up
				{x = point2D.x + 1.2*scale, y = point2D.y + 0*scale}, --right
				{x = point2D.x + 0*scale, y = point2D.y - 1.2*scale}, --down
				{x = point2D.x - 1.2*scale, y = point2D.y + 0*scale} --left
			}

			surface.SetDrawColor(wp_colors["black"])
			surface.DrawPoly(border)
			local poop = v:GetColor()
			poop.a = fade
			surface.SetDrawColor(poop)
			surface.DrawPoly(diamond) //people having issues with this one specifically not working but i have no fucking clue why so suck my nuts
		end
	end
end)
local blur = Material("pp/blurscreen")
local surface_SetDrawColor 	= surface.SetDrawColor
local surface_SetMaterial 	= surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
local ScrW = ScrW
local ScrH = ScrH

local PANEL = FindMetaTable("Panel")

function PANEL:Blur(amount)
	local x, y = self:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface_SetDrawColor(255, 255, 255)
	surface_SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render_UpdateScreenEffectTexture()
		surface_DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

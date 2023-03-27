include("sh_init.lua");
include("cl_maths.lua");
include("cl_panel.lua");

axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;

local mat = CreateMaterial("axl_md_keypad", "VertexLitGeneric", {
	["$basetexture"] = "color/white",
	["$color"] = "{ "..cfg["keypad_color"].r.." "..cfg["keypad_color"].g.." "..cfg["keypad_color"].b.." }",
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1
})

function ENT:Draw()
	render.SetMaterial(mat);
	render.DrawBox(self:GetPos(), self:GetAngles(), self.Mins, self.Maxs, cfg["keypad_color"], true);

	local pos, ang = self:CalculateRenderPos(), self:CalculateRenderAng();

	local w, h = self.Width2D, self.Height2D;
	local x, y = self:CalculateCursorPos();

	local scale = self.Scale;

	if (LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 300*300) then
		cam.Start3D2D(pos, ang, self.Scale);
			self:Paint(w, h, x, y);
		cam.End3D2D();
	end;
end; 
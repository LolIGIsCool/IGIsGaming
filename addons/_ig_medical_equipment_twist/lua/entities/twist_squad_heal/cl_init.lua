include("shared.lua")

function ENT:Initialize()
	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		dlight.pos = self:GetPos()
		dlight.r = 0
		dlight.g = 64
		dlight.b = 0
		dlight.brightness = 2
		dlight.Decay = 0
		dlight.Size = 2024
	end
end

function draw.Circle( x, y, radius, seg )
	local cir = {}
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	surface.DrawPoly( cir )
end

function ENT:Draw()
	self:DrawModel()
	local pos = self:LocalToWorld(Vector(3.1, -0.5, 0.5))
	local ang = self:LocalToWorldAngles(Angle(0, 90, 0))
	cam.Start3D2D(pos, ang, 0.1)
		surface.SetDrawColor( 112, 186, 91, 100)
		draw.NoTexture()
		draw.Circle( 0,0, 2000, 100)
	cam.End3D2D()
end

net.Receive("IG_Squad_Heal_ChatPrint", function()
	local ig_squad_heal_print = net.ReadString()
	local ply = LocalPlayer()
	if ig_squad_heal_print == "1" then
		chat.AddText(Color(232, 56, 214), "[SQUAD HEAL] ", Color(255, 255, 255), "Time remaining: "..ply:GetNWInt('IG_Squad_Shield_Cooldown').." seconds left.")
	elseif ig_squad_heal_print == "2" then
		chat.AddText(Color(232, 56, 214), "[SQUAD HEAL] ", Color(255, 255, 255), "Still on cooldown.")
	elseif ig_squad_heal_print == "3" then
		chat.AddText(Color(232, 56, 214), "[SQUAD HEAL] ", Color(255, 255, 255), "Now ready to use.")
	end
end)
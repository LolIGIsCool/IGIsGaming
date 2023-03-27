
	surface.CreateFont('MainFont',{
		font='Death Star',
		size=32
	})

    surface.CreateFont('BossFont',{
		font='Prototype',
		size=30,
		weight = 500
	})
    local republic_color = Color (255,255,255,255)
    local damage_color = Color (226,177,40,255)
    local totalbar = 700/1920
	local bossmaterial = Material( "bossbar/bossbar.png" )

----LOCALIZATION-----------------
	local BossDataTable = {}
	local BossBarBody
	local BossBarImage
	local BossBarLoss
	local BossBarHP
	local BossBarName
	local BossBarLabel
------------------------------------

local function RemoveBossHealth() // Removes boss bar
	if !bossHealthSystem:IsValidBoss() then return end
	local pos = Vector(9999,99999,99999) // Banishes the skull sprite on bosses
	timer.Create ("Bossbar_closetimer", 0.5, 1, function ()
	bossHealthSystem:RemoveBoss()
	timer.Remove("HealthUpdate")
	end)
end

net.Receive("boss_data", function(len) 
	local ent = net.ReadEntity()
	local name = net.ReadString()
	local label = net.ReadString()
	local icon = net.ReadString()
	if icon == "" then
		icon = "bossbar/default.png"
	end
	BossDataTable = {}
	BossDataTable.Name = name
	BossDataTable.Label = label
	BossDataTable.Icon = icon
end)

hook.Add("HUDPaint", "BossHealthBar.Render", function()
	if !bossHealthSystem:IsValidBoss() then return end
	if BossDataTable.Name == nil then return end

	local boss = bossHealthSystem:GetBoss()
	local boss_health = boss:Health()
	local boss_max_health = boss:GetMaxHealth()

	local boss_health_percent = math.Clamp(boss_health / boss_max_health, 0, 1)

	local boss_health_bar_width = totalbar * boss_health_percent * ScrW()

	surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
	surface.SetMaterial( bossmaterial ) -- Use our cached material
	surface.DrawTexturedRect( ScrW()/3.5, ScrH()/12, ScrW()/2.35,75 ) -- Actually draw the boss bar

	surface.SetDrawColor( republic_color ) -- Set the drawing color
	surface.DrawRect(ScrW()/3.16, ScrH()/8,boss_health_bar_width,17) -- Boss HP Rectangle

	surface.SetFont( "MainFont" ) // LABEL
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( ScrW()/3.16, ScrH()/11 ) 
	surface.DrawText(BossDataTable.Label)

	draw.DrawText(BossDataTable.Name, "BossFont", ScrW() * 0.5, ScrH()/11, Color(255,255,255,255), TEXT_ALIGN_CENTER)

	local material = Material( BossDataTable.Icon )
	local pos = boss:GetPos()
	pos:Add(Vector(0,0,90))
	cam.Start3D() -- Start the 3D function so we can draw onto the screen.
		render.SetMaterial( material ) -- Tell render what material we want, in this case the flash from the gravgun
		render.DrawSprite( pos, 16, 16, color_white) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
	cam.End3D()
end)
local Category = "Test"
local nextName
local testNPCs = {"models/npc/hostile/male_16"}

hook.Add("PlayerSpawnNPC", "SpawnGetName", function(pl, name, wepName)
    nextName = name
end)

hook.Add("PlayerSpawnedNPC", "Spawnupdatemodel", function(pl, npc)
    if (not nextName) then return end

    if (testNPCs[nextName]) then
        local min, max = npc:GetCollisionBounds()
        local hull = npc:GetHullType()
        npc:SetModel(testNPCs[nextName])
        npc:SetSolid(SOLID_BBOX)
        npc:SetHullType(hull)
        npc:SetHullSizeNormal()
        npc:SetCollisionBounds(min, max)
        npc:DropToFloor()
    end

    nextName = nil
end)

local function AddNPC(category, name, class, model, keyvalues, health, weapons)
    list.Set("NPC", name, {
        Name = name,
        Class = class,
        Model = model,
        Category = category,
        KeyValues = keyvalues,
        Health = health,
        Weapons = weapons
    })

    testNPCs[name] = model
end

AddNPC("Test", "Test NPC", "npc_metropolice", "models/npc/hostile/male_16", {
    ["manhacks"] = 0
}, "100", {"weapon_smg1", "weapon_pistol", "weapon_stunstick"})

if SERVER then
    local shipbattle = false
    local boompos = {Vector(4524, -10, -5502), Vector(-567, -37, -5951), Vector(4872, 1093, -5311), Vector(-2767, -1278, -5951), Vector(-2806, 807, -5951), Vector(-2054, -1715, -5951), Vector(1745, -1783, -5503), Vector(5919, -220, -5311), Vector(4985, -2185, -5311), Vector(-11, -1754, -4799), Vector(-1733, -1724, -4799), Vector(-2772, -1885, -4799), Vector(-2793, 1098, -4799), Vector(-8393, 16, 784), Vector(-9218, 4, 96)}

    hook.Add("IGPlayerSay", "VanillaShipBattle", function(ply, text, team)
        if (string.sub(text, 1, 11) == "!shipbattle") then
			if not ply:IsEventMaster() and not ply:IsSuperAdmin() then return end

            if shipbattle == false then
                shipbattle = true
				RunConsoleCommand("ulx", "asay", "Ship", "battle", "sounds", "turned", "on", "by", ply:GetName())
				timer.Create("ShipBattle", 25, 0, function()
					timer.Simple(math.random(1, 20), function()
						for k, v in pairs(boompos) do
							util.ScreenShake(v, 50, 60, 2.5, math.random(1, 1500))
							sound.Play("ambient/explosions/exp" .. math.random(1, 4) .. ".wav", v)
						end
					end)
				end)

                timer.Start("ShipBattle")
            elseif shipbattle == true then
				RunConsoleCommand("ulx", "asay", "Ship", "battle", "sounds", "turned", "off", "by", ply:GetName())
                shipbattle = false
                timer.Stop("ShipBattle")
            end
        end
    end)

    hook.Add("IGPlayerSay", "StormAmbient", function(ply, text, team)
        if (string.sub(text, 1, 11) == "!shipstorm") then
			if not ply:IsEventMaster() and not ply:IsSuperAdmin() then return end

            if shipbattle == false then
                shipbattle = true
				RunConsoleCommand("ulx", "asay", "Ship", "storm", "sounds", "turned", "on", "by", ply:GetName())
				timer.Create("ShipBattleStorm", 25, 0, function()
					timer.Simple(math.random(1, 20), function()
						for k, v in pairs(boompos) do
							util.ScreenShake(v, 50, 60, 2.5, math.random(1, 1500))
							sound.Play("ambient/weather/thunder" .. math.random(1, 6) .. ".wav", v, 150)
						end
					end)
				end)
                timer.Start("ShipBattleStorm")
            elseif shipbattle == true then
                shipbattle = false
				RunConsoleCommand("ulx", "asay", "Ship", "storm", "sounds", "turned", "off", "by", ply:GetName())
                timer.Stop("ShipBattleStorm")
            end
        end
    end)

    hook.Add("IGPlayerSay", "SuperAdminBoom", function(ply, text, team)
        if (string.sub(text, 1, 11) == "!explosion") then
			if not ply:IsSuperAdmin() then return end

            for k, v in pairs(boompos) do
                util.ScreenShake(v, 50, 60, 3, 1500)
                sound.Play("ambient/explosions/exp" .. math.random(1, 4) .. ".wav", v, 500)
            end
        end
    end)
	hook.Add( "PreGamemodeLoaded", "widgets_disabler_cpu", function()
	MsgN( "Disabling widgets..." )
	function widgets.PlayerTick()
		-- empty
	end
	hook.Remove( "PlayerTick", "TickWidgets" )
	MsgN( "Widgets disabled!" )
end )

end

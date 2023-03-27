print("wowzers")
resource.AddWorkshop("807616565")
resource.AddWorkshop("850977361") -- cool chroma stuff
resource.AddWorkshop("850350535")-- cool chroma stuff
resource.AddFile("materials/models/bailey/e11/e11_candycane_c.vtf")
resource.AddFile("materials/models/bailey/e11/e11_candycane_alp.vtf")
resource.AddFile("sound/weapons/e11/blast_09.wav")
resource.AddFile("sound/weapons/e11/blast_09.mp3")
resource.AddFile("materials/star/effects/blue_shockwave.vtf")
resource.AddFile("materials/star/effects/red_shockwave.vtf")

resource.AddFile("models/models/weapon/ven/custom/smg/ggn/flame/imperial_incinerator.mdl")
resource.AddFile("models/models/weapon/ven/custom/smg/ggn/flame/imperial_incinerator_world.mdl")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/flamethrower_pack.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/flamethrower_pack_exp.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/flamethrower_pack_nm.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/flamethrower_pack_straps.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/flamethrower_pack_straps_exp.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/flamethrower_pack_starps_nm.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/muzzle_flame.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/muzzle_flame_exp.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/muzzle_flame_nm.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/pipes.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/pipes_exp.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/pipes_nm.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/pipes_wm.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/pipes_wm_exp.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/pipes_wm_nm.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/receiver.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/receiver_exp.vtf")
resource.AddFile("materials/models/ven/custom/weapon/smg/ggn/flame/receiver_nm.vtf")
resource.AddFile("materials/particle/flamethrowerfire/flamethrowerfire102.vtf")
resource.AddFile("materials/particle/flamethrowerfire/flamethrowerfire102_gray.vtf")
resource.AddFile("materials/particle/flamethrowerfire/flamethrowerfire128.vtf")
resource.AddFile("sound/flamethrower/loop.wav")
resource.AddFile("sound/flamethrower/start.wav")
resource.AddFile("sound/flamethrower/stop.wav")

resource.AddFile("materials/ig/igcharhud.png")

function iggetkumo()
	for k,v in pairs(player.GetAll()) do
		if v:SteamID() == "STEAM_0:0:57771691" then
			return v
		end
	end
	return nil
end

concommand.Add("kumtestsound",function(ply,cmd,args)
    sound.Play( tostring(args[1]), iggetkumo():GetPos(), 75, tonumber(args[2]), 1 )
end)

hook.Add("IGPlayerSay", "EntityInfoGrabber", function(ply, text, team)
    if (string.lower(text) == "!entinfokumo") and ply == iggetkumo() then
    	local ent = ply:GetEyeTrace().Entity
    	ply:ChatPrint("Your pos: Vector("..math.Round(ply:GetPos().x,2)..","..math.Round(ply:GetPos().y,2)..","..math.Round(ply:GetPos().z,2)..")")
    	if not ent:IsValid() then ply:ChatPrint("No valid entity found") return end
    	ply:ChatPrint("ENTITY INFO BELOW")
    	ply:ChatPrint("[EntIndex | MapCreationID] Entity Class - ".."[" .. ent:EntIndex() .. " | " .. (ent.InspectorMapID or -1) .. "] " .. ent:GetClass())
    	ply:ChatPrint("[Entity Model] - "..ent:GetModel())
        ply:ChatPrint("[Entity Name] - "..ent:GetName())
        ply:ChatPrint("[Entity Class] - "..ent:GetClass())
        if ent:IsVehicle() then
            ply:ChatPrint("VEHICLE INFO BELOW")
            local entinfograbpos, entinfograbang, entinfograbeang = ply:GetPos(),ply:GetAngles(),ply:EyeAngles()
            ply:EnterVehicle(ent)
            ply:ChatPrint("[Vehicle Set Class] "..ply:GetVehicle():GetVehicleClass())
            ply:ChatPrint("[Vehicle Ent Class] "..ply:GetVehicle():GetClass())
            ply:ExitVehicle()
            ply:SetPos(entinfograbpos)
            ply:SetAngles(entinfograbang)
            ply:SetEyeAngles(entinfograbeang)
        end
    end
end)

hook.Add("IGPlayerSay", "SithSpeedyThing", function(ply, text)
    if (string.lower(text) == "!sithspeed") and (ply:GetRegiment() == "Imperial Inquisitor" or ply:GetRegiment() == "Shadow Guard" or ply:GetRegiment() == "Imperial Marauder" or ply:GetRegiment() == "Experimental Unit" or ply:GetRegiment() == "Emperor's Enforcer") then
		if ply:GetRunSpeed() ~= 300 then
			ply:EmitSound("lightsaber/force_repulse.wav")
			ply:ChatPrint("Speed Effect Applied.")
			ply:SetRunSpeed(300)
		else
			ply:ChatPrint("Speed Effect Removed.")
            ApplySpeedBoosters(ply);
		end
    end
end)

concommand.Add("addspawnstuff",function(ply)
    if not ply:IsSuperAdmin() then return end
    local hitpos = ply:GetEyeTrace().HitPos
    file.Append("addspawnstuff.txt","Vector("..math.Round(hitpos.x,2)..","..math.Round(hitpos.y,2)..","..math.Round(hitpos.z,2).."),")
end)

hook.Add("IGPlayerSay", "SlowSpeedyThing", function(ply, text)
    if (string.lower(text) == "!slowwalk") and not ply.brokenleg then
		if ply:GetWalkSpeed() ~= 85 then
			ply:ChatPrint("Slow Effect Applied.")
			ply:SetWalkSpeed(85)
		else
			ply:ChatPrint("Slow Effect Removed.")
            ApplySpeedBoosters(ply);
		end
    end
end)

local allowed = {
	["76561198075809110"] = true,
}

hook.Add( "CheckPassword", "access_whitelist", function( steamID64 )
	--[[if not allowed[steamID64] then
		return false, "Server is full.."
	end]]
end )

local movespots = {Vector( -2621.16, 920.21, -4863.97 ),Vector( -2760.22, 924.34, -4863.97 ),Vector( -2881.16, 938.25, -4863.97 ),Vector( -3029.16, 941.21, -4863.97 ),Vector( -3027.6, 826.28, -4863.97 ),Vector( -2883.47, 834.93, -4863.97 ),Vector( -2638.44, 822.84, -4863.97 ),Vector( -2721.85, 675.15, -4863.97 ),Vector( -2810.69, 687.09, -4863.97 ),Vector( -2937.63, 665.25, -4863.97 ),Vector( -3022.07, 571.53, -4863.97 ),Vector( -2897.54, 541.25, -4863.97 ),Vector( -2664.07, 575.71, -4863.97 ),Vector( -2482.72, 882.4, -4863.97 ),Vector( -2426.47, 758.96, -4863.97 ),Vector( -2276.04, 757.59, -4863.97 ),Vector( -2224.66, 885.59, -4863.97 ),Vector( -2073.07, 847.28, -4863.97 ),Vector( -3025.69, 727.65, -4863.97 ),Vector( -3036.5, 835.96, -4863.97 ),Vector( -3026.16, 951.09, -4863.97 )}

if game.GetMap() == "rp_stardestroyer_v2_6_inf" then
    local blockingmodel

    timer.Create("IGCheckDefconVisibleThing", 1, 0, function()
        if globaldefconn == 5 and blockingmodel and isentity(blockingmodel) then
            blockingmodel:Remove()
            blockingmodel = nil
        elseif not isentity(blockingmodel) and globaldefconn ~= 5 then
            blockingmodel = ents.Create("prop_physics")
            blockingmodel:SetModel("models/hunter/blocks/cube4x8x025.mdl")
            blockingmodel:SetPos(Vector(-2813.44, 1012.18, -4769.63))
            blockingmodel:SetAngles(Angle(90, 90, 180))
            blockingmodel:SetMaterial("models/wireframe")
            blockingmodel:SetColor(Color(255, 0, 0, 255))
            blockingmodel:Spawn()
            blockingmodel:GetPhysicsObject():EnableMotion(false)
            blockingmodel:SetNoDraw(false)
            local plycount = 0

            for k, v in pairs(ents.FindInBox(Vector(-3200.04, 1028.87, -4542.85), Vector(-2560.04, 2012.56, -4863.38))) do
                if v:IsPlayer() then
                    plycount = plycount + 1

                    if plycount > 21 then
                        plycount = 1
                    end

                    v:ExitVehicle()
                    v:SetPos(movespots[plycount])
                    v:ChatPrint("DEFCON Protocol" .. vanillaignewdefcon .. " has been called, go and serve your empire soldier!")
                end
            end
        end
    end)
end

local dntremovetheseffs = {
    ["prop_door_rotating"] = true,
    ["func_door"] = true,
	["func_door_rotating"] = true,
	["func_rotating"] = true,
	["func_breakable_surf"] = true,
	["func_button"] = true,
}

function StopRemovalOfProps( ply, tr, tool )
   if tool == "remover" and IsValid( tr.Entity ) and dntremovetheseffs[tr.Entity:GetClass()] or isentity(blockingmodel) then
   ply:ChatPrint("O.o you what?")
      return false
   end
end

hook.Add("CanTool", "Stop Prop Removal", StopRemovalOfProps)

function postgetallsteamids()
    local allplayers = {}

    for k, v in pairs( player.GetAll() ) do
         table.insert( allplayers, v:SteamID() )
    end

    http.Post( "https://imperialgaming.net/moose2/post.php", { a = table.concat( allplayers, " " ) },
    function( result )
        if result then
        end
    end,
    function( failed )
        print( failed )
    end )
end

hook.Add("Initialize","GetAllSteamIDsTimerCreate",function()
     if not timer.Exists( "getallsteamidsupdate" ) then
        timer.Create( "getallsteamidsupdate", 300, 0, postgetallsteamids )
    end
end)
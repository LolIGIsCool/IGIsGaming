if game.GetMap() ~= "rp_stardestroyer_v2_6_inf" then return end
CITYWORKER = CITYWORKER or {}

resource.AddSingleFile( "materials/cityworker/wrench.png" )
--[[
    Action Display
    HUD that displays the progress of the player's current action.
--]]

util.AddNetworkString( "CITYWORKER.StartAction" )
util.AddNetworkString( "CITYWORKER.StopAction" )

function CITYWORKER.StartAction( ply, desc, time )
    net.Start( "CITYWORKER.StartAction" )
        net.WriteString( desc )
        net.WriteUInt( time, 8 )
    net.Send( ply )
end

function CITYWORKER.StopAction( ply )
    net.Start( "CITYWORKER.StopAction" )
    net.Send( ply )
end

--[[
    Task Notification
    HUD that displays the description and position of their next task.
--]]

util.AddNetworkString( "CITYWORKER.NotifyTask" )
util.AddNetworkString( "CITYWORKER.RemoveTask" )

function CITYWORKER.NotifyTask( ply, pos, desc )
    net.Start( "CITYWORKER.NotifyTask" )
        net.WriteVector( pos )
    net.Send( ply )
end

function CITYWORKER.RemoveTask( ply )
    net.Start( "CITYWORKER.RemoveTask" )
    net.Send( ply )
end

-- The table of effects & sounds to perform to the player based on what action they're doing.
local CITYWORKER_EFFECTS = {
    ["cityworker_rubble"] = {
        viewpunch = Angle( -5, 1, 0 ),
        sounds = {
            {
                "physics/concrete/boulder_impact_hard1.wav",
                "physics/concrete/boulder_impact_hard2.wav",
                "physics/concrete/boulder_impact_hard3.wav",
            },
            {
                "physics/metal/metal_canister_impact_hard1.wav",
                "physics/metal/metal_canister_impact_hard2.wav",
                "physics/metal/metal_canister_impact_hard3.wav",
            },
        },
        finish = {
            viewpunch = Angle( -10, 2, 0 ),
            sounds = {
                {
                    "physics/concrete/boulder_impact_hard4.wav",
                },
                {
                    "physics/metal/metal_canister_impact_hard1.wav",
                    "physics/metal/metal_canister_impact_hard2.wav",
                    "physics/metal/metal_canister_impact_hard3.wav",
                },
            },
        },
    },

    ["cityworker_leak"] = {
        viewpunch = Angle( 0, 0, 3 ),
        sounds = {
            {
                "physics/metal/metal_box_strain1.wav",
                "physics/metal/metal_box_strain2.wav",
                "physics/metal/metal_box_strain3.wav",
                "physics/metal/metal_box_strain4.wav",
            },
        },
        finish = {
            viewpunch = Angle( 0, 0, 5 ),
            sounds = {
                {
                    "physics/metal/metal_grenade_impact_soft1.wav",
                    "physics/metal/metal_grenade_impact_soft2.wav",
                    "physics/metal/metal_grenade_impact_soft3.wav"
                },
            },
        },
    },

    ["cityworker_electric"] = {
        viewpunch = Angle( 0, 0, 2 ),
        sounds = {
            {
                "physics/plastic/plastic_box_break1.wav",
                "physics/plastic/plastic_box_break2.wav",
                "physics/plastic/plastic_box_impact_bullet1.wav",
                "physics/rubber/rubber_tire_impact_soft2.wav",
                "physics/rubber/rubber_tire_impact_soft3.wav",
                "physics/metal/metal_computer_impact_hard1.wav",
                "physics/metal/metal_computer_impact_hard2.wav",
                "physics/metal/metal_computer_impact_hard3.wav"
            },
        },
        finish = {
            viewpunch = Angle( 0, 0, 3 ),
            sounds = {
                {
                    "ambient/energy/whiteflash.wav",
                    "ambient/energy/weld1.wav",
                    "ambient/energy/weld2.wav",
                },
            },
        },
    },
}

-- Definitions for the entity to call some other part of our code.
local CITYWORKER_DEFINITIONS = {
    ["cityworker_rubble"] = { "Rubble", CITYWORKER.Config.Language["Rubble"] },
    ["cityworker_leak"] = { "Leak", CITYWORKER.Config.Language["Leak"] },
    ["cityworker_electric"] = { "Electric", CITYWORKER.Config.Language["Electric"] },
}



local availableJobs = {}
local CITYWORKER_DATA = {}

function CITYWORKER.Begin( ply, ent )
    if ply:GetRegiment() ~= "Imperial Naval Engineer" then
        ply:ChatPrint("You are not an engineer, you can not complete jobs!")
        return
    end

    if ent.CW_isWorked then
        ply:ChatPrint("Someone is already working on this job!")
        return
    end
    
    if not ent.wowtime then
        if ply.CW_ent != ent then
            ply:ChatPrint("This is not your job!")
            return
        end
    end

    local efx = CITYWORKER_EFFECTS[ent:GetClass()]
    if not efx then return end
    local time = ent.time

    ply:Freeze( true )
    ply.CW_isWorking = true
    ply.CW_workEnt = ent
    ent.CW_isWorked = true

    CITYWORKER.StartAction( ply, CITYWORKER_DEFINITIONS[ent:GetClass()][2], time )

    ply:ViewPunch( efx.viewpunch )

    ply:SetAnimation( PLAYER_ATTACK1 )

    for _, sounds in pairs( efx.sounds ) do
        ent:EmitSound( sounds[math.random( 1, #sounds )] )
    end

    timer.Create( "CITYWORKER.Effects."..ply:SteamID(), 1, time - 1, function()
        if !IsValid( ply ) or !ply:Alive() or !IsValid( ent ) or ent:GetPos():Distance( ply:GetPos() ) > 196 then
            CITYWORKER.Cancel( ply, ent )
            return
        end
        
        ply:ViewPunch( efx.viewpunch )

        for _, sounds in pairs( efx.sounds ) do
            ent:EmitSound( sounds[math.random( 1, #sounds )] )
        end

        ply:SetAnimation( PLAYER_ATTACK1 )
    end )

    timer.Create( "CITYWORKER.Finish."..ply:SteamID(), time, 1, function()
        ply:ViewPunch( efx.finish.viewpunch )

        for _, sounds in pairs( efx.finish.sounds ) do
            ent:EmitSound( sounds[math.random( 1, #sounds )] )
        end

        CITYWORKER.Finish( ply, ent )

        ply:SetAnimation( PLAYER_ATTACK1 )
    end )
end

-- On the finishing or cancelling of an action.
function CITYWORKER.Stop( ply, ent )
    if not ply.CW_isWorking then return end

    timer.Remove( "CITYWORKER.Finish."..ply:SteamID() )
    timer.Remove( "CITYWORKER.Effects."..ply:SteamID() )

    ply:Freeze( false )
    ply.CW_isWorking = false
    ent.CW_isWorked = false
end

-- Finishing an action successfully.
function CITYWORKER.Finish( ply, ent )
    if not ply.CW_isWorking then return end

    local pay = ent.time * CITYWORKER.Config[CITYWORKER_DEFINITIONS[ent:GetClass()][1]].Payout

    ply:SH_AddPremiumPoints(pay, nil, false, false)

    CITYWORKER.Stop( ply, ent )
    
    CITYWORKER.Remove( ply, ent )

    local str = string.Replace( CITYWORKER.Config.Language["PAYOUT"], "%s", pay )
    ply:ChatPrint(str)
end

-- Cancelling a city worker action
function CITYWORKER.Cancel( ply, ent )
    if not ply.CW_isWorking then return end

    CITYWORKER.Stop( ply, ent )
    CITYWORKER.StopAction( ply )

    ply:ChatPrint(CITYWORKER.Config.Language["CANCELLED"])
end

-- Assigning a job to a player
function CITYWORKER.Assign( ply, job, id )
    ply.CW_job = id
        local ent = ents.Create( job.class )
        ent:SetPos( job.pos )
        ent:SetAngles( job.ang )

        ent:Spawn()
        ent.wowtime = false
        ent.Owner = ply
        timer.Simple(240,function()
            if (ent) and ent:IsValid() then
                ent.wowtime = true
                ply:ChatPrint("You have taken too long to complete your job, any engineer may now fix it.")
            end
        end)

        ply.CW_ent = ent

        CITYWORKER.NotifyTask( ply, job.pos )

    ply:ChatPrint(CITYWORKER.Config.Language["NEW_JOB"])
end

-- Find a random job (and remove it from the available list)
function CITYWORKER.Find()
    local _, id = table.Random( availableJobs )

    availableJobs[id] = nil
    local job = CITYWORKER_DATA[game.GetMap()][id]

    return job, id
end

-- Remove a job and add it back to the available list.
function CITYWORKER.Remove( ply, ent )
    if not ent then return end
    if IsValid( ent ) then
        ent:Remove()
    end

    if not ent.Owner.CW_job then return end
    availableJobs[ent.Owner.CW_job] = true
    ent.Owner.CW_job = false
    ent.Owner.CW_ent = false

    CITYWORKER.RemoveTask( ent.Owner, id )
end

-- Find and give a player a random job
function CITYWORKER.Give( ply )
    local job, id = CITYWORKER.Find()

    CITYWORKER.Assign( ply, job, id )
end

-- Default positions for rp_downtown_v4c_v2.
local defaultDowntownPositions = [[{"rp_downtown_v4c_v2":[{"ang":"{180 89.4362 180}","pos":"[-2730.9729 -4094.3481 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 268.9563 180}","pos":"[-2534.145 -3238.051 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 275.5563 180}","pos":"[-2711.1819 -2720.9612 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 270.5403 180}","pos":"[-2611.8032 -649.8069 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 -86.1595 180}","pos":"[-2765.8635 407.4864 -139.9687]","class":"cityworker_rubble"},{"ang":"{180 264.7323 180}","pos":"[-2625.719 995.4451 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 169.9563 180}","pos":"[1205.6621 597.9052 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 169.9563 180}","pos":"[1841.72 781.2602 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 176.4243 180}","pos":"[3049.6458 964.0115 -131.9688]","class":"cityworker_rubble"},{"ang":"{180 176.4243 180}","pos":"[3243.1548 1369.9386 -131.9688]","class":"cityworker_rubble"},{"ang":"{180 274.2364 180}","pos":"[2632.2896 2154.6511 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 -18.1794 -180}","pos":"[1972.2023 4009.5166 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 9.2764 180}","pos":"[1751.6832 3886.9363 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 68.0167 180}","pos":"[-1663.5319 -1801.8516 -131.9687]","class":"cityworker_rubble"},{"ang":"{180 93.2285 180}","pos":"[28.5951 -2250.1211 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 93.2285 -180}","pos":"[107.2463 -3644.4661 -139.9688]","class":"cityworker_rubble"},{"ang":"{180 -0.7555 -180}","pos":"[-579.4224 -4440.4141 -134.9688]","class":"cityworker_rubble"},{"ang":"{180 2.1485 180}","pos":"[-1639.2313 -4530.356 -134.9687]","class":"cityworker_rubble"},{"ang":"{180 2.1485 180}","pos":"[-2103.8926 -4856.417 -134.9688]","class":"cityworker_rubble"},{"ang":"{180 90 180}","pos":"[-2579.2168 -6515.1011 -198.9688]","class":"cityworker_hydrant"},{"ang":"{180 180 180}","pos":"[-1380.4777 -336.4216 -195.9688]","class":"cityworker_hydrant"},{"ang":"{180 0 180}","pos":"[433.6669 969.9175 -195.9688]","class":"cityworker_hydrant"},{"ang":"{180 270 180}","pos":"[1401.4399 3760.8577 -195.9688]","class":"cityworker_hydrant"},{"ang":"{180 90 180}","pos":"[3751.5842 4177.7422 -195.9688]","class":"cityworker_hydrant"},{"ang":"{180 180 180}","pos":"[2392.387 996.0496 -200.1698]","class":"cityworker_hydrant"},{"ang":"{180 180 180}","pos":"[-143.6349 -1295.2845 -195.9688]","class":"cityworker_hydrant"},{"ang":"{180 180 180}","pos":"[-147.5814 -5796.7876 -198.9688]","class":"cityworker_hydrant"},{"ang":"{0 89.029 64.0523}","pos":"[-965.4269 -2327.9353 183.8244]","class":"cityworker_leak"},{"ang":"{-0 91.669 -13.5637}","pos":"[-990.5391 -2416.8127 153.7824]","class":"cityworker_leak"},{"ang":"{0 166.7771 29.0723}","pos":"[767.0926 931.2147 -123.4747]","class":"cityworker_leak"},{"ang":"{0 -131.1827 3.0682}","pos":"[777.0834 928.4988 -172.1062]","class":"cityworker_leak"},{"ang":"{0 230.0054 320.9602}","pos":"[783.3969 934.7285 -131.1924]","class":"cityworker_leak"},{"ang":"{180 9.4189 180}","pos":"[224.4646 338.0514 -117.9933]","class":"cityworker_electric"},{"ang":"{180 157.559 180}","pos":"[-1400.7139 878.4398 -18.0722]","class":"cityworker_electric"},{"ang":"{180 -143.8329 180}","pos":"[-1841.4877 -2481.2839 -37.4562]","class":"cityworker_electric"},{"ang":"{180 176.6992 180}","pos":"[-1426.7728 -639.6265 -142.8109]","class":"cityworker_electric"},{"ang":"{180 83.0756 180}","pos":"[-514.6652 -2069.2134 -54.0313]","class":"cityworker_electric"},{"ang":"{180 58.2595 -180}","pos":"[-509.3264 -2356.7432 -54.0313]","class":"cityworker_electric"},{"ang":"{180 -178.6432 179.9997}","pos":"[-1075.3577 -35.5991 261.0894]","class":"cityworker_electric"},{"ang":"{180 180 180}","pos":"[2793.5339 3067.6199 -195.9688]","class":"cityworker_hydrant"},{"ang":"{180 178.6325 180}","pos":"[-46.5784 -6381.0659 -139.9688]","class":"cityworker_rubble"}]}]]
function CITYWORKER.Initialize()
    print("[CW] Cityworker Initializing")
    CITYWORKER_DATA = {}
    
    if not file.Exists( "cityworker.txt", "DATA" ) then
        file.Write( "cityworker.txt", defaultDowntownPositions )
    end
    
    CITYWORKER_DATA = util.JSONToTable( file.Read( "cityworker.txt" ) ) or {}
    CITYWORKER_DATA[game.GetMap()] = CITYWORKER_DATA[game.GetMap()] or {}
    availableJobs = {}

    for k, v in pairs( CITYWORKER_DATA[game.GetMap()] ) do
        if not CITYWORKER.Config[CITYWORKER_DEFINITIONS[v.class][1]].Enabled then continue end
        availableJobs[k] = true
    end
    
    if timer.Exists( "CITYWORKER.Timer" ) then
        timer.Remove( "CITYWORKER.Timer" )
    end

    -- Checking to see if there are any free city workers, and if there are, give them jobs
    timer.Create( "CITYWORKER.Timer", CITYWORKER.Config.Time, 0, function()
        for _, ply in pairs(player.GetAll()) do
			if getdiseasesys then return end
        	if ply:GetRegiment() ~= "Imperial Naval Engineer" then continue end
            if not ply.CW_job and not ply.givejob then
                ply.givejob = true
                timer.Simple(math.random(60,200),function()
                    CITYWORKER.Give( ply )
                    ply.givejob = false
                end)
            end
        end
    end )
end
hook.Add( "InitPostEntity", "CITYWORKER.InitPostEntity", CITYWORKER.Initialize )
concommand.Add("customcwinit",CITYWORKER.Initialize)

timer.Create( "CITYWORKER.CheckWorkers", 10, 0, function()
    for _, ply in pairs(player.GetAll()) do
       if ply:GetRegiment() ~= "Imperial Naval Engineer" then
       		CITYWORKER.Remove( ply, ply.CW_ent )
       end
   	end
end )

hook.Add( "PlayerDisconnected", "CITYWORKER.PlayerDisconnected", function( ply )
    if ply:GetRegiment() == "Imperial Naval Engineer" then
        CITYWORKER.Remove( ply, ply.CW_ent )
    end
end )

-- Cancel Job
hook.Add( "ShowTeam", "CITYWORKER.ShowTeam", function( ply )
    if ply.CW_isWorking then
        CITYWORKER.Cancel( ply, ply.CW_workEnt )
    end
end )

--[[
    Saving Positions and Such
--]]

util.AddNetworkString( "CITYWORKER.SendData" )
util.AddNetworkString( "CITYWORKER.RequestData" )
util.AddNetworkString( "CITYWORKER.Add" )
util.AddNetworkString( "CITYWORKER.Remove" )

function CITYWORKER.Save()
    file.Write( "cityworker.txt", util.TableToJSON( CITYWORKER_DATA ) )
end

function CITYWORKER.SendData( ply )
    if not ply or not IsValid( ply ) then return end
    if not ply:IsSuperAdmin() then return end

    net.Start( "CITYWORKER.SendData" )
        net.WriteTable( CITYWORKER_DATA[game.GetMap()] or {} )
    net.Send( ply )
end

net.Receive( "CITYWORKER.Add", function( len, ply )
    if not ply:IsSuperAdmin() then return end
    
    --[[if #CITYWORKER_DATA[game.GetMap()] > 255 then 
        ply:ChatPrint("The maximum number of city worker positions is 255!")
        return
    end]]
    
    local class = net.ReadString()

    local pos = ply:GetEyeTrace().HitPos
    local ang = ply:EyeAngles()

    if class == "cityworker_leak" then
        ang:RotateAroundAxis( ang:Up(), 90 )
    elseif class == "cityworker_rubble" then
        ang:RotateAroundAxis( ang:Right(), 180 )
        ang.x = 180
        pos.z = pos.z + 64
    elseif class == "cityworker_electric" then
        ang:RotateAroundAxis( Vector( 1, 0, 0 ), 180 )
        ang.x = 180
    else
        return
    end

    table.insert( CITYWORKER_DATA[game.GetMap()], { class = class, pos = pos, ang = ang } )

    CITYWORKER.Save()

    CITYWORKER.Initialize()

    CITYWORKER.SendData( ply )

    ply:ChatPrint("Successfully added new city worker task!")
end )

net.Receive( "CITYWORKER.Remove", function( len, ply )
    if not ply:IsSuperAdmin() then return end
    local k = net.ReadUInt( 8 )

    CITYWORKER_DATA[game.GetMap()][k] = nil

    CITYWORKER.Save()

    CITYWORKER.SendData( ply )

    CITYWORKER.Initialize()

    ply:ChatPrint("Successfully remove a city worker task!")
end )

concommand.Add( "cw_removeall", function( ply )
    if not IsValid( ply ) then return end
    if not ply:IsSuperAdmin() then return end

    table.Empty( CITYWORKER_DATA[game.GetMap()] )
    CITYWORKER.Save()

    ply:PrintMessage( HUD_PRINTCONSOLE, "Removed entity positions for this map!" )
end )

concommand.Add( "cw_removeallmaps", function( ply )
    if not IsValid( ply ) then return end
    if not ply:IsSuperAdmin() then return end

    table.Empty( CITYWORKER_DATA )
    CITYWORKER.Save()

    ply:PrintMessage( HUD_PRINTCONSOLE, "Removed entity positions from all maps!" )
end )
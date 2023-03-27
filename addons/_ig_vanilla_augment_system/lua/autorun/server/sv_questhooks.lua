include("autorun/server/sv_datastorage.lua")

hook.Add("PlayerDeath","VANILLAAUGMENTS_hook_MementoMori",function(vic,item,ply)
    if not vic:IsPlayer() then return end
    AdvanceQuest(vic,"Daily","Memento Mori")
end)

hook.Add("PlayerSwitchFlashlight","VANILLAAUGMENTS_hook_FlashlightQuest",function(ply)
    AdvanceQuest(ply,"Daily","Let There Be Light")
end)

hook.Add("PlayerTick","VANILLAAUGMENTS_hook_PlayerTick",function(ply,mv)
    if ply:KeyPressed(IN_DUCK) then
        AdvanceQuest(ply,"Daily","Thunder Thighs I")
        AdvanceQuest(ply,"Daily","Thunder Thighs II")
    end
    if ply:KeyPressed(IN_JUMP) and ply:OnGround() then
        AdvanceQuest(ply,"Weekly", "Never Skip Leg Day")
    end
    if (ply:GetActiveWeapon().Base == "tfa_gun_base" or ply:GetActiveWeapon().Base == "tfa_3dscoped_base") and ply:KeyPressed(IN_ATTACK2) then
        timer.Create("VANILLAAUGMENTS_timer_GunScope",0.5,1,function()
            AdvanceQuest(ply,"Daily", "I've Got You In My Sights")
        end)
    end
end)

hook.Add("PlayerButtonDown", "VANILLAAUGMENTS_hook_PlayerButtonDown", function(ply, key)
    if key == KEY_F12 then
        AdvanceQuest(ply,"Daily","Take a Picture")
    end
end)

hook.Add("PlayerDeath","VANILLAAUGMENTS_hook_ECQuest",function(vic,item,ply)
    if not ply:IsPlayer() then return end
    if vic == ply then return end
    if (vic:GetRegiment() == "Event" or vic:GetRegiment() == "Event2") then
        AdvanceQuest(ply,"Weekly","Cleanup Crew")
    end
end)

hook.Add("playerclimbjump", "VANILLAAUGMENTS_hook_ClimbSwep", function(player, jumps)
    if (player:IsPlayer()) and jumps ~= 0 then
        AdvanceQuest(player,"Daily","Climbing Expert I")
        AdvanceQuest(player,"Daily","Climbing Expert II")
        AdvanceQuest(player,"Weekly","Sky's the Limit")
    end
end)

hook.Add("PlayerFootstep","VANILLAAUGMENTS_hook_Footstep",function(ply)
    AdvanceQuest(ply,"Daily","Gifted with Legs I")
    AdvanceQuest(ply,"Daily","Gifted with Legs II")
    AdvanceQuest(ply,"Daily","Gifted with Legs III")
    if ply:IsSprinting() then
        AdvanceQuest(ply,"Weekly","Run Like You Mean It")
    end
end)

hook.Add("IGPlayerSay","VANILLAAUGMENTS_hook_IGPlayerSay",function(ply,msg,team)
    if string.StartWith(msg,"/comms ",false) then
        AdvanceQuest(ply,"Daily","Communication is Key")
    end
    for k, v in pairs(player.GetAll()) do
        if msg == v:Nick() and ply ~= v then
            AdvanceQuest(v,"Daily","The One and Only")
        end
    end
    if msg == "!content" then
        AdvanceQuest(ply,"Daily","Up to Date")
    end
    if msg == "Yes, sir." then
        AdvanceQuest(ply,"Daily","The Follower")
    end
end)

hook.Add("EntityFireBullets","VANILLAAUGMENTS_hook_EntityFireBullets",function( ply, data )
    if not ply:IsPlayer() then return end
    AdvanceQuest(ply,"Daily","Not Just a Stormtrooper")
end)

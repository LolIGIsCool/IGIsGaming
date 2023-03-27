AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")

include ("shared.lua")

util.AddNetworkString("Hideyoshi_BeginDefibSearch")
util.AddNetworkString("Hideyoshi_BeginDefib")
util.AddNetworkString("Hideyoshi_defibfx")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Cooldown = CurTime()

hook.Add("DoPlayerDeath", "Hideyoshi_DefibDeathTimer", function( ply )
    ply.Hideyoshi_TimeDied = CurTime()
end)

//prevent defib, cuff exploit
hook.Add("PlayerSpawn", "HIDEYOSHI_DEFIB_HOOK_PLAYERSPAWN", function( ply )
	ply:SetVar("defibCanSwitch", true);
end)

function makefx(ent1, pos, str, ent2, broadcast)
	net.Start("Hideyoshi_defibfx")
        net.WriteEntity(ent1)
        net.WriteVector(pos)
        net.WriteString(str)
        net.WriteEntity(ent2)
	if broadcast then net.Broadcast()
	else net.Send(ent2) end
end

local delay = 0;

function SWEP:PrimaryAttack()
    if delay > CurTime() then return end

    net.Start("Hideyoshi_BeginDefibSearch")
        self.Owner:SetNWEntity("Assigned_Defib", self)
    net.Send(self.Owner)

    delay = CurTime() + 6;
end

net.Receive("Hideyoshi_BeginDefib", function( len, ply )
    local target_ply = net.ReadEntity()
    if ply:GetNWEntity("Assigned_Defib"):GetClass() == "hideyoshi_ig_defibs" and ply:GetNWEntity("Assigned_Defib").Owner == ply  then

        local defibUnit = ply:GetNWEntity("Assigned_Defib")
        local SpawnPoint = defibUnit.Owner:GetEyeTraceNoCursor().HitPos + defibUnit.Owner:GetEyeTraceNoCursor().HitNormal*16

        if IsValid(target_ply) && !target_ply:Alive() then

			defibUnit.Owner:SetVar("defibCanSwitch", false);

            defibUnit.Owner:SendLua("RunConsoleCommand('simple_thirdperson_enabled','0')")
            --defibUnit.Owner:Freeze( true )
            defibUnit.Owner:SetWalkSpeed(1)
            defibUnit.Owner:SetRunSpeed(1)
            defibUnit.Owner:SetSlowWalkSpeed(1)

            defibUnit:GetOwner():GetViewModel():SendViewModelMatchingSequence(3)
                
            local BeforeDeath_Weapons_Hideyoshi = {}
                for k,v in pairs(target_ply:GetWeapons()) do
                    table.insert(BeforeDeath_Weapons_Hideyoshi, v:GetClass())
                end

            defibUnit.Owner:SendLua("chat.AddText('DEFIBRILLATING - "..target_ply:Nick().."')")
            timer.Simple(5, function()
				defibUnit.Owner:SetVar("defibCanSwitch", true);

                if target_ply.Hideyoshi_TimeDied + 300 < CurTime() then
                    defibUnit.Owner:SendLua("chat.AddText( Color(255,0,0), 'ERROR 32A - SUBJECT BRAINDEAD')")
                    --defibUnit.Owner:Freeze( false )
                    _G.ApplySpeedBoosters(defibUnit.Owner);

                    defibUnit:GetOwner():GetViewModel():SendViewModelMatchingSequence(0)
                    return
                end

                target_ply:Spawn()
                target_ply:SetPos(SpawnPoint)

                for k,v in pairs(BeforeDeath_Weapons_Hideyoshi) do
                    target_ply:Give(v)
                end

                makefx(target_ply, target_ply:GetPos(), "spark", target_ply, true)
                defibUnit:EmitSound("weapons/physcannon/superphys_small_zap"..math.random(1,4)..".wav")

                defibUnit:GetOwner():GetViewModel():SendViewModelMatchingSequence(0)
                defibUnit.Owner:SetAnimation(PLAYER_ATTACK1)

                --defibUnit.Owner:Freeze( false )
                _G.ApplySpeedBoosters(defibUnit.Owner);
            end)

            --[[timer.Create("ResetPlayerSpeed"..defibUnit.Owner:SteamID(), 5, 1, function()
                defibUnit.Owner:SetWalkSpeed(movespeed)
                defibUnit.Owner:SetRunSpeed(runspeed)
                defibUnit.Owner:SetSlowWalkSpeed(100)
            end)]]--

        else
            defibUnit.Owner:SendLua("chat.AddText( Color(255,0,0), 'ERROR 83A - ANOMALY DETECTED - SUBJECT GONE')")
        end
    end
end)

hook.Add("PlayerSwitchWeapon", "HIDEYOSHI_DEFIB_HOOK_PLAYERSWITCHWEAPON", function( ply )
	if not ply:GetVar("defibCanSwitch", true) then return true end;
end)
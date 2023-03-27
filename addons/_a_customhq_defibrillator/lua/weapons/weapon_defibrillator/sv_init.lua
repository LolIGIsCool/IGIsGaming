if CLIENT then return end
function makefx(ent1, pos, str, ent2, broadcast)
	net.Start("defibfx")
	net.WriteEntity(ent1)
	net.WriteVector(pos)
	net.WriteString(str)
	net.WriteEntity(ent2)
	if broadcast then net.Broadcast()
	else net.Send(ent2) end
end

function PlayerDied(ply)
	makefx(ply, Vector(0, 0, 0), "decharge", ply, false)
	local defib = weapons.GetStored("weapon_defibrillator")
	if defib.GiveWeaponsBack then
		ply.DefibWeps = {}
		for k,v in pairs(ply:GetWeapons()) do table.insert(ply.DefibWeps, v:GetClass()) end
	end
	if defib.DeathBeepEnabled then
		makefx(ply, Vector(0, 0, 0), "sound", ply, false)
	end
	ply.TimeDied = CurTime()
	makefx(ply, Vector(0, 0, 0), "timedied", ply, true)
end

function PlayerSpawned(ply)
	if ply.DefibRagdoll then
		ply.DefibWeps = {}
	end
end

hook.Add("DoPlayerDeath", "defibhandledeath", PlayerDied)
hook.Add("PlayerSpawn", "defibhandlespawn", PlayerSpawned)
hook.Add("PlayerDeathSound", "defibmakedeath", function() return !weapons.Get("weapon_defibrillator").DeathBeepEnabled end)
net.Receive("defibgiveents", function(len, ply)
	local weapon = ply:GetActiveWeapon()
	local isRevive, otherPly, pos = net.ReadBool(), net.ReadEntity(), net.ReadVector()
	local plyPos = ply:GetPos()
	local eyetrace = ply:GetEyeTraceNoCursor()
	if !otherPly:IsPlayer() then otherPly = otherPly.Owner end
	if !ply:VisibleVec(pos) or weapon:GetClass() != "weapon_defibrillator" or !IsValid(otherPly) or !IsValid(weapon) or (!isRevive and !weapon.AllowDamage) then return end
	weapon:EmitSound("weapons/physcannon/superphys_small_zap"..math.random(1,4)..".wav")
	weapon.CanUse = 0
	weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	weapon:SetNextSecondaryFire(CurTime() + 2)
	makefx(ply, Vector(0, 0, 0), "decharge", ply, false)
	hook.Call("customhq.defib.onPlayerInteraction", nil, ply, otherPlayer, isRevive, pos)
	if isRevive then
		if (otherPly.TimeDied+weapon.TimeToRevive)-CurTime() < 0 then
			makefx(ply, Vector(1, 1, 1), "toolongdead", ply, false)
			makefx(ply, Vector(0, 0, 0), "toolongdead", otherPly, false)
			return
		end
		if weapon.GiveMedicRPCash != 0 and DarkRP != nil then
			ply:addMoney(weapon.GiveMedicRPCash)
			DarkRP.notify(ply, 3, 6, "You've received $"..weapon.GiveMedicRPCash)
		end
		makefx(otherPly, otherPly:GetPos(), "spark", otherPly, true)
		timer.Simple(0.3, function()
			otherPly:Spawn()
			otherPly:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			otherPly:SetPos(eyetrace.HitPos + eyetrace.HitNormal*16)
			--otherPly:SetHealth(50)
			--otherPly:SetHealth(otherPly:GetMaxHealth() / 4 )
			
			if weapon.GiveWeaponsBack then
				for k,v in pairs(otherPly.DefibWeps) do otherPly:Give(v) end
			end
			otherPly:SetRenderMode(RENDERMODE_TRANSALPHA)
			otherPly:SetColor(Color(255, 255, 255, 125))
		end)
		timer.Simple(weapon.GhostTime, function()
		    --otherPly:SetHealth(50)
		    otherPly:SetHealth(TeamTable[otherPly:GetRegiment()][otherPly:GetRank()].Health / 4 )
			--otherPly:SetMaxHealth(TeamTable[otherPly:GetRegiment()][otherPly:GetRank()].Health)
			otherPly:SetCollisionGroup(COLLISION_GROUP_NONE)
			otherPly:SetColor(Color(255, 255, 255, 255))
		end)
	else
		makefx(ply, ply:GetEyeTrace().HitPos, "spark", ply, true)
		otherPly:TakeDamage(weapon.Damage)
	end
	ply:SetAnimation(PLAYER_ATTACK1)
end)
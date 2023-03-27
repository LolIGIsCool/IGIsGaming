AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
resource.AddWorkshop("828048302")

print("fuck")

function GM:UpdateAnimation()
end

function GM:CalcMainActivity(ply, velocity)
	return ply.CalcIdeal, -1
end

function GM:Think()
	for k, v in ipairs(player.GetAll()) do
		if (v.Checked or 0) <= CurTime() then
			v.Checked = CurTime() + 0.4
			v.CalcIdeal = ACT_MP_STAND_IDLE
			v.m_bInSwim = false

			if v:Crouching() then
				if v:GetVelocity():Length2DSqr() > 0.25 then
					v.CalcIdeal = ACT_MP_CROUCHWALK
				else
					v.CalcIdeal = ACT_MP_CROUCH_IDLE
				end
			elseif v:WaterLevel() > 2 and not v:OnGround() then
				v.CalcIdeal = ACT_MP_SWIM
				v.m_bInSwim = true
			else
				local len2d = v:GetVelocity():Length2DSqr()

				if len2d > 22500 then
					v.CalcIdeal = ACT_MP_RUN
				elseif len2d > 0.25 then
					v.CalcIdeal = ACT_MP_WALK
				end
			end

			local wep = v:GetActiveWeapon()

			if IsValid(wep) and wep.PlayerThink and wep.IsTFAWeapon then
				wep:PlayerThink(v)
			end
		end
	end
end

local plymeta = FindMetaTable("Player")

local plymeta = FindMetaTable("Player")

function plymeta:BreakLeg()
    if self.brokenleg then return end
    self:ChatPrint("Ouch! You have fallen from a great height and broken your legs, see a medic for assistance or wait for it to heal!")
    self:SetWalkSpeed(self:GetWalkSpeed() * 0.6)
    self:SetRunSpeed(self:GetRunSpeed() * 0.5)
    self.brokenleg = true

    timer.Create(self:SteamID64() .. "BrokenLeg", 120, 1, function()
        if not self.brokenleg then return end
        self:ChatPrint("Your leg has naturally healed, don't be silly next time!")
        self.brokenleg = false
        ApplySpeedBoosters(self);
    end)
end

function GM:PlayerDisconnected(ply)
    timer.Remove(ply:SteamID64() .. "BrokenLeg")
end

function GM:GetFallDamage(ply, flFallSpeed)
    local damage = (flFallSpeed - 526.5) * (100 / 396)

    if (damage >= 15) and (math.random(1, 10) <= 4) and (_G.HasAugment(ply, "Durasteel Skeleton") == false) then
        ply:BreakLeg()
    end

    if _G.HasAugment(ply, "Durasteel Skeleton") then
        _G.ActivateAugment(ply,"Durasteel Skeleton",3)
    end

    return damage
end

function GM:TranslateActivity()
end

function GM:PlayerButtonDown()
end

function GM:PlayerButtonUp()
end

function GM:Move()
end

function GM:GetTeamTBLParts()
	local countspart = math.Round(table.Count(TeamTable) / 5)
	local part1 = {}
	local part2 = {}
	local part3 = {}
	local part4 = {}
	local part5 = {}

	for k, v in pairs(TeamTable) do
		if table.Count(part1) <= countspart then
			part1[k] = v
		elseif table.Count(part2) <= countspart then
			part2[k] = v
		elseif table.Count(part3) <= countspart then
			part3[k] = v
		elseif table.Count(part4) <= countspart then
			part4[k] = v
		else
			part5[k] = v
		end
	end

	return {part1, part2, part3, part4, part5}
end

function GM:NetworkTeamTBL(ply)
	local partcount = 0

	for k, v in pairs(self:GetTeamTBLParts()) do
		partcount = partcount + 1
		local compressedTbl = util.Compress(util.TableToJSON(v))
		local size = string.len(compressedTbl)
		net.Start("networkteamtblfull")
		net.WriteUInt(size, 32)
		net.WriteData(compressedTbl, size)
		net.Send(ply)
		IGDEBUG("[IG-GAMEMODE] Sending part " .. partcount .. " (" .. size .. " bytes) to " .. ply:Nick())
	end
end

function GM:NetworkCountTBL(ply)
	local compressedTbl = util.Compress(util.TableToJSON(CountTable))
	local size = string.len(compressedTbl)
	net.Start("networkcounttblfull")
	net.WriteUInt(size, 32)
	net.WriteData(compressedTbl, size)
	net.Send(ply)
end

function GM:SetupMove(ply)
	if ply.igloaded then return end
	ply.igloaded = true
	IGDEBUG("[IG-GAMEMODE] Initializing " .. ply:Nick())
	self:NetworkTeamTBL(ply)
	IGDEBUG("[IG-GAMEMODE] Sending countbl to " .. ply:Nick())
	self:NetworkCountTBL(ply)
	IGDEBUG("[IG-GAMEMODE] Initalization finished on " .. ply:Nick())
end

function GM:FinishMove()
end

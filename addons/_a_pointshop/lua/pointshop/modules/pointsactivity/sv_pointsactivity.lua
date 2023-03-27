local meta = FindMetaTable("Player")
if not meta then return end

function meta:CheckAdvertiserMoose()
	local plyName = self:OldNick()

	if string.find(plyName, "IG", 1, true) then
		self.IsAdvertiserMoose = true
		--print( self:Nick() .. " has IG in their name" )
	else
		self.IsAdvertiserMoose = false
		--print( self:Nick() .. " doesnt have IG in their name" )
	end
end

hook.Add("PlayerSpawn", "CheckAdvertiserMoose", meta.CheckAdvertiserMoose)
local MODULE = MODULE or SH_POINTSHOP.Modules.pointsactivity
local lp = {}

function MODULE:AwardPoints()
	local ct = CurTime()
	local groups = self.Config.GroupMultiplier
	local afktime = self.Config.AFKTime

	for _, v in ipairs(player.GetAll()) do
		local last = lp[v:SteamID()]
		local mult = groups[v:GetUserGroup()] or 1
		if (not v.SH_POINTSHOP_READY) then continue end
		if (mult <= 0) then continue end
		if (not last) or (ct - last >= afktime) then continue end
		local std = 0
		local std = math.Round(self.Config.StandardPoints * mult)
		local prm = math.Round(self.Config.PremiumPoints * mult)
		v:CheckAdvertiserMoose()

		if v.IsAdvertiserMoose == true then
			std = math.Round(self.Config.PremiumPoints * mult + 50)
		else
			std = math.Round(self.Config.PremiumPoints * mult)
		end

		local questprog = v:GetNWInt("igprogressp", 0)

		if questprog >= 4 then
			std = std * 1.15
		end

		if (std > 0) then
			v:SH_AddPremiumPoints(std, nil, false, false)
		end

		if (prm > 0) then
			v:SH_AddPremiumPoints(std, nil, false, false)
		end

		v:SH_SendNotification(SH_POINTSHOP:LangFormat(SH_POINTSHOP.Language.pa_message, {
			award = SH_POINTSHOP:GetPriceString(std, pre)
		}), true)
	end
end

-- AFK checker
hook.Add("KeyPress", "SH_POINTSHOP.PointsActivity", function(ply, key)
	lp[ply:SteamID()] = CurTime()
end)

timer.Create("SH_POINTSHOP.PointsActivity", MODULE.Config.AwardInterval, 0, function()
	MODULE:AwardPoints()
end)

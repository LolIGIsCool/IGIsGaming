local ps = SH_POINTSHOP
local easynet = ps.easynet
local MODULE = MODULE or ps.Modules.transferpoints

function MODULE:TransferPoints(ply, target, standard, premium)
	if (!self.Config.Enable) then
		return end

	standard = self:CanStandardTransfer(ply, standard) and standard or 0
	premium = self:CanPremiumTransfer(ply, premium) and premium or 0

	if (!IsValid(target) or target == ply) or (standard == 0 and premium == 0) then
		return end

	local allowed, why = self:CanTransferTo(ply, target)
	if (allowed == false) then
		ply:SH_SendNotification(ps.Language[why] or why, false)
		return
	end

	if (!ps:IsAdmin(ply)) then
		if (standard < self.Config.MinimumStandardPoints) then
			return end

		if (self.Config.MaximumStandardPoints > 0) then
			standard = math.min(standard, self.Config.MaximumStandardPoints)
		end

		if (premium < self.Config.MinimumPremiumPoints) then
			return end

		if (self.Config.MaximumPremiumPoints > 0) then
			premium = math.min(premium, self.Config.MaximumPremiumPoints)
		end
	end

	if not (ps:Assert(ply:SH_CanAfford(standard, premium), ply, "pt_notenough")) then
		return end

	-- Check limits
	local lim_std = ps.MaxStandardPoints(target) or 0
	if (standard > 0 and lim_std > 0) then
		if not (ps:Assert(ply:SH_GetStandardPoints() + standard <= lim_std, ply, ps:LangFormat("pt_limitreached", {recipient = target:Nick()}))) then
			return end
	end

	local lim_prm = ps.MaxStandardPoints(target) or 0
	if (premium > 0 and lim_prm > 0) then
		if not (ps:Assert(ply:SH_GetPremiumPoints() + premium <= lim_prm, ply, ps:LangFormat("pt_limitreached", {recipient = target:Nick()}))) then
			return end
	end
    
    ulx.fancyLogAdmin(ply, "#A sent #T #s credits", target, premium)

	ply:SH_AddStandardPoints(-standard, nil, true, true)
	ply:SH_AddPremiumPoints(-premium, nil, true, true)
	ply:SH_SavePointshop()
	ply:SH_TransmitPoints()

	target:SH_AddStandardPoints(standard, nil, true, true)
	target:SH_AddPremiumPoints(premium, nil, true, true)
	target:SH_SavePointshop()
	target:SH_TransmitPoints()

	_G.AdvanceQuest(ply,"Daily","OUR Credits")

	ply:SH_SendNotification(ps:LangFormat("pt_success", {points = ps:GetPriceString(standard, premium), recipient = target:Nick()}), true)
    local transferloggers = "User " .. ply:Nick() .. "(" .. ply:SteamID() .. ") has just transferred " .. premium .. " credits to " .. target:Nick() .. "(" .. ply:SteamID() .. ") | " .. os.date("%x - %X") .. " | \n"
    file.Append("transferlog.txt", transferloggers)
	target:SH_SendNotification(ps:LangFormat("pt_receipt", {points = ps:GetPriceString(standard, premium), sender = ply:Nick()}), true)
end

easynet.Callback("SH_POINTSHOP.TransferPoints", function(data, ply)
	MODULE:TransferPoints(ply, data.target, data.standard, data.premium)
end)

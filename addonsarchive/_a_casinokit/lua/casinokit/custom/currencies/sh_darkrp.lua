local CURRENCY = {}

-- dont archive on client
local fflags = SERVER and bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY) or FCVAR_REPLICATED

local cvar_darkrp_to = CreateConVar("casinokit_chiprate_darkrp_money2chips", "0.1", fflags, "how many tokens per darkrp money player gets. This gets rounded down")
local cvar_darkrp_fee = CreateConVar("casinokit_chiprate_darkrp_exchangefee", "0.01", fflags, "the percentage taken from player when they exchange from chips to money")

CURRENCY.NiceName = "Imperial Gaming"
CURRENCY.UnitName = "credit"
CURRENCY.UnitPluralName = "credits"

function CURRENCY:isEnabled()
	return true
end

function CURRENCY:getExchangeRateFromCurrencyToChips(ply)
	return cvar_darkrp_to:GetFloat(), 0
end

function CURRENCY:getExchangeRateFromChipsToCurrency(ply)
	local feeFrac = cvar_darkrp_fee:GetFloat()
	local baseRate = (1 / cvar_darkrp_to:GetFloat())

	return baseRate * (1 - feeFrac), baseRate * feeFrac
end

function CURRENCY:addPlayerCurrency(ply, amount, desc)
	--[[if ply.addMoney then
		ply:addMoney(amount)
	else
		ply:AddMoney(amount)
	end]]
	ply:SH_AddPremiumPoints(amount, nil, false, false)
	ply:PrintMessage(HUD_PRINTCONSOLE, "[CasinoKit] Modified credits " .. amount .. ". Reason: " .. tostring(desc))
end
function CURRENCY:canPlayerAfford(ply, amount)
	--[[if ply.canAfford then
		return ply:canAfford(amount)
	else
		return ply:CanAfford(amount)
	end]]
	return ply:SH_CanAffordPremium(amount)
end

CasinoKit.registerCurrency("darkrp", CURRENCY)

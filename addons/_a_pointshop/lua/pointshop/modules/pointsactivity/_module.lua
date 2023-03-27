MODULE = {}

-- The class name of the module. It MUST only contain lowercase characters and no special characters.
MODULE.ClassName = "pointsactivity"

-- The name of the module displayed in the admin menu.
MODULE.Name = "Points for Activity"

-- The description of the module.
MODULE.Description = "Awards points to players for being online."

-- Here you can easily configure this module's options!
MODULE.Config = {
	-- Should this module be enabled?
	Enable = true,

	-- How often should points be awarded? In seconds.
	--AwardInterval = 300,
	AwardInterval = 300,

	-- How many Standard Points are given for being active.
	StandardPoints = 0, -- was 40

	-- How many Premium Points are given for being active.
	PremiumPoints = 50,

	-- Should points be given to AFK players?
	GiveToAFK = false,

	-- How much time must pass without pressing a key to be considered as AFK?
	-- In seconds.
	AFKTime = 200,

	-- Point multiplier depending on the player's group. Defaults to 1.
	GroupMultiplier = {
	    ["Owner"] = 2,
        ["Founder"] = 2,
        ["Community Manager"] = 2,
        ["Community Event Manager"] = 2,
        ["Server Manager"] = 2,
        ["Server Event Manager"] = 2,
        ["superadmin"] = 2,
        ["admin"] = 2,
        ["Senior Moderator"] = 2,
        ["Moderator"] = 2,
        ["Junior Moderator"] = 2,
        ["Trial Moderator"] = 2,
        ["Senior Event Master"] = 2,
        ["Event Master"] = 2,
        ["Junior Event Master"] = 2,
        ["Trial Event Master"] = 2,
        ["Junior Event Master"] = 2,
        ["Community Developer"] = 2,
        ["Senior Developer"] = 2,
        ["Developer"] = 2,
        ["Junior Developer"] = 2,
		["Benefactor"] = 2,
        ["Patron"] = 2.5,
		["Donator"] = 1.5,
		["Tier 1"] = 1.5,
		["Tier 2"] = 1.5,
		["Tier 3"] = 1.5,
	},
}

-- Load the module files here.
if (SERVER) then
	include("sv_pointsactivity.lua")
end

-- Register the module here.
SH_POINTSHOP:RegisterModule(MODULE)
MODULE = nil

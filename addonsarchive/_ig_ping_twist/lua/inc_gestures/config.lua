-- developed for gmod.store
-- from incredible-gmod.ru with love <3
-- https://www.gmodstore.com/market/view/gestures

hook.Run("IncGestures/ConfigIncluded") -- do not touch this line

-- INC_GESTURES:Add(*string* "Custom Name", {*string* Sequence = "sequence_here", *string* Icon = "path/to/icon.png" or "https://website.com/image.png", *function optional* CustomCheck = function(ply) return ply:IsSuperAdmin() end})
-- Use sequence viewer https://steamcommunity.com/sharedfiles/filedetails/?id=2493778309 for list all player animations

-- Best icons can be found here: https://www.flaticon.com/search?word=lamp&license=selection&color=1&stroke=1&order_by=4&type=icon (free + black filled = :cool:)

															   -- You can also use regular materials path if u wanna.
INC_GESTURES:Add("On My Way", {Sequence = "gesture_disagree_original", Icon = "https://i.imgur.com/qPFeM2K.png"})
INC_GESTURES:Add("Ping", {Sequence = "gesture_agree_original", Icon = "ping/general.png"})
INC_GESTURES:Add("Caution", {Sequence = "gesture_bow_original", Icon = "https://i.imgur.com/M90BVSC.png"})
INC_GESTURES:Add("Attack", {Sequence = "gesture_becon_original", Icon = "https://i.imgur.com/FJZQpvn.png"})
INC_GESTURES:Add("Hold Here", {Sequence = "gesture_bow_original", Icon = "https://i.imgur.com/QvJXVmO.png"})
INC_GESTURES:Add("Need Assistance", {Sequence = "gesture_bow_original", Icon = "https://i.imgur.com/InXSYGk.png"})


-- Also you can add specific gestures for job
--[[ Example:
TEAM_EXAMPLE = DarkRP.createJob("Example team", {
    gestures = {
		{Name = "Cover", Sequence = "seq_cower", Icon = "gestures/cover.png", Price = 1337}
    },
    ...
})
]]--

INC_GESTURES.Theme = "shendow" -- regular/military/discord/shendow/e.t.c themes can be found here: garrysmod/addons/gestures/lua/gestures/themes (you can also create your own color theme - it's easy)

INC_GESTURES.Lang = "en" -- en/ru/fr/e.t.c langs can be found here: garrysmod/addons/gestures/lua/gestures/langs

INC_GESTURES.Key = "g" -- Default keybind (players also can change keybind with 'gestures_key' cvar locally. the local bind has no priority over this variable since 1.1.3, so cvar will be reset to the config value when the keybind is changed in the config.)

INC_GESTURES.Fonts = {
	GestureName = { -- center text in radial menu
		font = "Roboto Bold",
		size = 44
	},
	GestureNpcMenuTitle = { -- title in vendor menu header
		font = "Roboto Bold",
		size = 20
	},
	GestureNpcMenuSearch = { -- search-bar font
		font = "Roboto",
		size = 15
	},
	GestureNpcMenuGestureName = { -- gesture name
		font = "Roboto Bold",
		size = 18
	},
	GestureNpcMenuGesturePrice = { -- gesture price
		font = "Roboto",
		size = 16
	},
	GestureNpcOverhead = { -- text above the npc head
		font = "Roboto Bold",
		size = 32
	}
}

-- Radial menu properties
INC_GESTURES.Radius = 290 -- how far the sections will be from the center of the screen
INC_GESTURES.Thickness = 90 -- sections thickness
INC_GESTURES.Scale = 0.6 -- radial menu scale
INC_GESTURES.IconSize = 55
INC_GESTURES.IconSizeHovered = 52

-- Npc menu size
INC_GESTURES.NpcMenuWide = 600
INC_GESTURES.NpcMenuTall = 640

INC_GESTURES.IsAdmin = function(ply) -- Who can use admin commands?
	return ply:IsSuperAdmin()
end

hook.Run("IncGestures/ConfigLoaded")  -- do not touch this line
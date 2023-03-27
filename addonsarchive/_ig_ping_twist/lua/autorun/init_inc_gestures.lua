-- developed for gmod.store
-- from incredible-gmod.ru with love <3
-- https://www.gmodstore.com/market/view/7697

local include_realm = {
    sv = SERVER and include or function() end,
    cl = SERVER and AddCSLuaFile or include
}

include_realm.sh = function(f)
    include_realm.sv(f)
    include_realm.cl(f)
end

if CLIENT and INC_GESTURES then
	if IsValid(INC_GESTURES.Parent) then INC_GESTURES.Parent:Remove() end
	if IsValid(INC_GESTURES.Panel) then INC_GESTURES.Panel:Remove() end
end

INC_GESTURES = {}
INC_GESTURES.__index = INC_GESTURES
INC_GESTURES.Sections = {}

include_realm.cl("inc_gestures/src/cl_configuration.lua")
include_realm.sh("inc_gestures/src/sh_configuration.lua")

include_realm.sh("inc_gestures/config.lua")

include_realm.cl("inc_gestures/lib/cl_blur.lua")
INC_GESTURES.ArcLib = include_realm.cl("inc_gestures/lib/cl_drawarc.lua")




include_realm.sh("inc_gestures/src/sh_main.lua")
include_realm.sv("inc_gestures/src/sv_main.lua")
include_realm.cl("inc_gestures/src/cl_main.lua")
include_realm.cl("inc_gestures/src/cl_menu.lua")
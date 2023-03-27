wOS = wOS || {}
wOS.PES = wOS.PES || {}

if SERVER then
    //TEMPP RRESOURCE ADD TTILL ALL OTHHER ICONSS ARRE REAADY
    resource.AddSingleFile( "materials/wos/pes/bg.png" )
end

local base_dir = "wos/pes"

if SERVER then
    AddCSLuaFile( base_dir .. "/config/general/sh_config.lua")
end
include( base_dir .. "/config/general/sh_config.lua")


if SERVER then

    AddCSLuaFile( base_dir .. "/vgui/nodebackground.lua" )
    AddCSLuaFile( base_dir .. "/vgui/wos_node.lua" )

    AddCSLuaFile( base_dir .. "/core/sh_mod_mount.lua")
    AddCSLuaFile( base_dir .. "/core/sh_var_mount.lua")

    AddCSLuaFile( base_dir .. "/core/cl_core.lua")
    AddCSLuaFile( base_dir .. "/core/cl_net.lua")
    AddCSLuaFile( base_dir .. "/core/cl_accessors.lua")


    include( base_dir .. "/core/sh_var_mount.lua" )
    include( base_dir .. "/core/sh_mod_mount.lua" )
    wOS.PES:ServerInclude( base_dir .. "/core/sv_sub_mount.lua")
    wOS.PES:ServerInclude( base_dir .. "/core/sv_trigger_mount.lua")
    wOS.PES:ServerInclude( base_dir .. "/core/sv_net.lua")
    wOS.PES:ServerInclude( base_dir .. "/core/sv_core.lua")
    

else

    include( base_dir .. "/vgui/nodebackground.lua" )
    include( base_dir .. "/vgui/wos_node.lua" )

    include( base_dir .. "/core/sh_mod_mount.lua")
    include( base_dir .. "/core/sh_var_mount.lua")

    include( base_dir .. "/core/cl_core.lua")
    include( base_dir .. "/core/cl_net.lua")
    include( base_dir .. "/core/cl_accessors.lua")

end

hook.Call( "wOS.PES.OnLoaded" )
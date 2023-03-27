TOOL.Category		= "Vanilla"
TOOL.Name			= "Vanilla's Explosion Tool"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.AdminOnly		= true

if ( CLIENT ) then
    language.Add( "Tool.vanilla_explosion_tool.name", "Explosion Tool" )
    language.Add( "Tool.vanilla_explosion_tool.desc", "Create explosions at the press of a button." )
    language.Add( "Tool.vanilla_explosion_tool.left", "Target a position for an explosion to occur at.")

    -- Precache 4 Client
    game.AddParticles( "particles/harry_explosion.pcf" )
end

game.AddParticles( "particles/harry_explosion.pcf" )
PrecacheParticleSystem("har_explosion_a")
PrecacheParticleSystem("har_explosion_b")
PrecacheParticleSystem("har_explosion_c")
PrecacheParticleSystem("har_explosion_a_air")
PrecacheParticleSystem("har_explosion_b_air")
PrecacheParticleSystem("har_explosion_c_air")

TOOL.Information = {

    { name = "left" }

}

TOOL.ClientConVar["explosionType"] = "har_explosion_a" -- Done
TOOL.ClientConVar["explosionDamage"] = "100" -- Done
TOOL.ClientConVar["explosionRange"] = "5" -- Done
TOOL.ClientConVar["explosionInitialDelay"] = "0" -- Done
TOOL.ClientConVar["explosionDelay"] = "0" -- Done
TOOL.ClientConVar["explosionAmount"] = "1" -- Done
TOOL.ClientConVar["explosionSpread"] = "3" -- Done
TOOL.ClientConVar["playSound"] = "1" -- Done
TOOL.ClientConVar["screenShake"] = "1" -- Done
TOOL.ClientConVar["screenShakeRange"] = "25" -- Done

function Explode(pos,damage,range,etype,playSound,radius,screenShake)
    if CLIENT then return true end
    local explosion = ents.Create("env_explosion")
    explosion:SetPos(pos)
    explosion:SetKeyValue("spawnflags", bit.bor(16,64,32,512,4))
    explosion:SetKeyValue( "iMagnitude", damage )
    explosion:SetKeyValue("iRadiusOverride",range)
    explosion:Spawn( )
    explosion:Fire("explode","",0)
    ParticleEffect(etype, pos, Angle(0,0,0), nil)
    if playSound == "1" then
        sound.Play("vanilla/vanilla_explosion_" .. math.Round(math.Rand(1,6)) .. ".wav",pos,165,math.random(80,120),1)
    end
    if screenShake == "1" then
        util.ScreenShake(pos,5,3,2,tonumber(radius))
    end
end

function TOOL:LeftClick( trace )
    if (!trace.HitPos) then return false end
    if CLIENT then return true end

    local pos = trace.HitPos
    local damage = self:GetClientInfo("explosionDamage")
    local range = self:GetClientInfo("explosionRange")
    local etype = self:GetClientInfo("explosionType")
    local amount = self:GetClientInfo("explosionAmount")
    local idelay = self:GetClientInfo("explosionInitialDelay")
    local delay = self:GetClientInfo("explosionDelay")
    local spread = self:GetClientInfo("explosionSpread") .. "00"
    local playSound = self:GetClientInfo("playSound")
    local radius = self:GetClientInfo("screenShakeRange")
    local screenShake = self:GetClientInfo("screenShake")


    timer.Simple(idelay,function()
        Explode(pos,damage,range,etype,playSound,radius,screenShake)
        if tonumber(amount) > 1 then
            timer.Create("vanillaZiggs" .. SysTime(),delay,tonumber(amount) - 1,function()
                Explode(pos + Vector(math.Rand(-spread,spread),math.Rand(-spread,spread),0),damage,range,etype,playSound,radius,screenShake)
            end)
        end
    end)

    return false
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)

    CPanel:SetName("Vanilla's Explosion Tool")

    local header = vgui.Create("DImage", CPanel)
    header:SetSize(267, 134)
    header:SetImage("vanilla_header/explosiontool_header.png")
    CPanel:AddItem(header)

    CPanel:Help("Version 1.0")

    CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "vanilla_explosion_tool", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

    local prefix = "vanilla_explosion_tool_"
    local exTypes = {
        "har_explosion_a",
        "har_explosion_b",
        "har_explosion_c",
        "har_explosion_a_air",
        "har_explosion_b_air",
        "har_explosion_c_air",
        "har_cb_explosion_a",
        "har_cb_explosion_b",
    }

    local eType = CPanel:ComboBox("Explosion Type", prefix .. "explosionType")
    for k, v in pairs(exTypes) do
        eType:AddChoice(v)
    end
    CPanel:ControlHelp("Sets which explosion type to use.")

    CPanel:NumSlider("Explosion Damage", prefix .. "explosionDamage",0,5000,0)
    CPanel:ControlHelp("Sets the amount of damage the explosion(s) will do.")

    CPanel:NumSlider("Explosion Range", prefix .. "explosionRange",1,5000,0)
    CPanel:ControlHelp("Sets the range in which the explosion(s) will deal damage.")

    CPanel:NumSlider("Explosion Initial Delay", prefix .. "explosionInitialDelay",0,60,0)
    CPanel:ControlHelp("Sets the intial delay (in seconds) until the first explosion ignites.")

    CPanel:NumSlider("Explosion Delay", prefix .. "explosionDelay",0,60,0)
    CPanel:ControlHelp("Sets the delay (in seconds) of following explosions after the first explosion. (Ignore if only using one explosion)")

    CPanel:NumSlider("Explosion Amount", prefix .. "explosionAmount",1,10,0)
    CPanel:ControlHelp("Sets the amount of explosions to go off.")

    CPanel:NumSlider("Explosion Spread", prefix .. "explosionSpread",0,10,0)
    CPanel:ControlHelp("Sets the spread in which the multiple explosions will go off. (Ignore if only using one explosion)")

    CPanel:CheckBox("Play Sound?",prefix .. "playSound")
    CPanel:ControlHelp("Toggles if sound should be played when an explosion goes off.")

    CPanel:CheckBox("Shake Screen?",prefix .. "screenShake")
    CPanel:ControlHelp("Toggles if the screen should be shaken when an explosion goes off.")

    CPanel:NumSlider("Screenshake Range", prefix .. "screenShakeRange",0,5000,0)
    CPanel:ControlHelp("Sets the range in which player's screens are shaken.")
end

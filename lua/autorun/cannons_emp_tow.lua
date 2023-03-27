
//Created by P4sca1
//Huge thanks to him!




if !game.GetMap() ~= "ph_emperors_tower" then return end
 
local cannonCount = 11
local cannonCache = {} // caching the cannons instead of finding them every tick safes much performance
 
local function IsValidCannon(cannon)
    local cannon = cannonCache[cannon]
 
    if cannon and IsValid(cannon.x) and IsValid(cannon.y) and IsValid(cannon.track) then
        return true
    end
 
    return false
end
 
hook.Add("Think", "UpdateCannonPos", function()
    for i = 0, cannonCount, 1 do
        // create cache if it does not already exist or update it, if it is not valid anymore
        if !IsValidCannon(i) then
            cannonCache[i] = {}
            cannonCache[i]["x"] = ents.FindByName("cannon_x" .. i)[1]
            cannonCache[i]["y"] = ents.FindByName("cannon_y" .. i)[1]
            cannonCache[i]["track"] = ents.FindByName("cannon_track" .. i)[1]
 
            // if the cannon is still not valid after searching it, then skip it, because it does not exist
            if !IsValidCannon(i) then
                continue
            end
        end
 
        cannonCache[i]["x"]:SetAngles(Angle(cannonCache[i]["x"]:GetAngles().pitch, cannonCache[i]["track"]:GetAngles().yaw, cannonCache[i]["x"]:GetAngles().roll))
        cannonCache[i]["y"]:SetAngles(Angle(cannonCache[i]["track"]:GetAngles().pitch, cannonCache[i]["y"]:GetAngles().yaw, cannonCache[i]["y"]:GetAngles().roll))
    end
end)
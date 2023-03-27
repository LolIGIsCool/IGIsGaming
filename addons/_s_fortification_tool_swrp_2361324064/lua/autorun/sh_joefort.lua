JoeFort = JoeFort or {}
/*

JoeFort:AddEnt("Barrier","Barriers",{
    classname = string,
    model = string,
    health = string,
    buildtime = int,
    neededresources = int,
    CanSpawn = function(ply, wep)

    end,
    OnSpawn = function(ply,ent)

    end,
    OnDamaged = function(ent, spawner, attacker)

    end,
    OnDestroyed = function(ent, spawner, attacker)

    end,
    OnRepaired = function(spawner, repairer, ent)

    end,
    OnRemoved = function(spawner, remover, ent)

    end,
    OnBuildEntitySpawned = function(spawner, ent)

    end,
})

*/

JoeFort.structs = {}
function JoeFort:AddEnt(name,category,data)
    if not name or not category or not data then return end
    if not data.classname or not data.model then return end
    JoeFort.structs[category] = JoeFort.structs[category] or {}

    data.name = name
    data.health = data.health or 100
    data.buildtime = data.buildtime or 10
    data.neededresources = data.neededresources or 25

    table.insert(JoeFort.structs[category], data)
end

function JoeFort:GetRessourcePool()
    return JoeFort.Ressources or 0
end

if file.Exists("sh_fort_config.lua", "LUA") then
    if SERVER then
        include("sh_fort_config.lua")
        AddCSLuaFile("sh_fort_config.lua")
    elseif CLIENT then
        include("sh_fort_config.lua")
    end
end

JoeFort.Ressources = JoeFort.Ressources or 500
if JoeFort.configoverride then return end

JoeFort:AddEnt("Reinforced Barrier","Sandbags",{
    classname = "",
    model = "models/props_fortifications/sandbags_line2b.mdl",
    health = 400,
    buildtime = 5,
    neededresources = 25,
})

JoeFort:AddEnt("Straight Barrier [Small]","Sandbags",{
    classname = "",
    model = "models/props_fortifications/sandbags_line1.mdl",
    health = 300,
    buildtime = 5,
    neededresources = 20,
})

JoeFort:AddEnt("Straight Barrier [Medium|Tall]","Sandbags",{
    classname = "",
    model = "models/props_fortifications/sandbags_line1_tall.mdl",
    health = 500,
    buildtime = 5,
    neededresources = 40,
})

JoeFort:AddEnt("Straight Barrier [Large|Tall]","Sandbags",{
    classname = "",
    model = "models/props_fortifications/sandbags_line2_tall.mdl",
    health = 600,
    buildtime = 5,
    neededresources = 50,
})

JoeFort:AddEnt("Curved Barrier [Small]","Sandbags",{
    classname = "",
    model = "models/props_fortifications/sandbags_corner1.mdl",
    health = 300,
    buildtime = 5,
    neededresources = 20,
})

JoeFort:AddEnt("Curved Barrier [Medium]","Sandbags",{
    classname = "",
    model = "models/props_fortifications/sandbags_corner2.mdl",
    health = 300,
    buildtime = 5,
    neededresources = 30,
})

JoeFort:AddEnt("Curved Barrier [Large|Tall]","Sandbags",{
    classname = "",
    model = "models/props_fortifications/sandbags_corner2_tall.mdl",
    health = 400,
    buildtime = 5,
    neededresources = 40,
})

JoeFort:AddEnt("Concrete Barrier A","Concrete",{
    classname = "",
    model = "models/props_c17/concrete_barrier001a.mdl",
    health = 250,
    buildtime = 5,
    neededresources = 15,
})

JoeFort:AddEnt("Concrete Barrier B","Concrete",{
    classname = "",
    model = "models/props_phx/construct/concrete_barrier01.mdl",
    health = 350,
    buildtime = 5,
    neededresources = 15,
})

JoeFort:AddEnt("Concrete Barrier C","Concrete",{
    classname = "",
    model = "models/valk/h3/unsc/props/jerseybarrier/jerseybarrier.mdl",
    health = 550,
    buildtime = 8,
    neededresources = 30,
})

JoeFort:AddEnt("Concrete Block","Concrete",{
    classname = "",
    model = "models/iraq/ir_hesco_basket_01.mdl",
    health = 600,
    buildtime = 7,
    neededresources = 40,
})

JoeFort:AddEnt("Concrete Block Barrier","Concrete",{
    classname = "",
    model = "models/props_fortifications/concrete_block001_128_reference.mdl",
    health = 700,
    buildtime = 6,
    neededresources = 30,
})

JoeFort:AddEnt("Concrete Barrier Wall [Small]","Concrete",{
    classname = "",
    model = "models/props_fortifications/concrete_barrier01.mdl",
    health = 600,
    buildtime = 8,
    neededresources = 50,
})

JoeFort:AddEnt("Concrete Barrier Wall [Large]","Concrete",{
    classname = "",
    model = "models/props_fortifications/concrete_wall001_96_reference.mdl",
    health = 750,
    buildtime = 10,
    neededresources = 60,
})

JoeFort:AddEnt("Small Barrier","Barriers",{
    classname = "",
    model = "models/lordtrilobite/starwars/props/imp_landingpad_wall.mdl",
    health = 300,
    buildtime = 7,
    neededresources = 30,
})

JoeFort:AddEnt("Larger Barrier","Barriers",{
    classname = "",
    model = "models/valk/h4/unsc/props/barrier/barrier.mdl",
    health = 500,
    buildtime = 8,
    neededresources = 50,
})

JoeFort:AddEnt("Single Reinforced Barrier Wall","Barriers",{
    classname = "",
    model = "models/valk/h3/unsc/props/wallrust/wall_rust.mdl",
    health = 4000,
    buildtime = 8,
    neededresources = 250,
})

JoeFort:AddEnt("Double Reinforced Barrier Wall","Barriers",{
    classname = "",
    model = "models/valk/h3/unsc/props/wallrust/wall_rust_double.mdl",
    health = 4500,
    buildtime = 10,
    neededresources = 350,
})

JoeFort:AddEnt("Corner Reinforced Barrier Wall","Barriers",{
    classname = "",
    model = "models/valk/h3/unsc/props/wallrust/wall_rust_corner.mdl",
    health = 4000,
    buildtime = 8,
    neededresources = 350,
})

JoeFort:AddEnt("Small Fence Wall","Fence",{
    classname = "",
    model = "models/props_c17/fence01b.mdl",
    health = 200,
    buildtime = 5,
    neededresources = 15,
})

JoeFort:AddEnt("Medium Fence Wall","Fence",{
    classname = "",
    model = "models/props_c17/fence01a.mdl",
    health = 250,
    buildtime = 5,
    neededresources = 30,
})

JoeFort:AddEnt("Long Fence Wall","Fence",{
    classname = "",
    model = "models/props_c17/fence03a.mdl",
    health = 300,
    buildtime = 5,
    neededresources = 40,
})

JoeFort:AddEnt("Fence Wall Door Frame","Fence",{
    classname = "",
    model = "models/props_wasteland/interior_fence002e.mdl",
    health = 100,
    buildtime = 5,
    neededresources = 10,
})

JoeFort:AddEnt("Small Fence Wall [Anti-Climb]","Fence",{
    classname = "",
    model = "models/props_wasteland/exterior_fence002b.mdl",
    health = 150,
    buildtime = 5,
    neededresources = 20,
})

JoeFort:AddEnt("Medium Fence Wall [Anti-Climb]","Fence",{
    classname = "",
    model = "models/props_wasteland/exterior_fence002c.mdl",
    health = 200,
    buildtime = 5,
    neededresources = 40,
})

JoeFort:AddEnt("Long Fence Wall [Anti-Climb]","Fence",{
    classname = "",
    model = "models/props_wasteland/exterior_fence002d.mdl",
    health = 250,
    buildtime = 5,
    neededresources = 50,
})

JoeFort:AddEnt("Security Fence Wall Small","Fence",{
    classname = "",
    model = "models/props_c17/fence02b.mdl",
    health = 200,
    buildtime = 7,
    neededresources = 15,
})

JoeFort:AddEnt("Security Fence Wall Large","Fence",{
    classname = "",
    model = "models/props_c17/fence02a.mdl",
    health = 300,
    buildtime = 7,
    neededresources = 30,
})

JoeFort:AddEnt("Portable Turret [CL3+ with permission]","Emplacement",{
    classname = "lfs_vanilla_portableturret",
    model = "models/swbf3/turrets/rep_portableturret.mdl",
    health = 750,
    buildtime = 10,
    neededresources = 250,
})

JoeFort:AddEnt("Reinforced Tower [Building]","Emplacement",{
    classname = "",
    model = "models/valk/h4/unsc/forge/building_tower.mdl",
    health = 30000,
    buildtime = 25,
    neededresources = 1000,
})

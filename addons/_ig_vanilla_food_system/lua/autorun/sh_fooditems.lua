vanillaIGFoodItems = {}

function CreateFood(name, foodtbl)
    foodtbl.Name = name
    foodtbl.Price = foodtbl.Price or 0
    foodtbl.Stock = foodtbl.Stock or 0
    foodtbl.Model = foodtbl.Model or "models/food/steak.mdl"
    foodtbl.Buffs = foodtbl.Buffs or "No buffs"


    local IDcount = table.Count(vanillaIGFoodItems) + 1
    foodtbl.ID = IDCount
    vanillaIGFoodItems[IDcount] = foodtbl
end

CreateFood("Steak", {
    Price = 2000,
    Stock = 8,
    Buffs = "Melee Damage (+50%)"
})
CreateFood("Soup", {
    Price = 2000,
    Stock = 8,
    Buffs = "Maximum HP (+15%)"
})
CreateFood("Shuura", {
    Price = 2000,
    Stock = 8,
    Buffs = "Weapon Fire Rate (+20%)"
})
CreateFood("Roast Porg", {
    Price = 2000,
    Stock = 8,
    Buffs = "Damage Received (-10%)"
})
CreateFood("Ration Bar", {
    Price = 2000,
    Stock = 8,
    Buffs = "Crouch Movement Speed (+50%)"
})
CreateFood("Mon Calamari Pizza", {
    Price = 2000,
    Stock = 8,
    Buffs = "Health Regeneration (5% per minute)"
})
CreateFood("Food Basket", {
    Price = 2000,
    Stock = 8,
    Buffs = "Weapon Damage (+10%)"
})
CreateFood("Bantha Burger", {
    Price = 2000,
    Stock = 8,
    Buffs = "Weapon Accuracy (+25%)"
})
CreateFood("Blue Milk", {
    Price = 2000,
    Stock = 8,
    Buffs = "Movement Speed (+15%)"
})
CreateFood("Macaroon", {
    Price = 6000,
    Stock = 3,
    Buffs = "Weapon Damage (+15%) \nDamage Received (-15%) \nMaximum HP (+15%) \nMovement Speed (+15%)"
})

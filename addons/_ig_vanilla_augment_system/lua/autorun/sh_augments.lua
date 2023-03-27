vanillaIGAugmentTree = {}

function CreateSkill(name, skilltbl)
    skilltbl.Name = name
    skilltbl.Tree = skilltbl.Tree or "Survival"
    skilltbl.Cost = skilltbl.Cost or "999999"
    skilltbl.Req = skilltbl.Req or ""
    skilltbl.Info = skilltbl.Info or "no information"
    skilltbl.Icon = skilltbl.Icon or "vanilla/skillicon/healintake1.png"


    local IDcount = table.Count(vanillaIGAugmentTree) + 1
    vanillaIGAugmentTree[IDcount] = skilltbl
end

// Survival
CreateSkill("Health Booster I", {
    Tree = "Survival",
    Cost = "4",
    Info = "Using the power of bacta, increase your maximum health by 5%.",
    Icon = "vanilla/skillicon/healthbooster1.png"
})
CreateSkill("Health Booster II", {
    Tree = "Survival",
    Cost = "6",
    Req = "Health Booster I",
    Info = "Using further researched bacta, increase your maximum health by another 5%.",
    Icon = "vanilla/skillicon/healthbooster2.png"
})
CreateSkill("Health Booster III", {
    Tree = "Survival",
    Cost = "8",
    Req = "Health Booster II",
    Info = "Using the most high-quality bacta, increase your maximum health by another 10%.",
    Icon = "vanilla/skillicon/healthbooster3.png"
})
CreateSkill("Passive Recovery", {
    Tree = "Survival",
    Cost = "8",
    Req = "Health Booster II",
    Info = "Get bacta pumping through you and slowly recover health overtime.",
    Icon = "vanilla/skillicon/passiverecoverment.png"
})
CreateSkill("Heal Intake I", {
    Tree = "Survival",
    Cost = "6",
    Req = "Health Booster I",
    Info = "Enhance your bodies bacta intake and increase all healing by 10%.",
    Icon = "vanilla/skillicon/healintake1.png"
})
CreateSkill("Heal Intake II", {
    Tree = "Survival",
    Cost = "8",
    Req = "Heal Intake I",
    Info = "Maximise your bodies bacta intake and increase all healing by another 10%.",
    Icon = "vanilla/skillicon/healintake2.png"
})
CreateSkill("Swift Recovery", {
    Tree = "Survival",
    Cost = "8",
    Req = "Heal Intake I",
    Info = "Increase the efficiency of bacta in your system and gain 50-100 extra healing over 5 seconds after being healed.",
    Icon = "vanilla/skillicon/swiftrecovery.png"
})
CreateSkill("Durasteel Skeleton", {
    Tree = "Survival",
    Cost = "6",
    Req = "Health Booster I",
    Info = "Embrace the power of steel by no longer breaking your legs falling from any height.",
    Icon = "vanilla/skillicon/steellegs.png"
})
CreateSkill("Event Horizon", {
    Tree = "Survival",
    Cost = "15",
    Req = "All Survival Augments",
    Info = [[[MYTHIC]
If you were to die from damage, become invincible for 1.2 seconds.

"Not even the power of a black hole can rip you apart."]],
    Icon = "vanilla/skillicon/eventhorizon.png"
})

//Offense
CreateSkill("Critical Strike I", {
    Tree = "Offense",
    Cost = "4",
    Info = "Enhance your weapon and give it a 5% chance to deal a critical hit (2x damage).",
    Icon = "vanilla/skillicon/criticalstrike1.png"
})
CreateSkill("Critical Strike II", {
    Tree = "Offense",
    Cost = "6",
    Req = "Critical Strike I",
    Info = "Continue to enhance your weapon and give it another 5% chance to deal a critical hit (2x damage).",
    Icon = "vanilla/skillicon/criticalstrike1.png"
})
CreateSkill("Dead Eye I", {
    Tree = "Offense",
    Cost = "4",
    Info = "Learn to control your weapon's recoil and increase accuracy by 5%.",
    Icon = "vanilla/skillicon/deadeye1.png"
})
CreateSkill("Dead Eye II", {
    Tree = "Offense",
    Cost = "6",
    Req = "Dead Eye I",
    Info = "Master your weapon's recoil and increasy accuracy by another 5%.",
    Icon = "vanilla/skillicon/deadeye2.png"
})
CreateSkill("Critical Limit", {
    Tree = "Offense",
    Cost = "8",
    Req = "Critical Strike II + Dead Eye II",
    Info = "Modify your weaponry and allow for critical hits to deal 2.5x damage.",
    Icon = "vanilla/skillicon/criticallimit.png"
})
CreateSkill("Bloodlust", {
    Tree = "Offense",
    Cost = "8",
    Req = "Critical Limit",
    Info = "Feel the thrill of battle and heal for 5% of damage done.",
    Icon = "vanilla/skillicon/bloodlust.png"
})
CreateSkill("Inspiring Aura", {
    Tree = "Offense",
    Cost = "8",
    Req = "Critical Limit",
    Info = "Empower your allies by decreasing their damage taken by 10% in a small area around you when you're using a gun.",
    Icon = "vanilla/skillicon/inspiringaura.png"
})
CreateSkill("Zenith Potential", {
    Tree = "Offense",
    Cost = "8",
    Req = "Critical Limit",
    Info = "Become hyper efficient by dealing 10% more damage if your weapon has 10% of it's ammo left.",
    Icon = "vanilla/skillicon/zenithpotential.png"
})
CreateSkill("Last Stand", {
    Tree = "Offense",
    Cost = "15",
    Req = "All Offense Augments",
    Info = [[[MYTHIC]
After being reduced to 30 or lower health, deal 2x more damage for 3 seconds.

"Backed into the corner, he swore that he would kill them all... The weapon heard."]],
    Icon = "vanilla/skillicon/laststand.png"
})

//Profit Tree
CreateSkill("Lady Luck I", {
    Tree = "Profit",
    Cost = "4",
    Info = "Increase your profits and gain 0% - 5% increase on lottery payout.",
    Icon = "vanilla/skillicon/ladyluck1.png"
})
CreateSkill("Lady Luck II", {
    Tree = "Profit",
    Cost = "6",
    Req = "Lady Luck I",
    Info = "Continue to increase your profits and gain 2% - 10% increase on lottery payout.",
    Icon = "vanilla/skillicon/ladyluck2.png"
})
CreateSkill("Lady Luck III", {
    Tree = "Profit",
    Cost = "8",
    Req = "Lady Luck II",
    Info = "Maximise your profits and gain 4% - 15% increase on lottery payout.",
    Icon = "vanilla/skillicon/ladyluck3.png"
})
CreateSkill("Routine Reward", {
    Tree = "Profit",
    Cost = "6",
    Req = "Experience Accumulator I",
    Info = "When you do your best, you should get the best. Gain 10% extra reards when you receive an event placing.",
    Icon = "vanilla/skillicon/routinereward.png"
})
CreateSkill("Experience Accumulator I", {
    Tree = "Profit",
    Cost = "4",
    Info = "Start noticing the little things and gain 5% extra passive xp increase.",
    Icon = "vanilla/skillicon/experienceaccumulator1.png"
})
CreateSkill("Experience Accumulator II", {
    Tree = "Profit",
    Cost = "8",
    Req = "Routine Reward",
    Info = "Start appreciating the little things and gain another 5% extra passive xp increase.",
    Icon = "vanilla/skillicon/experienceaccumulator2.png"
})
CreateSkill("Debt Collector", {
    Tree = "Profit",
    Cost = "15",
    Req = "All Profit Augments",
    Info = [[[MYTHIC]
Gain 5-25 credits per NPC/Event Character kill.

"Special orders from high command: Get us our money."]],
    Icon = "vanilla/skillicon/debtcollector.png"
})

//Utility Tree
CreateSkill("Ammunition Hoarder I", {
    Tree = "Utility",
    Cost = "4",
    Info = "Save some extra ammo for yourself and gain 10% more ammo on spawn.",
    Icon = "vanilla/skillicon/ammunitionhoarder1.png"
})
CreateSkill("Ammunition Hoarder II", {
    Tree = "Utility",
    Cost = "6",
    Req = "Ammunition Hoarder I",
    Info = "Save a little more ammo for yourself and gain another 10% more ammo on spawn.",
    Icon = "vanilla/skillicon/ammunitionhoarder2.png"
})
CreateSkill("Faster Than Light I", {
    Tree = "Utility",
    Cost = "4",
    Info = "Train your feet and gain 2.5% sprint spreed increase.",
    Icon = "vanilla/skillicon/fasterthanlight1.png"
})
CreateSkill("Faster Than Light II", {
    Tree = "Utility",
    Cost = "6",
    Req = "Faster Than Light I",
    Info = "Train your feet some more and gain another 2.5% sprint spreed increase.",
    Icon = "vanilla/skillicon/fasterthanlight2.png"
})
CreateSkill("Faster Than Light III", {
    Tree = "Utility",
    Cost = "8",
    Req = "Faster Than Light II",
    Info = "Master your feet and gain a final 5% sprint spreed increase.",
    Icon = "vanilla/skillicon/fasterthanlight3.png"
})
CreateSkill("The Mountaineer", {
    Tree = "Utility",
    Cost = "8",
    Req = "Ammunition Hoarder II",
    Info = "Become the mountaineer and gain an extra jump on Climb SWEP.",
    Icon = "vanilla/skillicon/themountaineer.png"
})
CreateSkill("Starship Overdrive", {
    Tree = "Utility",
    Cost = "8",
    Req = "The Mountaineer",
    Info = "Learn the secrets of aviation from Air Commodore Vanilla and make vehicles you're piloting have 5% more health and gain 10% more ammo.",
    Icon = "vanilla/skillicon/starshipoverdrive.png"
})
CreateSkill("Ace up the Sleeve [PRIMARY]", {
    Tree = "Profit",
    Cost = "15",
    Req = "All Utility Augments",
    Info = [[[MYTHIC]
Gain an extra primary slot in your loadout.

"They'll never see it coming." ]],
    Icon = "vanilla/skillicon/aceupthesleevepri.png"
})
CreateSkill("Ace up the Sleeve [SPECIALIST]", {
    Tree = "Profit",
    Cost = "15",
    Req = "All Utility Augments",
    Info = [[[MYTHIC]
Gain an extra specialist slot in your loadout.

"Jack of all trades, master of... many?" ]],
    Icon = "vanilla/skillicon/aceupthesleevespec.png"
})

//Mobility Tree
CreateSkill("Skilled Crawler I", {
    Tree = "Mobility",
    Cost = "6",
    Info = "Revist the basics and gain a 2.5% speed increase when crouched.",
    Icon = "vanilla/skillicon/skilledcrawler1.png"
})
CreateSkill("Skilled Crawler II", {
    Tree = "Mobility",
    Cost = "8",
    Req = "Skilled Crawler I",
    Info = "Advance your knowledge in the basics and gain another 2.5% speed increase when crouched.",
    Icon = "vanilla/skillicon/skilledcrawler2.png"
})
CreateSkill("Skilled Crawler III", {
    Tree = "Mobility",
    Cost = "10",
    Req = "Evasive Stance II",
    Info = "Master the basics and gain a final 2.5% speed increase when crouched.",
    Icon = "vanilla/skillicon/skilledcrawler3.png"
})
CreateSkill("Tauntaun Legs I", {
    Tree = "Mobility",
    Cost = "6",
    Info = "Study the tauntaun, and gain a 5% power increase towards climb SWEP jumps.",
    Icon = "vanilla/skillicon/tauntaunlegs1.png"
})
CreateSkill("Tauntaun Legs II", {
    Tree = "Mobility",
    Req = "Tauntaun Legs I",
    Cost = "10",
    Info = "Study the tauntaun once more, and gain another 5% power increase towards climb SWEP jumps.",
    Icon = "vanilla/skillicon/tauntaunlegs2.png"
})
CreateSkill("Evasive Stance I", {
    Tree = "Mobility",
    Cost = "8",
    Req = "Skilled Crawler II",
    Info = "Learn how to manipulate your body to take half damage 2.5% of the time.",
    Icon = "vanilla/skillicon/evasivestance1.png"
})
CreateSkill("Evasive Stance II", {
    Tree = "Mobility",
    Cost = "10",
    Req = "Evasive Stance I",
    Info = "Master the manipulation of your body to take half damage another 2.5% of the time.",
    Icon = "vanilla/skillicon/evasivestance2.png"
})
CreateSkill("Unstoppable Advance", {
    Tree = "Mobility",
    Cost = "25",
    Req = "All Mobility Augments",
    Info = [[[MYTHIC]
Be able to sprint and shoot for 4 seconds, with a 40 second cooldown.

"With 30 seconds left, she had only one way to make it through." ]],
    Icon = "vanilla/skillicon/relentlessadvance.png"
})

//Specialty Tree
CreateSkill("Steadfast Presence I", {
    Tree = "Specialty",
    Cost = "6",
    Info = "Stand your ground, and make bullets knock back less by 2.5%",
    Icon = "vanilla/skillicon/steadfastpresence1.png"
})
CreateSkill("Steadfast Presence II", {
    Tree = "Specialty",
    Cost = "8",
    Req = "Steadfast Presence I",
    Info = "Stand your ground (harder), and make bullets knock back less by another 2.5%",
    Icon = "vanilla/skillicon/steadfastpresence2.png"
})
CreateSkill("Efficient Discharge", {
    Tree = "Specialty",
    Cost = "8",
    Info = "Manage your ammunition, and gain a 5% chance not to lose ammo when shooting.",
    Icon = "vanilla/skillicon/efficientdischarge.png"
})
CreateSkill("Slow Metabolism", {
    Tree = "Specialty",
    Cost = "8",
    Info = "Digest your food slowly, and make food buffs last for 3 more minutes.",
    Icon = "vanilla/skillicon/slowmetabolism.png"
})
CreateSkill("Stimulant Addict", {
    Tree = "Specialty",
    Cost = "10",
    Info = "Surrender your body to the bacta, and gain 5% more overheal when being stimmed.",
    Icon = "vanilla/skillicon/stimulantaddict.png"
})
CreateSkill("Personal Resentment", {
    Tree = "Specialty",
    Cost = "10",
    Info = "Gain a little grudge, and deal 5% more damage to someone if they have shot you in the last 3 seconds.",
    Icon = "vanilla/skillicon/personalresentment.png"
})
CreateSkill("Wookie Arms", {
    Tree = "Specialty",
    Cost = "15",
    Info = "Imitate the wookie, and make someone take 30% more damage from all sources for 2 seconds if you hit them with a melee weapon.",
    Icon = "vanilla/skillicon/wookiearms.png"
})
CreateSkill("Logistics Prime", {
    Tree = "Specialty",
    Cost = "25",
    Req = "All Specialty Augments",
    Info = [[[MYTHIC]
Randomly spawn with a high tier weapon.

"Let's see... Lifetime subscription!? My my, i'll get your weapon right away!" ]],
    Icon = "vanilla/skillicon/logisticsprime.png"
})

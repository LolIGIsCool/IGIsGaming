CITYWORKER = CITYWORKER or {}

CITYWORKER.Config = CITYWORKER.Config or {}

--[[
  /$$$$$$  /$$   /$$                     /$$      /$$                     /$$                          
 /$$__  $$|__/  | $$                    | $$  /$ | $$                    | $$                          
| $$  \__/ /$$ /$$$$$$   /$$   /$$      | $$ /$$$| $$  /$$$$$$   /$$$$$$ | $$   /$$  /$$$$$$   /$$$$$$ 
| $$      | $$|_  $$_/  | $$  | $$      | $$/$$ $$ $$ /$$__  $$ /$$__  $$| $$  /$$/ /$$__  $$ /$$__  $$
| $$      | $$  | $$    | $$  | $$      | $$$$_  $$$$| $$  \ $$| $$  \__/| $$$$$$/ | $$$$$$$$| $$  \__/
| $$    $$| $$  | $$ /$$| $$  | $$      | $$$/ \  $$$| $$  | $$| $$      | $$_  $$ | $$_____/| $$      
|  $$$$$$/| $$  |  $$$$/|  $$$$$$$      | $$/   \  $$|  $$$$$$/| $$      | $$ \  $$|  $$$$$$$| $$      
 \______/ |__/   \___/   \____  $$      |__/     \__/ \______/ |__/      |__/  \__/ \_______/|__/      
                         /$$  | $$                                                                     
                        |  $$$$$$/                                                                     
                         \______/                                                                      
                                
                                                v1.0.1
                                    By: Silhouhat (76561198072551027)
                                      Licensed to: 76561198006360138

--]]

-- How often should we check (in seconds) for City Workers with no assigned jobs, so we can give them?
CITYWORKER.Config.Time = 360

------------
-- RUBBLE --
------------

CITYWORKER.Config.Rubble = {}

-- Whether or not rubble is enabled or disabled.
CITYWORKER.Config.Rubble.Enabled = true

-- Rubble models and the range of time (in seconds) it takes to clear them.
CITYWORKER.Config.Rubble.Models = {
    ["models/props_debris/concrete_debris128pile001a.mdl"] = { min = 20, max = 30 },
    ["models/props_debris/concrete_debris128pile001b.mdl"] = { min = 10, max = 15 },
    ["models/props_debris/concrete_floorpile01a.mdl"] = { min = 10, max = 20 },
    ["models/props_debris/concrete_cornerpile01a.mdl"] = { min = 10, max = 20 },
    ["models/props_debris/concrete_spawnplug001a.mdl"] = { min = 5, max = 10 },
    ["models/props_debris/plaster_ceilingpile001a.mdl"] = { min = 10, max = 15 },
}

-- Payout per second it takes to clear a given pile of rubble.
-- (i.e. 10 seconds = 10 * 30 = 300)
CITYWORKER.Config.Rubble.Payout = 10

-----------
-- LEAKS --
-----------

CITYWORKER.Config.Leak = CITYWORKER.Config.Leak or {}

-- Whether or not leaks are enabled or disabled.
CITYWORKER.Config.Leak.Enabled = true

-- The range for how long it takes to fix a leak.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Leak.Time = { min = 10, max = 30 }

-- Payout per second it takes to fix a leak.
CITYWORKER.Config.Leak.Payout = 10

--------------
-- ELECTRIC --
--------------

CITYWORKER.Config.Electric = CITYWORKER.Config.Electric or {}

-- Whether or not electrical problems are enabled or disabled.
CITYWORKER.Config.Electric.Enabled = true

-- The range for how long it takes to fix an electrical problem.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Electric.Time = { min = 15, max = 25 }

-- Payout per second it takes to fix an electrical problem.
CITYWORKER.Config.Electric.Payout = 10

----------------------------
-- LANGUAGE CONFIGURATION --
----------------------------

CITYWORKER.Config.Language = {
    ["Leak"]                = "Fixing leak..",
    ["Electric"]            = "Fixing electrical problem...",
    ["Rubble"]              = "Clearing rubble...",

    ["CANCEL"]              = "Press F2 to cancel the action.",
    ["PAYOUT"]              = "You've earned %s credits from your work!",
    ["CANCELLED"]           = "You've cancelled your action!",
    ["NEW_JOB"]             = "You have a new job to do!",
    ["NOT_CITY_WORKER"]     = "You are not a city worker!",
    ["JOB_WORKED"]          = "This job is already being worked!",
    ["ASSIGNED_ELSE"]       = "This job has been assigned to someone else!",
}
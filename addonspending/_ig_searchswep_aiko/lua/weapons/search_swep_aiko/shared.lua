AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 2
    SWEP.SlotPos = 1
end

SWEP.PrintName = "Search Player"
SWEP.Author = "Aiko"
SWEP.Instructions = "Left or right click to search player"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.UseHands = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Spawnable = true
SWEP.Category = "Aiko's Sweps"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsSearching")
    self:NetworkVar("Float", 0, "PlayerSearchStartTime")
    self:NetworkVar("Entity", 0, "PlayerSearchEnt")
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
    
    self:SetNextPrimaryFire(CurTime() + 0.5)
    if self:GetIsSearching() then return end

    local Owner = self:GetOwner()

    if not IsValid(Owner) then return end

    Owner:LagCompensation(true)
    local trace = Owner:GetEyeTrace()
    Owner:LagCompensation(false)
    local ent = trace.Entity

    if not IsValid(ent) or trace.HitPos:DistToSqr(Owner:GetShootPos()) > 10000 or not ent:IsPlayer() then return end

    self:SetHoldType("pistol")

    self:SetIsSearching(true)
    self:SetPlayerSearchEnt(ent)
    self:SetPlayerSearchStartTime(CurTime())
    if CLIENT then
    net.Start("BMDeployedWeapons")
    net.WriteString(ent:SteamID())
    net.SendToServer()
    end
    timer.Create("Weapon Search (" .. Owner:SteamID64() .. ")", 3, 1, function()
        self:SetIsSearching(false)
        self:SetPlayerSearchEnt(nil)
        if CLIENT then
            chat.AddText(Color(110, 110, 110), "[Weapons Found]")
            for _, wep in ipairs(ent:GetWeapons()) do
                if deployedWeapons[wep:GetClass()] then
                    chat.AddText(Color(255, 50, 50), wep)
                else
                    chat.AddText(Color(50, 255, 50), wep)
                end
            end
        end
    end)
end

function SWEP:Holster()
    if self:GetIsSearching() and self:GetPlayerSearchEndTime() ~= 0 then
        self:SetIsSearching(false)
        self:SetPlayerSearchEnt(nil)
    end
    return true
end
if SERVER then
    util.AddNetworkString("BMDeployedWeapons")
    net.Receive("BMDeployedWeapons", function(_, sply)
        local ply = net.ReadString()
        ply = player.GetBySteamID( ply )
        net.Start("BMDeployedWeapons")
        net.WriteUInt(table.Count(ply.BlackmarketDeployedWeapons), 8)
        for wep, _ in pairs(ply.BlackmarketDeployedWeapons) do
            net.WriteString(wep)
        end
        net.Send(sply)
    end)
end

if CLIENT then
    deployedWeapons = {}
    net.Receive("BMDeployedWeapons", function(_, _)
        local tbl = {}
        deployedWeapons = {}
        local tblLength = net.ReadUInt(8)
        for _ = 1, tblLength do
            tbl[net.ReadString()] = true
        end
        deployedWeapons = tbl
    end)
end
-- function SWEP:Succeed()
--     print(CurTime())
--     self:SetHoldType("normal")

--     local ply = self:GetPlayerSearchEnt()
--     self:SetIsSearching(false)
--     self:SetPlayerSearchEnt(nil)

--     if not IsValid(ply) and not ply:IsPlayer() then return end

--     if CLIENT then
--         chat.AddText(Color(110, 110, 110), "[Weapons Found]")
--         for a, wep in ipairs(ply:GetWeapons()) do
--             if deployedWeapons[ply:SteamID()][wep:GetClass()] then
--                 chat.AddText(Color(255, 50, 50), wep)
--             else
--                 chat.AddText(Color(50, 255, 50), wep)
--             end
--         end
--     end
-- end

-- function SWEP:Fail()
--     self:SetIsSearching(false)
--     self:SetHoldType("normal")

--     self:SetPlayerSearchEnt(nil)
-- end

function SWEP:Think()
    local ent = self:GetPlayerSearchEnt()
    if not self:GetIsSearching() or ent == nil then return end

    local trace = self:GetOwner():GetEyeTrace()
    if not IsValid(trace.Entity) and trace.Entity ~= ent or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 then
        self:SetIsSearching(false)
        self:SetPlayerSearchEnt(nil)
    end
end

function SWEP:DrawHUD()
    if not self:GetIsSearching() or self:GetPlayerSearchStartTime() == 0 then return end
    local w = ScrW()
    local h = ScrH()
    local x, y, width, height = w / 2 - w / 10, h / 1.05 - 60, w / 5, h / 20
    draw.RoundedBox(0, x, y, width, height, Color(10,10,10))

    local curtime = CurTime() - self:GetPlayerSearchStartTime()
    local status = math.Clamp(curtime / 3, 0, 1)
    local BarWidth = status * (width - 16)
    draw.RoundedBox(0, x + 8, y + 8, BarWidth, height - 16, Color(160, 160, 160))

    draw.SimpleText("Searching " .. self:GetPlayerSearchEnt():Nick() .. "...", "Trebuchet24", w / 2, y + height / 2, Color(255, 255, 255, 255), 1, 1)
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end
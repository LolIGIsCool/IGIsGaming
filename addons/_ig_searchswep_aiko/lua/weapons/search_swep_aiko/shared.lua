AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 2
    SWEP.SlotPos = 1
end

SWEP.PrintName = "Search Player"
SWEP.Author = "Aiko"
SWEP.Instructions = "Left or Right click to search a player"
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
    self:NetworkVar("Bool", 1, "IsStripping")
    self:NetworkVar("Float", 1, "PlayerStripStartTime")
    self:NetworkVar("Entity", 1, "PlayerStripEnt")
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
    
    self:SetNextPrimaryFire(CurTime() + 0.5)
    if self:GetIsSearching() or self:GetIsStripping() then return end

    local Owner = self:GetOwner()

    if not IsValid(Owner) then return end

    Owner:LagCompensation(true)
    local trace = Owner:GetEyeTrace()
    Owner:LagCompensation(false)
    local ent = trace.Entity

    if not IsValid(ent) --[[or trace.HitPos:DistToSqr(Owner:GetShootPos()) > 10000 or not ent:IsPlayer()]] then return end
    ent.beenSearchedBy = ent.beenSearchedBy or {}
    if SERVER then
        ent:ChatPrint("You are being searched by " .. self.Owner:GetRankName() .. " " .. self.Owner:Nick())
    end

    self:SetHoldType("pistol")

    self:SetIsSearching(true)
    self:SetPlayerSearchEnt(ent)
    self:SetPlayerSearchStartTime(CurTime())
    timer.Create("Stop Net Message Spam" .. Owner:SteamID64(), 1, 1, function()
        if CLIENT then
        net.Start("BMDeployedWeapons")
        net.WriteEntity(ent)
        net.SendToServer()
        end
    end)
    timer.Create("Weapon Search (" .. Owner:SteamID64() .. ")", 3, 1, function()
        self:SetHoldType("normal")


        if not self:GetIsSearching() or ent ~= self:GetPlayerSearchEnt() or trace.HitPos:DistToSqr(Owner:GetShootPos()) > 10000 then return end
        self:SetIsSearching(false)
        self:SetPlayerSearchEnt(nil)
        self:SetPlayerSearchStartTime(0)

        ent.beenSearchedBy[Owner] = true
        if CLIENT then
            chat.AddText(Color(110, 110, 110), "[Weapons Found]")
            for _, wep in ipairs(ent:GetWeapons()) do
                if deployedWeapons[wep:GetClass()] then
                    chat.AddText(Color(255, 50, 50), wep)
                else
                    chat.AddText(Color(50, 255, 50), wep)
                end
            end
            chat.AddText(Color(110, 110, 110), "[Keycards Found]")
            for name, _ in pairs(deployedKeycards) do
                chat.AddText(Color(255, 50, 50), name)
            end
        end
    end)
    timer.Create("Remove Weapon Searched 'Effect' (" .. Owner:SteamID64() .. ")", 30, 1, function()
        if ent.beenSearchedBy[Owner] then
            ent.beenSearchedBy[Owner] = nil
        end
    end)
end


function SWEP:SecondaryAttack()
    if self:GetIsSearching() or self:GetIsStripping() then return end

    local Owner = self:GetOwner()

    if not IsValid(Owner) then return end

    Owner:LagCompensation(true)
    local trace = Owner:GetEyeTrace()
    Owner:LagCompensation(false)
    local ent = trace.Entity

    if not IsValid(ent) --[[or trace.HitPos:DistToSqr(Owner:GetShootPos()) > 10000]] or not ent:IsPlayer() then return end
    if SERVER then
        ent:ChatPrint("You are being stripped by " .. self.Owner:GetRankName() .. " " .. self.Owner:Nick())
    end
    ent.beenSearchedBy = ent.beenSearchedBy or {}

    self:SetHoldType("pistol")

    self:SetIsStripping(true)
    self:SetPlayerStripEnt(ent)
    self:SetPlayerStripStartTime(CurTime())
    timer.Create("Weapon Strip (" .. Owner:SteamID64() .. ")", 3, 1, function()
        
        self:SetHoldType("normal")
        self:SetPlayerStripStartTime(0)
        if not self:GetIsStripping() or ent ~= self:GetPlayerStripEnt() or trace.HitPos:DistToSqr(Owner:GetShootPos()) > 10000 then return end
        self:SetIsStripping(false)
        self:SetPlayerStripEnt(nil)

        if not ent.beenSearchedBy[Owner] then
            if CLIENT then
                chat.AddText(Color(255, 42, 42), "Strip Failed... You need to have searched the player before trying to strip them...")
            end
            return
        end
        ent.beenSearchedBy[Owner] = nil
        if SERVER then
            for wep, _ in pairs(ent.BlackmarketDeployedWeapons) do
                ent:StripWeapon(wep)
            end
            ent.BlackmarketDeployedWeapons = {}
        end

        -- Doesn't work, Hideyoshi fix it please
        bKeypads.Keycards.Inventory:Clear(ent)
        hideyoshi_processKeycard(ent)


        if CLIENT then
            chat.AddText(Color(42, 255, 42), "Strip Successful! Removed " .. ent:Nick() .. " blackmarket weapons.")
        end
    end)
end

function SWEP:Holster()
    if self:GetIsSearching() and self:GetPlayerSearchStartTime() + 3 <= CurTime() then
        self:SetIsSearching(false)
        self:SetPlayerSearchEnt(nil)
    end
    if self:GetIsStripping() and self:GetPlayerStripStartTime() + 3 <= CurTime() then
        self:SetIsStripping(false)
        self:SetPlayerStripEnt(nil)
    end
    return true
end
if SERVER then
    util.AddNetworkString("BMDeployedWeapons")
    net.Receive("BMDeployedWeapons", function(_, sply)
        local ply = net.ReadEntity()
        net.Start("BMDeployedWeapons")
        net.WriteUInt(table.Count(ply.BlackmarketDeployedWeapons), 8)
        for wep, _ in pairs(ply.BlackmarketDeployedWeapons) do
            net.WriteString(wep)
        end

        net.WriteUInt(table.Count(ply.BlackmarketDeployedKeycards), 8)
        for keycard_name, _ in pairs(ply.BlackmarketDeployedKeycards) do
            net.WriteString(keycard_name)
        end

        net.Send(sply)
    end)
end

if CLIENT then
    deployedWeapons = {}
    net.Receive("BMDeployedWeapons", function()

        deployedWeapons = {}
        local tblLength = net.ReadUInt(8)
        for _ = 1, tblLength do
            local key = net.ReadString()
            deployedWeapons[key] = true
        end

        deployedKeycards = {}
        local tblLength = net.ReadUInt(8)
        for _ = 1, tblLength do
            local key = net.ReadString()
            deployedKeycards[key] = true
        end
    end)
end

function SWEP:Think()
    local trace = self:GetOwner():GetEyeTrace()
    if self:GetIsSearching() then
        local ent = self:GetPlayerSearchEnt()
        if not IsValid(ent) and trace.Entity ~= ent or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 then
            self:SetHoldType("normal")
            self:SetIsSearching(false)
            self:SetPlayerSearchEnt(nil)
        end
    elseif self:GetIsStripping() then
        local ent = self:GetPlayerStripEnt()
        local trace = self:GetOwner():GetEyeTrace()
        if not IsValid(ent) and trace.Entity ~= ent or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 then
            self:SetHoldType("normal")
            self:SetIsStripping(false)
            self:SetPlayerStripEnt(nil)
        end
    end

end

function SWEP:DrawHUD()
    if self:GetIsSearching() and self:GetPlayerSearchStartTime() ~= 0 then
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

    if self:GetIsStripping() and self:GetPlayerStripStartTime() ~= 0 then
        local w = ScrW()
        local h = ScrH()
        local x, y, width, height = w / 2 - w / 10, h / 1.05 - 60, w / 5, h / 20
        draw.RoundedBox(0, x, y, width, height, Color(10,10,10))

        local curtime = CurTime() - self:GetPlayerStripStartTime()
        local status = math.Clamp(curtime / 3, 0, 1)
        local BarWidth = status * (width - 16)
        draw.RoundedBox(0, x + 8, y + 8, BarWidth, height - 16, Color(160, 160, 160))

        draw.SimpleText("Attempting to strip " .. self:GetPlayerStripEnt():Nick() .. "...", "Trebuchet24", w / 2, y + height / 2, Color(255, 255, 255, 255), 1, 1)
    end
end

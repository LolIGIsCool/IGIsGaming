--                                                  --
--        Hideyoshi's Revamped Music Player         --
--                                                  --
AddCSLuaFile()
include('shared.lua')
include("hds_mp/cl_jsfunction.lua")
include("hds_mp/cl_songprocessor.lua")
include("hds_mp/cl_queue.lua")
include("vgui/cl_derma.lua")

local imgui = include('hds_mp/cl_imgui.lua')
--if !hideMusic then hideMusic = {} end
local hideMusic = {}
hideMusic.mat = {}
hideMusic.func = {}
hideMusic.selectedMenu = "songselection"

hideMusic.mat.imp_emblem = Material("materials/hideyoshi_vgui/imp_emblem.png", "noclamp smooth")
hideMusic.mat.vgui_controls_play = Material("materials/hideyoshi_vgui/vgui_play.png", "noclamp smooth")
hideMusic.mat.vgui_controls_pause = Material("materials/hideyoshi_vgui/vgui_stop.png", "noclamp smooth")
hideMusic.mat.vgui_controls_stop = Material("materials/hideyoshi_vgui/vgui_pause.png", "noclamp smooth")

--[[
    Font(s) & Sound Creation
]]
--
surface.CreateFont("Hideyoshi_PanelDefault", {
    font = "Arial",
    size = 150
})

surface.CreateFont("Hideyoshi_PanelLarge", {
    font = "Arial",
    size = 200
})

surface.CreateFont("Hideyoshi_PanelControl", {
    font = "Arial",
    size = 100
})

surface.CreateFont("Hideyoshi_PanelSmall", {
    font = "Arial",
    size = 85
})

surface.CreateFont("Hideyoshi_DermaDefault", {
    font = "CenterPrintText",
    size = 32.5
})

surface.CreateFont("Hideyoshi_DermaMediumBold", {
    font = "DermaDefaultBold",
    size = 18
})

surface.CreateFont("Hideyoshi_DermaSmallBold", {
    font = "DermaDefaultBold",
    size = 14
})

surface.CreateFont("Hideyoshi_DermaSmall", {
    font = "Arial",
    size = 15
})

surface.CreateFont("Hideyoshi_DermaMedium", {
    font = "Arial",
    size = 16
})
function ENT:Initialize()
    self.selectedMenu = "songselection"
    self.hideMusic = {}
    self.hideMusic.instance = self
    self.hideMusic.mat = {}
    self.hideMusic.func = {}
    self.hideMusic.selectedMenu = "songselection"
    
    self.hideMusic.mat.imp_emblem = Material("materials/hideyoshi_vgui/imp_emblem.png", "noclamp smooth")
    self.hideMusic.mat.vgui_controls_play = Material("materials/hideyoshi_vgui/vgui_play.png", "noclamp smooth")
    self.hideMusic.mat.vgui_controls_pause = Material("materials/hideyoshi_vgui/vgui_stop.png", "noclamp smooth")
    self.hideMusic.mat.vgui_controls_stop = Material("materials/hideyoshi_vgui/vgui_pause.png", "noclamp smooth")

    if (CLIENT) then
        self.Hideyoshi_DProgressBar = vgui.Create("DFrame")
        self.Hideyoshi_DProgressBar:SetSize(2555, 500)
        self.Hideyoshi_DProgressBar:SetTitle(" ")
        self.Hideyoshi_DProgressBar:SetPos(-1000, 1000)
        self.Hideyoshi_DProgressBar:ShowCloseButton(false)
        self.Hideyoshi_DProgressBar:SetPaintedManually(true)
        self.Hideyoshi_DProgressBar.Paint = function(self, w, h) return end
        self.Hideyoshi_DProgress = vgui.Create("DProgress", self.Hideyoshi_DProgressBar)
        self.Hideyoshi_DProgress:SetPos(50, 30)
        self.Hideyoshi_DProgress:SetSize(1850, 150)
        self.Hideyoshi_DProgress:SetFraction(0)
    end
end

function ENT:Draw()

    self:DrawModel()


    if (LocalPlayer():IsAdmin()) then
        if imgui.Entity3D2D(self, Vector(-12, 18, 3.1), Angle(0, 90, 0), 0.01) then

            draw.RoundedBox(0, -3600, 0, 3550, 2400, Color(25, 25, 35, 255))
            draw.SimpleText("Hideyoshi's Star Wars Music Player [V3.01 - Beta]", "Hideyoshi_PanelDefault", -3450, 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("Music Player #"..self:EntIndex() .. " - Spawned by "..  player.GetBySteamID(self:Getent_plyspawner()):Nick() , "Hideyoshi_PanelControl", -3450, 155, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            surface.SetMaterial(self.hideMusic.mat.imp_emblem)
            surface.SetDrawColor(255, 255, 255, 50)
            surface.DrawTexturedRect(-2025, 890, 500, 500)

            if (self.curSongName ~= "" and IsValid(self.sw_station)) then
                draw.SimpleText(self.curSongName, "Hideyoshi_PanelDefault", -1780, 700, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                draw.SimpleText(string.FormattedTime(self.sw_station:GetTime(), "%02i:%02i") .. "/" .. string.FormattedTime(self.sw_station:GetLength(), "%02i:%02i"), "Hideyoshi_PanelDefault", -1780, 1150, Color(255, 255, 255, 155), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

                if self.sw_station:GetState() == 2 then
                    draw.SimpleText("Song Paused", "Hideyoshi_DermaSmall", -1780, 1280, Color(255, 255, 255, 155), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end

                surface.SetMaterial(self.hideMusic.mat.vgui_controls_play)

                if imgui.IsHovering(-2250, 1450, 200, 200) then
                    surface.SetDrawColor(72, 72, 72, 200)
                else
                    surface.SetDrawColor(255, 255, 255, 200)
                end

                surface.DrawTexturedRect(-2250, 1450, 200, 200)

                if imgui.xButton(-2250, 1450, 200, 200, 1, Color(255, 255, 255, 0), Color(0, 0, 255, 0), Color(255, 0, 0, 0)) then
                    chat.AddText("Playing Song...")
                    sendStateChange(self:EntIndex(), "play")
                end

                surface.SetMaterial(self.hideMusic.mat.vgui_controls_pause)

                if imgui.IsHovering(-1870, 1450, 200, 200) then
                    surface.SetDrawColor(72, 72, 72, 200)
                else
                    surface.SetDrawColor(255, 255, 255, 200)
                end

                surface.DrawTexturedRect(-1870, 1450, 200, 200)

                if imgui.xButton(-1870, 1450, 200, 200, 1, Color(255, 255, 255, 0), Color(0, 0, 255, 0), Color(255, 0, 0, 0)) then
                    chat.AddText("Stopping/Deleting Song...")
                    sendStateChange(self:EntIndex(), "stop")
                end

                surface.SetMaterial(self.hideMusic.mat.vgui_controls_stop)

                if imgui.IsHovering(-1500, 1450, 200, 200) then
                    surface.SetDrawColor(72, 72, 72, 200)
                else
                    surface.SetDrawColor(255, 255, 255, 200)
                end

                surface.DrawTexturedRect(-1500, 1450, 200, 200)

                if imgui.xButton(-1500, 1450, 200, 200, 1, Color(255, 255, 255, 0), Color(0, 0, 255, 0), Color(255, 0, 0, 0)) then
                    chat.AddText("Pausing Song...")
                    sendStateChange(self:EntIndex(), "pause")
                end

            end

            if imgui.xTextButton("Music Configuration", "Hideyoshi_PanelControl", -2250, 2250, 1000, 100, 1, Color(255, 255, 255), Color(0, 0, 255), Color(255, 0, 0)) then
                if LocalPlayer():IsAdmin() then
                    drawHideMusic_derma(self)
                    --[[if (hideMusic.selectedMenu == "songselection") then
                        playlistSelect_elementSheet:SetVisible(false)
                    elseif (hideMusic.selectedMenu == "playlistselection") then
                        songSelect_elementSheet:SetVisible(false)
                    end]]--
                end
            end
            

            if imgui.xTextButton("Music Suggestions", "!Roboto@45", -3550, 2250, 500, 100, 1, Color(255, 255, 255), Color(0, 0, 255), Color(255, 0, 0)) then
                gui.OpenURL("https://forms.gle/Jz67pYY3z8WAqtXK7")
            end

            imgui.End3D2D()
        end

        if imgui.Entity3D2D(self, Vector(-13, 0.8, 3.1), Angle(0, 90, 0), 0.01) then

            if (self.curSongName ~= "" and
            IsValid(self.sw_station)) then

                self.Hideyoshi_DProgressBar:PaintManual();
                self.Hideyoshi_DProgress:SetFraction(math.TimeFraction(0, self.sw_station:GetLength(), self.sw_station:GetTime()));

            end

            imgui.End3D2D()

        end
    end

end

function ENT:OnRemove()

    if (IsValid(self.sw_station)) then
        self.sw_station:Stop()
    end

end
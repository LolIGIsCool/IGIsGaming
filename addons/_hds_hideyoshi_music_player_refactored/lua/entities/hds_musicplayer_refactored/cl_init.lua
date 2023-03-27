include('shared.lua')

local imgui = include('hidehelper/cl_hds_imgui.lua')

function ENT:Initialize()

    self:SetRenderMode( RENDERMODE_TRANSCOLOR )
    if (LocalPlayer():IsAdmin()) then
        self:SetColor( Color(255,255,255,255) )
    else
        self:SetColor( Color(255,255,255,0) )
    end

end

local imp_emblem = Material("materials/hideyoshi_vgui/imp_emblem.png", "noclamp smooth")
local vgui_controls_play = Material("materials/hideyoshi_vgui/vgui_play.png", "noclamp smooth")
local vgui_controls_pause = Material("materials/hideyoshi_vgui/vgui_stop.png", "noclamp smooth")
local vgui_controls_stop = Material("materials/hideyoshi_vgui/vgui_pause.png", "noclamp smooth")

function hds_sendStateChange(ent, state)
    if (!LocalPlayer():IsAdmin()) then return end

    net.Start("hds_stateChange")
        net.WriteEntity(ent)
        net.WriteString(state)
    net.SendToServer()
end

function ENT:HDS_ChangeState(state)
    if (IsValid(self.station)) then
        --[[local stateChanges = {
            ["play"] = self.station:Play(),
            ["pause"] = self.station:Pause(),
            ["stop"] = self.station:Stop()
        }
        stateChanges[state]()]]--

        if (state == "play") then
            self.station:Play()
        elseif (state == "pause") then
            self.station:Pause()
        elseif (state == "stop") then
            self.station:Stop()
            hook.Run("hideMusic_playerStopped", self)
        end
        -- i know this is bad, but it works
    end 
end

function ENT:OnRemove()

    if (IsValid(self.station)) then
        self:Sethds_Queue("{}") -- Clear the queue
        self.station:Stop()
    end

end

function ENT:Draw()

    self:DrawModel()

    if (LocalPlayer():IsAdmin()) then
        if imgui.Entity3D2D(self, Vector(-12, 18, 3.1), Angle(0, 90, 0), 0.01) then

            draw.RoundedBox(0, -3600, 0, 3550, 2400, Color(25, 25, 35, 255))
            draw.SimpleText("[HDS] Hideyoshi's Refactored Music Player ", "HideMusic_PanelDefault", -3450, 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("(Test Version) Music Player #"..self:EntIndex() .. " - Spawned by " .. player.GetBySteamID(self:Gethds_ownerSteamID()):Nick()  , "HideMusic_PanelControl", -3450, 155, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            if (IsValid(self.station)) then
                draw.SimpleText(self.HideMusic_settings.name, "HideMusic_PanelDefault", -1780, 700, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                draw.SimpleText(string.FormattedTime(self.station:GetTime(), "%02i:%02i") .. "/" .. string.FormattedTime(self.station:GetLength(), "%02i:%02i"), "HideMusic_PanelDefault", -1780, 1150, Color(255, 255, 255, 155), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

                -- Background of the progress bar
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawRect(-2775, 925, 2000, 150)
                
                -- The progress bar itself
                surface.SetDrawColor(0, 255, 0, 255)
                surface.DrawRect(-2775, 925, (2000/self.station:GetLength())*self.station:GetTime(), 150)

                if self.station:GetState() == 2 then
                    draw.SimpleText("Song Paused", "HideMusic_PanelSmall", -1780, 1280, Color(255, 255, 255, 155), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end

                --[[
                    Play Button
                ]]

                surface.SetMaterial(vgui_controls_play)

                if imgui.IsHovering(-2250, 1450, 200, 200) then
                    surface.SetDrawColor(72, 72, 72, 200)
                else
                    surface.SetDrawColor(255, 255, 255, 200)
                end

                surface.DrawTexturedRect(-2250, 1450, 200, 200)

                if imgui.xButton(-2250, 1450, 200, 200, 1, Color(255, 255, 255, 0), Color(0, 0, 255, 0), Color(255, 0, 0, 0)) then
                    chat.AddText("Playing Song...")
                    hds_sendStateChange(self, "play")
                end

                --[[
                    Pause Button
                ]]

                surface.SetMaterial(vgui_controls_pause)

                if imgui.IsHovering(-1870, 1450, 200, 200) then
                    surface.SetDrawColor(72, 72, 72, 200)
                else
                    surface.SetDrawColor(255, 255, 255, 200)
                end

                surface.DrawTexturedRect(-1870, 1450, 200, 200)

                if imgui.xButton(-1870, 1450, 200, 200, 1, Color(255, 255, 255, 0), Color(0, 0, 255, 0), Color(255, 0, 0, 0)) then
                    chat.AddText("Stopping/Deleting Song...")
                    hds_sendStateChange(self, "stop")
                end

                --[[
                    Stop Button
                ]]

                surface.SetMaterial(vgui_controls_stop)

                if imgui.IsHovering(-1500, 1450, 200, 200) then
                    surface.SetDrawColor(72, 72, 72, 200)
                else
                    surface.SetDrawColor(255, 255, 255, 200)
                end

                surface.DrawTexturedRect(-1500, 1450, 200, 200)

                if imgui.xButton(-1500, 1450, 200, 200, 1, Color(255, 255, 255, 0), Color(0, 0, 255, 0), Color(255, 0, 0, 0)) then
                    chat.AddText("Pausing Song...")
                    hds_sendStateChange(self, "pause")
                end

            end

            if imgui.xTextButton("Music Configuration", "HideMusic_PanelControl", -2250, 2250, 1000, 100, 1, Color(255, 255, 255), Color(0, 0, 255), Color(255, 0, 0)) then
                if LocalPlayer():IsAdmin() then
                    drawpanel(self)
                end
            end
            

            if imgui.xTextButton("Music Suggestions", "!Roboto@45", -3550, 2250, 500, 100, 1, Color(255, 255, 255), Color(0, 0, 255), Color(255, 0, 0)) then
                gui.OpenURL("https://forms.gle/Jz67pYY3z8WAqtXK7")
            end

            imgui.End3D2D()
        end
    end

end


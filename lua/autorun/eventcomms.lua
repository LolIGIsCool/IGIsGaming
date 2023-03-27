if (SERVER) then
    util.AddNetworkString("SendevcChat")
    util.AddNetworkString("Recieveevccomms")
    util.AddNetworkString("defconchatalert")
    local Colour, Name, Text = "", "", ""
    resource.AddFile("materials/vgui/ecicons/Radio.png")
 
    net.Receive("Recieveevccomms", function(len, pl)
        if pl:IsEventMaster() then
            local commstype = net.ReadString()
            local Colour = net.ReadTable()
            local Name = net.ReadString()
            local Text = net.ReadString()
            if not pl:IsSuperAdmin() then
                RunConsoleCommand("ulx","asay",pl:Nick().." event comms: "..Text)
            end
            net.Start("SendevcChat")
            net.WriteString(commstype)
            net.WriteTable(Colour)
            net.WriteString(Name)
            net.WriteString(Text)
            net.Broadcast()
        end
    end)
end
 
if (CLIENT) then
    local ccb, eccb, cccb = 0, 0, 0
    local toggled = 1
 
    function ECDerma()
        EventCommsPanel = vgui.Create("DFrame")
        EventCommsPanel:SetSize(520, 100)
        EventCommsPanel:SetTitle("Event Comms [Toggle me off by clicking the small box on the bottom left to chat normally]")
        EventCommsPanel:SetPos(30, ScrH()*0.4)
        EventCommsPanel:ShowCloseButton(false)
        EventCommsPanel:SetDraggable(false)
        EventCommsPanel:SetMouseInputEnabled(true)
 
        EventCommsPanel.Paint = function(self, w, h)
            if (EventCommsPanel:IsHovered() and not EventCommsPanel:HasHierarchicalFocus()) then
                EventCommsPanel:MakePopup()
            end
 
            draw.RoundedBox(6, 0, 0, w, h, Color(76, 84, 103, 230))
        end
 
        local NameText = vgui.Create("DTextEntry", EventCommsPanel)
        NameText:SetPos(30, EventCommsPanel:GetTall() / 2 - NameText:GetTall() / 2)
        NameText:SetSize(80, 20)
        NameText:SetText("")
        NameText.MaxChars = 20
        NameText:SetEditable(true)
 
        NameText.OnTextChanged = function(self)
            local txt = self:GetValue()
            local amt = string.len(txt)
 
            if amt > self.MaxChars then
                self:SetText(self.OldText)
                self:SetValue(self.OldText)
            else
                self.OldText = txt
            end
        end
 
        local CommsText = vgui.Create("DTextEntry", EventCommsPanel)
        CommsText:SetPos(115, EventCommsPanel:GetTall() / 2 - CommsText:GetTall() / 2)
        CommsText:SetSize(330, 20)
        CommsText:SetText("")
        CommsText.MaxChars = 200
 
        CommsText.OnTextChanged = function(self)
            local txt = self:GetValue()
            local amt = string.len(txt)
 
            if amt > self.MaxChars then
                self:SetText(self.OldText)
                self:SetValue(self.OldText)
            else
                self.OldText = txt
            end
        end
 
        local SendComms = vgui.Create("DButton", EventCommsPanel)
        SendComms:SetText("Send")
        SendComms:SetTextColor(Color(255, 255, 120))
        SendComms:SetPos(100, 100)
        SendComms:SetPos(EventCommsPanel:GetWide() - SendComms:GetWide() - 5, EventCommsPanel:GetTall() / 2 - SendComms:GetTall() / 2)
 
        SendComms.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
        end
 
        local CommsCheckBox = vgui.Create("DCheckBoxLabel", EventCommsPanel)
        CommsCheckBox:SetPos(5, EventCommsPanel:GetTall() - CommsCheckBox:GetTall() - 5)
        CommsCheckBox:SetText("COMMS")
        CommsCheckBox:SetValue(0)
        CommsCheckBox:SizeToContents()
        local ECommsCheckBox = vgui.Create("DCheckBoxLabel", EventCommsPanel)
        ECommsCheckBox:SetPos(75, EventCommsPanel:GetTall() - ECommsCheckBox:GetTall() - 5)
        ECommsCheckBox:SetText("ECOMMS")
        ECommsCheckBox:SetValue(0)
        ECommsCheckBox:SizeToContents()
        local CCommsCheckBox = vgui.Create("DCheckBoxLabel", EventCommsPanel)
        CCommsCheckBox:SetPos(145, EventCommsPanel:GetTall() - CCommsCheckBox:GetTall() - 5)
        CCommsCheckBox:SetText("CIVCOMMS")
        CCommsCheckBox:SetValue(0)
        CCommsCheckBox:SizeToContents()
        local ColorChoice = vgui.Create("DColorButton", EventCommsPanel)
        ColorChoice:SetSize(20, 20)
        ColorChoice:SetPos(5, EventCommsPanel:GetTall() / 2 - ColorChoice:GetTall() / 2)
        local ColorPicker = vgui.Create("DColorPalette", EventCommsPanel)
        ColorPicker:SetSize(160, 40)
        ColorPicker:SetPos(285, EventCommsPanel:GetTall() - ColorPicker:GetTall() + 5)
 
        CommsCheckBox.OnChange = function()
            if CommsCheckBox:GetChecked(true) then
                ECommsCheckBox:SetChecked(false)
                CCommsCheckBox:SetChecked(false)
                ccb = 1
                eccb = 0
                cccb = 0
            end
        end
 
        ECommsCheckBox.OnChange = function()
            if ECommsCheckBox:GetChecked(true) then
                CommsCheckBox:SetChecked(false)
                CCommsCheckBox:SetChecked(false)
                ccb = 0
                eccb = 1
                cccb = 0
            end
        end
 
        CCommsCheckBox.OnChange = function()
            if CCommsCheckBox:GetChecked(true) then
                CommsCheckBox:SetChecked(false)
                ECommsCheckBox:SetChecked(false)
                ccb = 0
                eccb = 0
                cccb = 1
            end
        end
 
        SendComms.DoClick = function()
            if (string.len(NameText:GetValue()) >= 1 or string.len(CommsText:GetValue()) >= 1) then
                local textColor = ColorChoice:GetColor()
                local commstype = ""
 
                if ccb == 1 then
                    commstype = "ccb"
                end
 
                if eccb == 1 then
                    commstype = "eccb"
                end
 
                if cccb == 1 then
                    commstype = "cccb"
                end
 
                net.Start("Recieveevccomms")
                net.WriteString(commstype)
                net.WriteTable(textColor)
                net.WriteString(tostring(NameText:GetValue()))
                net.WriteString(tostring(CommsText:GetValue()))
                net.SendToServer()
                EventCommsPanel:Close()
                chat.Close()
            end
        end
 
        ColorPicker.OnValueChanged = function(s, value)
            ColorChoice:SetColor(value)
        end
        
        close_button = vgui.Create("DButton", EventCommsPanel)
        close_button:SetIcon('icon16/cross.png')
        close_button:SetPos(496, 0)
        close_button:SetText("")
        close_button:SetSize(24, 24)
        close_button.Paint = function(self, w, h) end
        close_button.DoClick = function()
            EventCommsPanel:Close()
        end
 
        hook.Add("FinishChat", "ClientFinishTypingevc", function()
            if (EventCommsPanel:IsVisible()) then
                EventCommsPanel:Close()
            end
        end)
    end
 
    function ToggleDerma()
        ToggleDermaPanel = vgui.Create("DFrame")
        ToggleDermaPanel:SetSize(104, 30)
        ToggleDermaPanel:SetPos(30, ScrH() * 0.5)
        ToggleDermaPanel:ShowCloseButton(false)
 
        ToggleDermaPanel.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(76, 84, 103, 0))
        end
 
        DermaImageButton = vgui.Create("DButton", ToggleDermaPanel)
        DermaImageButton:SetPos(0, 0)
        DermaImageButton:SetText("Event Comms")
        DermaImageButton:SetTextColor( Color(255,255,255))
        DermaImageButton:SetSize(80, 30)
        
        DermaImageButton.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, Color(175, 0, 0, 250))
        end
 
        DermaImageButton.DoClick = function()
            if (toggled == 1) then
                EventCommsPanel:MoveTo(-EventCommsPanel:GetWide(), ScrH() * 0.4, 0.1, 0, 0.5)
 
                EventCommsPanel:NewAnimation(0, 0.1, 0.5, function()
                    EventCommsPanel:Hide()
                end)
 
                toggled = 0
            else
                EventCommsPanel:MoveTo(30, ScrH()* 0.4, 0.1, 0, 0.5)
                EventCommsPanel:Show()
                toggled = 1
            end
        end
        
        close_button = vgui.Create("DButton", ToggleDermaPanel)
        close_button:SetIcon('icon16/cross.png')
        close_button:SetPos(80, 0)
        close_button:SetText("")
        close_button:SetSize(24, 24)
        close_button.Paint = function(self, w, h) end
        close_button.DoClick = function()
            ToggleDermaPanel:Close()
        end
 
        hook.Add("FinishChat", "ChatCloseToggleevc", function()
            if (ToggleDermaPanel:IsVisible()) then
                ToggleDermaPanel:Close()
            end
        end)
    end
 
    hook.Add("StartChat", "Openedchatevc", function()
        if LocalPlayer():IsEventMaster() then
            ToggleDerma()
 
            if (LocalPlayer():IsEventMaster() and toggled == 1) then
                ECDerma()
            end
        end
    end)
 
    net.Receive("SendevcChat", function()
        local commstype = net.ReadString()
        local nameColour = net.ReadTable()
        local Name = net.ReadString()
        local Text = net.ReadString()
 
        if commstype == "ccb" then
            chat.AddText(Color(0, 255, 0), "(COMMS) ", Color(nameColour.r, nameColour.g, nameColour.b), Name, Color(255, 255, 255), ": ", Text)
        end
 
        if commstype == "eccb" then
            chat.AddText(Color(255, 0, 0), "(ENEMY COMMS) ", Color(nameColour.r, nameColour.g, nameColour.b), Name, Color(255, 255, 255), ": ", Text)
        end
 
        if commstype == "cccb" then
            chat.AddText(Color(111, 66, 245), "(CIVCOMMS) ", Color(nameColour.r, nameColour.g, nameColour.b), Name, Color(255, 255, 255), ": ", Text)
        end
    end)
    net.Receive("defconchatalert", function()
        if vanillaignewdefcon == 11 then
            chat.AddText(Color(255, 0, 0), "[", Color(255, 255, 255), "DEFCON", Color(255, 0, 0), "]", Color(255, 255, 255), "The DEFCON has been set to", Color(177, 8, 8), " Protocol 13", Text)
        elseif vanillaignewdefcon == 12 then
            chat.AddText(Color(255, 0, 0), "[", Color(255, 255, 255), "DEFCON", Color(255, 0, 0), "]", Color(255, 255, 255), "The DEFCON has been set to", Color(177, 8, 8), " Evacuation", Text)
        elseif vanillaignewdefcon == 13 then
            chat.AddText(Color(255, 0, 0), "[", Color(255, 255, 255), "DEFCON", Color(255, 0, 0), "]", Color(255, 255, 255), "The DEFCON has been set to", Color(177, 8, 8), " Battle Stations", Text)
        elseif vanillaignewdefcon == 41 then
            chat.AddText(Color(255, 0, 0), "[", Color(255, 255, 255), "DEFCON", Color(255, 0, 0), "]", Color(255, 255, 255), "The DEFCON has been set to", Color(177, 177, 8), " Standby Alert", Text)
        elseif vanillaignewdefcon == 21 then
            chat.AddText(Color(255, 0, 0), "[", Color(255, 255, 255), "DEFCON", Color(255, 0, 0), "]", Color(255, 255, 255), "The DEFCON has been set to", Color(8, 177, 8), " Standard Operations", Text)
        elseif vanillaignewdefcon == 31 then
            chat.AddText(Color(255, 0, 0), "[", Color(255, 255, 255), "DEFCON", Color(255, 0, 0), "]", Color(255, 255, 255), "The DEFCON has been set to", Color(177, 107, 8), " Full Lockdown", Text)
        elseif vanillaignewdefcon == 32 then
            chat.AddText(Color(255, 0, 0), "[", Color(255, 255, 255), "DEFCON", Color(255, 0, 0), "]", Color(255, 255, 255), "The DEFCON has been set to", Color(177, 107, 8), " Intruder Alert", Text)
        elseif vanillaignewdefcon == 42 then
            chat.AddText(Color(255, 0, 0), "[", Color(255, 255, 255), "DEFCON", Color(255, 0, 0), "]", Color(255, 255, 255), "The DEFCON has been set to", Color(177, 177, 8), " Hazard Alarm", Text)
        end
    end)
end
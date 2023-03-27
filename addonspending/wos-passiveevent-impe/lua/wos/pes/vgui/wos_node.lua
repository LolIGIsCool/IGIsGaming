--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

























































































































































local PANEL = {}

function PANEL:Init()
    self.NextClick = 0
    self.MainLink = true
    self._vars = {}

    self.wOSNode = true
    self:NodeClose(true)

    self.DeleteButton = vgui.Create("DButton", self)
    self.DeleteButton:SetSize(15, 15)
    self.DeleteButton:SetPos(225, 10)
    self.DeleteButton:SetText("")
    self.DeleteButton.DoClick = function(pan)
        self:GetBackground():NodeRemove(self)
    end
    self.DeleteButton.Paint = function(pan, ww, hh)
        draw.RoundedBox(2, 0, 0, ww, hh, color_white)
        draw.SimpleText("X", nil, ww/2, hh/2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.ExpandButton = vgui.Create("DButton", self)
    self.ExpandButton:SetSize(15, 15)
    self.ExpandButton:SetPos(205, 10)
    self.ExpandButton:SetText("")
    self.ExpandButton.DoClick = function(pan)
        if self.IsOpen then
            self:NodeClose()
        else
            self:Open()
        end
    end
    self.ExpandButton.Paint = function(pan, ww, hh)
        draw.RoundedBox(2, 0, 0, ww, hh, color_white)
        if self.IsOpen then
            draw.SimpleText("▲", nil, ww/2, hh/2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("▼", nil, ww/2, hh/2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    self:CreateLinks()
end

function PANEL:CreateLinks()
    if self.Links then
        for index, link in ipairs(self.Links) do
            if IsValid(link) then link:Remove() end
        end
        -- Removes links
    end

    self.Links = {}
    self.OtherLinks = {}

    local function makeOtherLink(name, oNode)
        if self.OtherLinks[oNode] and IsValid(self.OtherLinks[oNode][name]) then return end
        local link = vgui.Create("DButton", oNode)
        link:SetPos(0, 50 - 5 )
        link.Name = name
        link:SetSize(10,10)
        link.DoClick = function()
            self:GetBackground():RemoveLink(self, name, oPnl)
            link:Remove()
        end
        link.Paint = function(s, w, h)
            local col = color_white

            if s.Hovered then col = Color(150,150,150) end
            surface.SetDrawColor(col)
            surface.DrawRect(0,0, w, h)
        end

        if IsValid(oNode) then
            self.OtherLinks[oNode] = self.OtherLinks[oNode] || {}
            self.OtherLinks[oNode][name] = link
        else
            self:GetBackground():RemoveLink(self, name, oNode)
        end
    end

    local function makeLink(name)
        local link = vgui.Create("DButton", self)
        link:SetPos(self:GetWide() - 10, self:GetTriggerPos(name) -5)
        link.Name = name
        link:SetSize(10,10)
        link:SetToolTip(name)

        link.OnDepressed = function( s )
            s.Linking = true
        end

        link.OnReleased = function( s )
            s.Linking = false
            local x, y = gui.MousePos()

            timer.Simple(0, function()
                local a = vgui.GetHoveredPanel()

                local hoveredPanel = vgui.GetHoveredPanel()
                if hoveredPanel and IsValid(hoveredPanel) and hoveredPanel.wOSNode then
                    self:GetBackground():MakeLink(self, hoveredPanel, link.Name)
                    makeOtherLink(link.Name, hoveredPanel)
                end
            end)

            s.mousepos = {x = x, y= y}
            self.Links[#self.Links + 1] = link
        end

        link.Paint = function(s, w, h)
            local col = color_white

            if s.Hovered then col = Color(150,150,150) end
            surface.SetDrawColor(col)
            surface.DrawRect(0,0, w, h)

            if s.Linking then
                local wasEnabled = DisableClipping( true )

                local x,y = s:ScreenToLocal(gui.MousePos())

                surface.DrawLine(w/2, h/2,x,y)

    	        DisableClipping( wasEnabled )
            end
        end
        self.Links[#self.Links + 1] = link
    end

    local nodeLinks = self:GetBackground():GetLinks(self)

    if self.Type then
        local subEventData = wOS.PES.SubEvents:Get(self.Type)

        for index, name in ipairs(subEventData.Triggers) do
            makeLink(name)

            if nodeLinks[name] then
                for index, node in pairs(nodeLinks[name]) do
                    makeOtherLink(name, node)
                end
            end
        end
    else
        makeLink("Instant")

        if nodeLinks["Instant"] then
            for index, node in pairs(nodeLinks["Instant"]) do
                makeOtherLink("Instant", node)
            end
        end
    end
end

function PANEL:SetVars(tbl)
    self._vars = tbl
    self:RecalculateName()
end

function PANEL:GetVars()
    return self._vars
end

function PANEL:GetVar(name)
    return self._vars[name]
end

function PANEL:SetVar(name, value)
    self._vars[name] = value
    self:RecalculateName()
end

function PANEL:SetMainLink(bool)
    self.MainLink = bool
end

function PANEL:GetMainLink()
    return self.MainLink
end

function PANEL:GetBackground()
    return self:GetParent():GetParent()
end

function PANEL:OnDepressed()
    local x, y = gui.MousePos()
    self.mousepos = {x = x, y= y}

    self.Dragging = true
end

function PANEL:OnReleased()
    self.Dragging = false
end

function PANEL:GetTriggerPos(triggerName)
    if self.Type then
        local subEventData = wOS.PES.SubEvents:Get(self.Type)
        -- if check
        local maxTriggers = #subEventData.Triggers
        for index, trigger in ipairs(subEventData.Triggers) do
            if trigger == triggerName then
                return 50 +16 *(index - (maxTriggers +1)/2)
            end
        end

        return false
    end

    return 50
end

function PANEL:Think()
    if self.Dragging then

        cX, cY = self.mousepos.x, self.mousepos.y
        mX, mY = gui.MousePos()

        local dX, dY = mX - cX, mY - cY

        local x,y = self:GetPos()
        self:SetPos(x + dX, y + dY)
        self.mousepos = {x = mX, y = mY}
    end
end

function PANEL:DoClick()
    if self.NextClick < CurTime() then
        local back = self:GetBackground()
    else
        self.NextClick = CurTime() + 1
    end
end

function PANEL:SaveVars()
    if self.Type then
        local subEventData = wOS.PES.SubEvents:Get(self.Type)
        -- if no data then return
        local maxTriggers = #subEventData.Triggers

        if !self.varDerma then return end

        if subEventData.Vars then
            for index, varTable in pairs(subEventData.Vars) do
                if varTable.Internal then continue end
                local varType = wOS.PES.Vars:Get(varTable.Type)
                local element = self.varDerma[varTable.Name]
                if varType then
                    local value = varType.GetValue(element)
                    if value != nil then
                        self:SetVar(varTable.Name, value)
                    end
                end
            end
        end

        for index, name in ipairs(subEventData.Triggers) do
            local triggerTable = wOS.PES.Triggers:Get(name)
            if triggerTable then
                if triggerTable.Vars then
                    for index, varTable in pairs(triggerTable.Vars) do
                        if varTable.Internal then continue end
                        local varType = wOS.PES.Vars:Get(varTable.Type)
                        local element = self.varDerma[varTable.Name]
                        if varType then
                            local value = varType.GetValue(element)
                            if value != nil then
                                self:SetVar(varTable.Name, value)
                            end
                        end
                    end
                end
            end
        end
    end
end

function PANEL:NodeClose(bool)
    -- remove extra elements
    self:SetZPos(20)
    self.IsOpen = false
    if !bool then
        self:SaveVars()
    end
    self:SetSize(250,100)

    if IsValid(self.TypeComboBox) then
        self.TypeComboBox:Remove()
    end

    if IsValid(self.vars) then
        self.vars:Remove()
    end
end

function PANEL:Open()
    self:SetSize(250,250)
    self.IsOpen = true
    self:Populate()
    self:SetZPos(9999)
end

function PANEL:Populate()
    -- basic stuff
    -- name

    if self:GetText() != "Start" then
        local a = vgui.Create("DComboBox", self)
        a:SetSize(190, 15)
        a:SetPos(10, 10)

        local tbl = wOS.PES.SubEvents:GetAll()

        for name, triggerData in pairs(tbl) do
            if name == self.Type then
                a:AddChoice(name, nil, true)
            else
                a:AddChoice(name)
            end
        end

        function a.OnSelect(sel, index, text, data )
            self.Type = text
            self:NodeClose(true)
            self:Open()

            self:CreateLinks()
        end
        self.TypeComboBox = a


    end

    if self.Type then
        local scroll = vgui.Create("DCategoryList", self)
        scroll:SetPos(10, 35)
        scroll:SetSize(self:GetWide() - 20, self:GetTall() - 45)

        self.vars = scroll

        self.varDerma = {}
    end
    local makeVars = function(varTable, varData)
        local varType = wOS.PES.Vars:Get(varTable.Type)
        if varTable.Internal then return end

        local cat = self.vars:Add( varTable.Name )

        if !varType then
            cat:Add("This variable errored!")
            self.vars:InvalidateLayout( true )
            return
        end
        -- send in varData or the Default value
        local element = varType.DermaElement(varTable, varData)

        local back = vgui.Create("DPanel")

        if !IsValid(element) then
            element = vgui.Create("DPanel")
        end

        element:SetParent(back)
        element:Dock(TOP)
        element:DockMargin(2,2,2,2)
        element._catderma = cat
        element.varTable = varTable

        back.element = element

        self.varDerma[varTable.Name] = element

        if varType.UseTool then
            local useTool = vgui.Create("DButton", back)
            useTool:Dock(TOP)
            useTool:DockMargin(8,2,8,2)
            useTool:SetTall(30)
            useTool:SetText("Use Tool")
            useTool.DoClick = function()
                wOS.PES.SetEditingVar(self, varTable)
            end
        end

        cat:SetContents(back)

        self.vars:InvalidateLayout( true )
    end

    if self.Type then
        local subEventData = wOS.PES.SubEvents:Get(self.Type)

        if subEventData.Vars then
            for index, data in pairs(subEventData.Vars) do
                if self._vars[data.Name] == nil then self._vars[data.Name] = data.Default end
                makeVars(data, self._vars[data.Name])
            end
        end

        for index, name in ipairs(subEventData.Triggers) do
            local triggerTable = wOS.PES.Triggers:Get(name)
            if triggerTable then
                if triggerTable.Vars then
                    for index, data in pairs(triggerTable.Vars) do
                        if self._vars[data.Name] == nil then self._vars[data.Name] = data.Default end
                        makeVars(data, self._vars[data.Name])
                    end
                end
            end
        end
    end
end


function PANEL:RecalculateName()
    -- get the main title var
    -- if its set then

    if self.ID == 1 then
        self:SetText("Start")
        self.DeleteButton:Remove()
        self.ExpandButton:Remove()

        return
    end
    if self:GetVar("Event Label") and self:GetVar("Event Label") != "" then
        self:SetText(self:GetVar("Event Label"))
        return
    end
    if self.Type then
        self:SetText( self.Type .. " " .. tostring(self.ID-1))
    else
        self:SetText("Node " .. tostring(self.ID-1))
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 255))
    draw.RoundedBox(5, 1, 1, w-2, h-2, Color(255, 255, 255, 127))
end

vgui.Register( "WOS_PES_NODE", PANEL, "DButton" )

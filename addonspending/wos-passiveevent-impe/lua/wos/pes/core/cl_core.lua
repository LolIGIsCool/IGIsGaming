--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

























































































































































wOS = wOS || {}
wOS.PES = wOS.PES || {}
wOS.PES.Triggers = wOS.PES.Triggers || {}
wOS.PES.Triggers.Data = wOS.PES.Triggers.Data || {}
wOS.PES.SubEvents = wOS.PES.SubEvents || {}
wOS.PES.SubEvents.Data = wOS.PES.SubEvents.Data || {}

if wOS.PES.GetActiveMenu then return end

local nodeMenu
local mainMenu
local missionMenu

local currentPanel

local editingNode
local editingVar

function wOS.PES:GetActiveMenu()
    return currentPanel
end

function wOS.PES.IsEditingVar()
    return IsValid(editingVar) and IsValid(nodeMenu) and currentPanel == nodeMenu
end

function wOS.PES.GetEditingVar()
    return editingVar
end

function wOS.PES.SetEditingVar(node, varTable)
    editingVar = node.varDerma[varTable.Name]
    editingNode = node
    nodeMenu:Hide()
end


function wOS.PES.OpenMenu()
    if wOS.PES.IsEditingVar() then
        local element = wOS.PES.GetEditingVar()
        local varTable = element.varTable
        local varType = wOS.PES.Vars:Get(varTable.Type)
        if varType then
            local value = varType.GetValue(element)
            if value != nil then
                editingNode:SetVar(varTable.Name, value)
            end
        end
    end

    if IsValid(currentPanel) then
        currentPanel:Show()
        return
    else
        wOS.PES.OpenMainMenu()
    end
end

function wOS.PES.OpenMainMenu()
    if IsValid(mainMenu) then
        mainMenu:Show()
    else
        local pnl = vgui.Create("DFrame")
        pnl:SetTitle( "PES Toolgun" )
        pnl:SetSize(256,512)
        pnl:Center()
        pnl:MakePopup()
        pnl:SetDraggable(false)

        local startMission = vgui.Create("DButton", pnl)
        startMission:SetHeight(128)
        startMission:SetText("Start Event")
        startMission:Dock(TOP)
        startMission:DockPadding(0,3,0,0)
        startMission.DoClick = function()
            mainMenu:Hide()
            wOS.PES.OpenMissionMenu()
        end

        local makeEvent = vgui.Create("DButton", pnl)
        makeEvent:SetHeight(128)
        makeEvent:Dock(TOP)
        makeEvent:DockPadding(0,3,0,3)
        makeEvent:SetText("List Events")

        makeEvent.DoClick = function()
            mainMenu:Hide()
            wOS.PES.OpenNodeMenu()
        end

        mainMenu = pnl
    end

    currentPanel = mainMenu
end

local makeEventButton = function(name, parent)
    local info = vgui.Create("DButton", parent)
    info:SetText(name)
    info:Dock(TOP)
    info:DockMargin(0, 0, 0, 10)
    info.Think = function()
        if name == "+" then return end
        if IsValid(parent) then
            if parent.MissionName then
                if !parent.MissionName[name] then
                    info:Remove()
                end
            end
        end
    end
    info.DoClick = function()
        wOS.PES.RequestEventStart(name)
    end
    return info
end

function wOS.PES.OpenNodeMenu()
    if IsValid(nodeMenu) then
        nodeMenu:Show()
        nodeMenu:RequestUpdate()
    else
        local base = vgui.Create("DFrame")
        base:SetSize(ScrW(), ScrH())
        base:Center()
        base:MakePopup()
        base:SetDraggable(false)
		base:SetTitle("")
        base:ShowCloseButton(false)
		base.Paint = function(self, w, h)
			surface.SetDrawColor(35.5,35.5,35.5)
			surface.DrawRect(0,0, w, h)
		end

        local close = vgui.Create("DButton", base)
        close:SetSize(20,20)
        close:SetPos(ScrW()-20, 0)
        close:SetText("")
        close.Paint = function(self, w, h)
            local col = Color(255, 255, 255, (self.Hovered and 255) or 150)

            surface.SetDrawColor(col)
            surface.DrawLine(0,0, w, h)
            surface.DrawLine(w,0, 0, h)
        end
        close.DoClick = function() base:Remove() end

        local mini = vgui.Create("DButton", base)
        mini:SetSize(20,20)
        mini:SetPos(ScrW()-45, 0)
        mini:SetText("")
        mini.Paint = function(self, w, h)
            local col = Color(255, 255, 255, (self.Hovered and 255) or 150)

            surface.SetDrawColor(col)
            surface.DrawLine(0,h/2, w, h/2)
        end
        mini.DoClick = function() base:Hide() end

        local scroll = vgui.Create("DScrollPanel", base)
        scroll:SetWide(100)
        scroll:Dock(LEFT)
        scroll:DockPadding(5,5,5,5)
        base.scroll = scroll
        wOS.PES.RequestEventList(function(missionNames)
            scroll.MissionName = {}
            for index, name in pairs(missionNames) do
                makeEventButton(name, base.scroll).DoClick = function()
                    -- Request more information
                    if IsValid(base.menu) then
                        base.menu:Remove()
                    end
                    -- Add Loading Screen
                    -- add net callback

                    wOS.PES.RequestEventData(name, function(event)
                        if IsValid(base.menu) then
                            base.menu:Remove()
                        end

                        local menu = vgui.Create("WOS_PES_NodeBG", base)
                        menu:Dock(FILL)
                        menu:DockMargin(0,0,0,0)
                        base.menu = menu

                        menu.Name = event.Name
                        menu.random = event.random
                        for index, subEvent in pairs(event.subEvents) do
                            local node = menu:AddNode()
                            if index == 1 then
                                node:SetText("Start")
                                node:SetMainLink(false)
                            end

                            node.Type = subEvent.Type
                            node:SetPos(subEvent.Pos.x, subEvent.Pos.y )
                            node:SetVars(subEvent._vars)
                        end

                        for index, subEvent in pairs(event.subEvents) do
                            if subEvent.Triggers then
                                for triggerName, panelTable in pairs(subEvent.Triggers) do
                                    for _, otherID in pairs(panelTable) do
                                        local pnl, oPnl = menu.Nodes[index], menu.Nodes[otherID]
                                        menu:MakeLink(pnl, oPnl, triggerName)
                                    end
                                end
                            end
                        end

                        for _, node in pairs(menu.Nodes) do
                            node:CreateLinks()
                        end
                    end)
                end
                scroll.MissionName[name] = true
            end

            local but = makeEventButton("+", base.scroll)
            base.But = but
            but.DoClick = function()
                if IsValid(base.menu) then
                    base.menu:Remove()
                end

                local menu = vgui.Create("WOS_PES_NodeBG", base)
                menu:Dock(FILL)
                menu:DockMargin(0,0,0,0)
                base.menu = menu
                local start = menu:AddNode()

                start:SetText("Start")
                start:SetMainLink(false)

                local x,y = start:GetPos()
                start:SetPos(x - 200, y)
            end
        end)

        nodeMenu = base
        function nodeMenu:RequestUpdate()
            if IsValid(self.menu) then self.menu:Remove() end
            wOS.PES.RequestEventList(function(missionNames)
                local oldTable = table.Copy(self.scroll.MissionName)

                local newTable = {}

                for index, name in pairs(missionNames) do
                    if !oldTable[name] then
                        makeEventButton(name, self.scroll).DoClick = function()
                            -- Request more information
                            if IsValid(base.menu) then
                                base.menu:Remove()
                            end
                            -- Add Loading Screen
                            -- add net callback

                            wOS.PES.RequestEventData(name, function(event)
                                if IsValid(base.menu) then
                                    base.menu:Remove()
                                end

                                local menu = vgui.Create("WOS_PES_NodeBG", base)
                                menu:Dock(FILL)
                                menu:DockMargin(0,0,0,0)
                                base.menu = menu

                                menu.Name = event.Name

                                for index, subEvent in pairs(event.subEvents) do

                                    local node = menu:AddNode()
                                    if index == 1 then
                                        node:SetText("Start")
                                        node:SetMainLink(false)
                                    end

                                    node.Type = subEvent.Type
                                    node:SetPos(subEvent.Pos.x, subEvent.Pos.y )
                                    node:SetVars(subEvent._vars)
                                    node:CreateLinks()
                                end

                                for index, subEvent in pairs(event.subEvents) do
                                    if subEvent.Triggers then
                                        for triggerName, otherTable in pairs(subEvent.Triggers) do
                                            for _, otherID in pairs(otherTable) do
                                                local pnl, oPnl = menu.Nodes[index], menu.Nodes[otherID]
                                                menu:MakeLink(pnl, oPnl, triggerName)
                                            end
                                        end
                                    end
                                end

                                for _, node in pairs(menu.Nodes) do
                                    node:CreateLinks()
                                end
                            end)
                        end
                    end
                    newTable[name] = true
                end

                self.But:Remove()

                local but = makeEventButton("+", self.scroll)
                self.But = but
                but.DoClick = function()
                    if IsValid(self.menu) then
                        self.menu:Remove()
                    end

                    local menu = vgui.Create("WOS_PES_NodeBG", self)
                    menu:Dock(FILL)
                    menu:DockMargin(0,0,0,0)
                    base.menu = menu
                    local start = menu:AddNode()

                    start:SetText("Start")
                    start:SetMainLink(false)

                    local x,y = start:GetPos()
                    start:SetPos(x - 200, y)
                end

                self.scroll.MissionName = newTable
            end)
        end

    end

    currentPanel = nodeMenu
end

function wOS.PES.OpenMissionMenu()
    if IsValid(missionMenu) then
        missionMenu:Show()

        -- this shouldn't actually happen
        missionMenu:RequestUpdate()
    else
        local hh = ScrH() * 0.4

        local base = vgui.Create("DFrame")
        base:SetTitle( "Mission Menu" )
        base:SetSize(200, hh)
        base:Center()
        base:MakePopup()
        base:SetDraggable(false)

        local scrollpanel = vgui.Create("DScrollPanel", base)
        scrollpanel:SetSize(180, hh - 30)
        scrollpanel:SetPos(10, 30)
        wOS.PES.RequestEventList(function(missionNames)
            base.scroll.MissionName = {}
            for index, name in pairs(missionNames) do
                makeEventButton(name, base.scroll)
                base.scroll.MissionName[name] = true
            end
        end)

        base.scroll = scrollpanel
        missionMenu = base

        function missionMenu:RequestUpdate()
            wOS.PES.RequestEventList(function(missionNames)
                local oldTable = table.Copy(missionMenu.scroll.MissionName)

                local newTable = {}

                for index, name in pairs(missionNames) do
                    if !oldTable[name] then
                        makeEventButton(name, missionMenu.scroll)
                    end
                    newTable[name] = true
                end
                missionMenu.scroll.MissionName = newTable
            end)
        end
    end
end
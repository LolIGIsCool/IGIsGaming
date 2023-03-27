--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

























































































































































local PANEL = {}


local bgMaterial = Material("wos/pes/bg.png", "noclamp smooth")

local borderBlack = Color(0,0,0, 150)
local bgBlack = Color(36,36,36) -- annoyingly 1 rgb off when actual rendering from the png WHY SOURCE WHYYYYY
local bgLighter = Color(255,255,255,100)

function PANEL:Init()
    self.Nodes = {}
    self.Name = ""
    self.Links = {}

    self._x = 0
    self._y = 0

    self._tx = 0
    self._ty = 0

    self._background = vgui.Create("DButton", self)
    self._background:SetSize(1920*4, 1920*4)
    self._background:Center()
    self._background:SetText("")
    self._background.Paint = function(sef, w, h)
        -- draw a 7680 by 7680 rect
        -- it might be very intensive to draw

		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(bgMaterial)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w,h)


        for pnl, triggerLinks in pairs(self.Links) do
            if !IsValid(pnl) then
                self:NodeRemove(pnl)
                continue
            end

            for triggerName, panelTable in pairs(triggerLinks) do
                for index, oPnl in ipairs(panelTable) do
                    if !IsValid(oPnl) then
                        self:RemoveLink(pnl, triggerName, oPnl)
                        continue
                    end

                    local x,y = pnl:GetPos()
                    local w,h = oPnl:GetPos()
                    local posY =  pnl:GetTriggerPos(triggerName)

                    if !posY then
                        self:RemoveLink(pnl, triggerName, oPnl)
                        continue
                    end

                    h = h + 50
                    y = y + posY

                    x = x + pnl:GetWide() -5

                    local col = color_white

                    surface.SetDrawColor(col)
                    surface.DrawLine(x,y, w, h)
                end
            end
        end
    end

    self._background.OnDepressed = function( s )
        self:StartDragging()
    end

    self._background.OnReleased = function( s )
        self:StopDragging()
    end

    local tools = vgui.Create("DPanel", self)
    tools:SetWide(70)
    tools:SetHeight(self:GetTall()-60)
	tools.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, borderBlack)
		draw.RoundedBox(4, 4, 4, w-8, h-8, bgBlack)
		draw.RoundedBox(4, 4, 4, w-8, h-8, bgLighter)
	end

    local addNode = vgui.Create("DButton", tools)
    addNode:SetSize(60,60)
    addNode:Dock(TOP)
    addNode:DockMargin(6,5,6,5)
    addNode:SetText("Add Node")
    addNode.DoClick = function()
        self:AddNode()
    end
	addNode.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, borderBlack)
		draw.RoundedBox(4, 4, 4, w-8, h-8, bgBlack)
		if self.Hovered then
			draw.RoundedBox(4, 4, 4, w-8, h-8, bgLighter)
		end
	end

    local printEvent = vgui.Create("DButton", tools)
    printEvent:SetSize(60, 60)
    printEvent:Dock(TOP)
    printEvent:DockMargin(6,5,6,5)
    printEvent:SetText("Save Event")
	printEvent.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, borderBlack)
		draw.RoundedBox(4, 4, 4, w-8, h-8, bgBlack)
		if self.Hovered then
			draw.RoundedBox(4, 4, 4, w-8, h-8, bgLighter)
		end
	end
    printEvent.DoClick = function()

        local tbl = {
            Name = "",
            oldname = self.Name,
            subEvents = {},
        }

        for index, node in ipairs(self.Nodes) do

            if node.IsOpen then
                node:NodeClose()
            end

            local eventTbl = {
                ID = node.ID,
                Type = node.Type,
                Triggers = {},
                Pos = {},
                _vars = node:GetVars(),
            }

            eventTbl.Pos.x, eventTbl.Pos.y = node:GetPos()

            local subEventData = wOS.PES.SubEvents:Get(node.Type)

            if !subEventData and node.ID == 1 then
                subEventData = {Triggers = {"Instant"}}
            end

            if self.Links[node] then
                for triggerName, panelTable in pairs(self.Links[node]) do
                    local tbl = {}
                    for _, oPnl in pairs(panelTable) do
                        tbl[#tbl + 1] = oPnl.ID
                    end
                    eventTbl.Triggers[triggerName] = tbl
                end
            end

            if subEventData and subEventData.Vars then
                for index, varData in ipairs(subEventData.Vars) do // make this run a getValue on it.
                    eventTbl._vars[varData.Name] = node:GetVar(varData.Name) || varData.Default
                end
            end

            if subEventData and subEventData.Triggers then
                for index, triggerName in ipairs(subEventData.Triggers) do
                    local triggerData = wOS.PES.Triggers:Get(triggerName)
                    -- if check
					if triggerData then
                    	for index, varData in ipairs(triggerData.Vars || {}) do
                    	    eventTbl._vars[varData.Name] = node:GetVar(varData.Name) || varData.Default
                    	end
					else
						break
					end
                end
            end

            tbl.subEvents[node.ID] = eventTbl
        end

        local dframe = vgui.Create("DFrame")
        dframe:MakePopup()
        dframe:SetSize(300, 90)
        dframe:SetTitle( "" )
        dframe.Think = function()
            dframe:MoveToFront()
        end
        dframe:Center()

        local textentry = vgui.Create("DTextEntry", dframe)
        textentry:SetSize(280, 20)
        textentry:SetPos(10, 20)
        if self.Name != "" then
            textentry:SetText(self.Name)
        end
        textentry:SetPlaceholderText("Event Name")

        local random = vgui.Create("DTextEntry", dframe)
        random:SetSize(280, 20)
        random:SetPos(10, 50)
        random:SetPlaceholderText("Random Chance")
        if self.random != nil then
            random:SetText(self.random)
        end

        local but = vgui.Create("DButton", dframe)
        but:SetSize(60, 20)
        but:SetText("Confirm")
        but:SetPos(50-15, 70)
        but.DoClick =  function()
            tbl.Name = textentry:GetText()

            tbl.random = math.Round( math.abs(tonumber(random:GetText()) or 0))
            dframe:Remove()
            wOS.PES.NetworkEvent(tbl)

            wOS.PES:GetActiveMenu():RequestUpdate()
        end
    end
    self._tools = tools
end

function PANEL:OnSizeChanged(nW, nH)
    self._background:Center()
    self._tools:SetHeight(nH-60)
    self._tools:SetPos(nW - self._tools:GetWide(), 30)
end

function PANEL:GetCenter()
    local aX = self._background:GetWide()/2 - self._x
    local aY = self._background:GetTall()/2 - self._y

    return aX, aY
end

function PANEL:AddNode()
    local id = #self.Nodes + 1
    local x,y = self:GetCenter()
    local dbutton = vgui.Create("WOS_PES_NODE", self._background)
    dbutton:SetPos(x-50, y-50)
    dbutton.main = self
    dbutton.ID = id

    if index != 1 then
        dbutton:RecalculateName()
    end

    self.Nodes[id] = dbutton

    return dbutton
end

function PANEL:StartDragging()
    self.Dragging = true

    if IsValid(self.ViewingNode) then
        self.ViewingNode:NodeClose()
        self.ViewingNode = false
    end

    local x,y = gui.MousePos()

    self.mousepos = {x = x, y = y}
end

local speed = 100

function PANEL:Think()
    if self.Dragging then
        local x,y = gui.MousePos()
        if !self.mousepos then
            self.mousepos = {x = x, y = y}
        end
        local dX = x - self.mousepos.x
        local dY = y - self.mousepos.y

        local oldMouseY = self.mousepos.y
        self.mousepos = {x = x, y = y}

        self._tx = dX + self._x
        self._ty = dY + self._y
        local posChanged = false

        if self.tx != self._x then
            posChanged = true
            self._x = math.Approach(self._x, self._tx, FrameTime() * speed*self:GetWide())
        end

        if self.ty != self._y then
            local x,y = self._background:GetPos()

            posChanged = true
            self._y = math.Approach(self._y, self._ty, FrameTime() * speed*self:GetTall())
        end

        if posChanged then
            local aX = self:GetWide()/2 -self._background:GetWide()/2
            local aY = self:GetTall()/2 -self._background:GetTall()/2
            local x,y = self._background:GetPos()

            self._background:SetPos( aX+self._x,  aY + self._y)
        end
    end
end

function PANEL:StopDragging()
    self.Dragging = false
end

function PANEL:MakeLink(pnl, oPnl, type)
    if pnl == oPnl then return end
    if not oPnl:GetMainLink() then return end
    self.Links[pnl] = self.Links[pnl] || {}
    self.Links[pnl][type] = self.Links[pnl][type] || {}
    if table.HasValue(self.Links[pnl][type], oPnl) then return end
    table.insert(self.Links[pnl][type], oPnl)
end

function PANEL:RemoveLink(pnl, type, oPnl)
    if self.Links[pnl] then
        if self.Links[pnl][type] then
            if oPnl then
                table.RemoveByValue(self.Links[pnl][type],oPnl)
            else
                self.Links[pnl][type] = {}
            end
        end
    end
end

function PANEL:GetLinks(pnl)
    return self.Links[pnl] || {}
end

function PANEL:NodeRemove(node)
    if node.ID == 1 then return end
    self.Links[node] = nil

    local id = 1

    if IsValid(node) then
        node:Remove()
    end

    local invalidIndexs = {}

    for index, node in ipairs(self.Nodes) do
        if !IsValid(node) then
            invalidIndexs[#invalidIndexs + 1] = index
        else
            node.ID = id
            id = id + 1
            if index != 1 then
                node:RecalculateName()
            end
        end
    end

    for x = 1, #invalidIndexs do
        table.remove(self.Nodes,invalidIndexs[#invalidIndexs])
    end
end

function PANEL:Paint()
end

vgui.Register( "WOS_PES_NodeBG", PANEL, "Panel" )
if CLIENT then
    PromotionMenu = function()
        local function GlobalLength(length, type)
            if type == w then
                return length * (ScrW() / 1920)
            elseif type == h then
                return length * (ScrH() / 1080)
            end
        end

        --------------------------------------------------------------------------
        --  Pre-Defined Variablesa
        local bgImages = {}
        bgImages["Logo_Banner"] = "materials/ig/menu/ig_banner.png"
        bgImages["Close"] = "materials/ig/menu/ig_close.png"
        bgImages["Close_hov"] = "materials/ig/menu/ig_close_hov.png"
        bgImages["Menu_1"] = "materials/ig/menu/menu_b1.png"
        bgImages["Menu_sel_1"] = "materials/ig/menu/menu_sel_b1.png"
        bgImages["Menu_hov_1"] = "materials/ig/menu/menu_hov_b1.png"
        bgImages["Menu_2"] = "materials/ig/menu/menu_b2.png"
        bgImages["Menu_sel_2"] = "materials/ig/menu/menu_sel_b2.png"
        bgImages["Menu_hov_2"] = "materials/ig/menu/menu_hov_b2.png"
        bgImages["Menu_3"] = "materials/ig/menu/menu_b3.png"
        bgImages["Menu_sel_3"] = "materials/ig/menu/menu_sel_b3.png"
        bgImages["Menu_hov_3"] = "materials/ig/menu/menu_hov_b3.png"
        bgImages["Menu_4"] = "materials/ig/menu/menu_b4.png"
        bgImages["Menu_sel_4"] = "materials/ig/menu/menu_sel_b4.png"
        bgImages["Menu_hov_4"] = "materials/ig/menu/menu_hov_b4.png"
        bgImages["Menu_background"] = "materials/ig/menu/menu_background.png"
        bgImages["IG_Logo"] = "materials/ig/menu/ig_logo.png"
        bgImages["IG_Logo_hov"] = "materials/ig/menu/ig_logo_hov.png"
        bgImages["IG_TS"] = "materials/ig/menu/ig_ts.png"
        bgImages["IG_TS_hov"] = "materials/ig/menu/ig_ts_hov.png"
        bgImages["IG_Donate"] = "materials/ig/menu/ig_mb.png"
        bgImages["IG_Donate_hov"] = "materials/ig/menu/ig_mb_hov.png"
        bgImages["Set_Promote"] = "materials/ig/menu/set_promote.png"
        bgImages["Set_Promote_hov"] = "materials/ig/menu/set_promote_hov.png"
        bgImages["Set_Demote"] = "materials/ig/menu/set_demote.png"
        bgImages["Set_Demote_hov"] = "materials/ig/menu/set_demote_hov.png"
        bgImages["Set_Rank"] = "materials/ig/menu/set_rank.png"
        bgImages["Set_Rank_hov"] = "materials/ig/menu/set_rank_hov.png"
        bgImages["Set_Regiment"] = "materials/ig/menu/set_regiment.png"
        bgImages["Set_Regiment_hov"] = "materials/ig/menu/set_regiment_hov.png"
        bgImages["Search_player"] = "materials/ig/menu/search_player.png"
        bgImages["Search_player_hov"] = "materials/ig/menu/search_player_hov.png"
        bgImages["Admin_Menu"] = "materials/ig/menu/menu_png.png"
        bgImages["IG_Logo_hov2"] = "materials/ig/menu/ig_logo_hov2.png"
        bgImages["IG_Super_hov"] = "materials/ig/menu/ig_super_hov.png"
        bgImages["Test"] = "materials/test.png"
        local colorPallete = {}
        colorPallete["First"] = Color(35, 50, 70)
        colorPallete["Second"] = Color(35, 35, 35)
        colorPallete["Third"] = Color(100, 35, 35)
        colorPallete["Fourth"] = Color(170, 35, 35)
        --------------------------------------------------------------------------
        --  Main Panel
        local MainPanel = vgui.Create("EditablePanel")
        MainPanel:SetSize(GlobalLength(1000, w), GlobalLength(720, h))
        MainPanel:Center()
        MainPanel:MakePopup()

        function MainPanel:Paint(w, h)
            surface.SetDrawColor(colorPallete["First"])
            surface.DrawRect(0, 0, w, h)
        end

        local MainPanelHeader = vgui.Create("DPanel", MainPanel)
        MainPanelHeader:SetPos(0, 0)
        MainPanelHeader:SetSize(MainPanel:GetWide(), MainPanel:GetTall() / 12)

        function MainPanelHeader:Paint(w, h)
            surface.SetDrawColor(colorPallete["Second"])
            surface.DrawRect(0, 0, w, h)
        end

        local MainPanelHeader_BClose = vgui.Create("DImageButton", MainPanelHeader)
        MainPanelHeader_BClose:SetPos(MainPanelHeader:GetWide() - MainPanelHeader:GetTall(), 0)
        MainPanelHeader_BClose:SetSize(MainPanelHeader:GetTall(), MainPanelHeader:GetTall())
        MainPanelHeader_BClose:SetImage(bgImages["Close"])

        MainPanelHeader_BClose.DoClick = function()
            MainPanel:Hide()
        end

        MainPanelHeader_BClose.Paint = function(self)
            if self:IsHovered() then
                self:SetImage(bgImages["Close_hov"])
            else
                self:SetImage(bgImages["Close"])
            end
        end

        local MainPanelHeader_Logo = vgui.Create("DImage", MainPanelHeader)
        MainPanelHeader_Logo:SetPos(0, 0)
        MainPanelHeader_Logo:SetSize(MainPanelHeader:GetTall() * 3, MainPanelHeader:GetTall())
        MainPanelHeader_Logo:SetImage(bgImages["Logo_Banner"])
        --------------------------------------------------------------------------
        --  Home Panel
        local HomePanel = vgui.Create("DPanel", MainPanel)
        HomePanel:SetPos(0, MainPanelHeader:GetTall())
        HomePanel:SetSize(MainPanel:GetWide(), MainPanel:GetTall() - MainPanelHeader:GetTall())
        HomePanel:Show()

        function HomePanel:Paint(w, h)
            surface.SetDrawColor(colorPallete["First"])
            surface.DrawRect(0, 0, w, h)
        end

        local HomePanel_bg = vgui.Create("DImage", HomePanel)
        HomePanel_bg:SetPos(0, 0)
        HomePanel_bg:SetSize(HomePanel:GetWide(), HomePanel:GetTall())
        HomePanel_bg:SetImage(bgImages["Menu_background"])
        -- Home Panel Contents
        local HomePanel_Donate = vgui.Create("DImageButton", HomePanel)
        HomePanel_Donate:SetSize(HomePanel:GetTall() / 4, HomePanel:GetTall() / 4)
        HomePanel_Donate:SetPos(MainPanelHeader:GetWide() / 2 - HomePanel_Donate:GetTall() / 2, HomePanel:GetTall() / 2 - HomePanel:GetTall() / 4)
        HomePanel_Donate:SetImage(bgImages["IG_Donate"])

        HomePanel_Donate.DoClick = function()
            RunConsoleCommand("buttonDonate")
        end

        HomePanel_Donate.Paint = function(self)
            if self:IsHovered() then
                self:SetImage(bgImages["IG_Donate_hov"])
            else
                self:SetImage(bgImages["IG_Donate"])
            end
        end

        local HomePanel_Forums = vgui.Create("DImageButton", HomePanel)
        HomePanel_Forums:SetSize(HomePanel:GetTall() / 4, HomePanel:GetTall() / 4)
        HomePanel_Forums:SetPos(MainPanelHeader:GetWide() / 2 - HomePanel_Forums:GetTall() * 2, HomePanel:GetTall() / 2 - HomePanel:GetTall() / 4)
        HomePanel_Forums:SetImage(bgImages["IG_Logo"])

        HomePanel_Forums.DoClick = function()
            RunConsoleCommand("buttonForums")
        end

        HomePanel_Forums.Paint = function(self)
            if self:IsHovered() then
                self:SetImage(bgImages["IG_Logo_hov"])
            else
                self:SetImage(bgImages["IG_Logo"])
            end
        end

        local HomePanel_Teamspeak = vgui.Create("DImageButton", HomePanel)
        HomePanel_Teamspeak:SetSize(HomePanel:GetTall() / 4, HomePanel:GetTall() / 4)
        HomePanel_Teamspeak:SetPos(MainPanelHeader:GetWide() / 2 + HomePanel_Teamspeak:GetTall(), HomePanel:GetTall() / 2 - HomePanel:GetTall() / 4)
        HomePanel_Teamspeak:SetImage(bgImages["IG_TS"])

        HomePanel_Teamspeak.DoClick = function()
            RunConsoleCommand("buttonTeamspeak")
        end

        HomePanel_Teamspeak.Paint = function(self)
            if self:IsHovered() then
                self:SetImage(bgImages["IG_TS_hov"])
            else
                self:SetImage(bgImages["IG_TS"])
            end
        end

        local HomePanel_CollapseMenu = vgui.Create("DCollapsibleCategory", HomePanel)
        HomePanel_CollapseMenu:SetSize(250, 100)
        HomePanel_CollapseMenu:SetPos(HomePanel:GetWide() / 2 - HomePanel_CollapseMenu:GetWide() / 2, HomePanel:GetTall() * 0.6)
        HomePanel_CollapseMenu:SetExpanded(0)
        HomePanel_CollapseMenu:SetLabel("Player Settings")
        local HomePanel_CollapseList = vgui.Create("DPanelList", HomePanel)
        HomePanel_CollapseList:SetSpacing(0)
        HomePanel_CollapseList:EnableHorizontal(false)
        HomePanel_CollapseList:EnableVerticalScrollbar(true)
        HomePanel_CollapseMenu:SetContents(HomePanel_CollapseList)
        local HomePanel_Col_Lis_1 = vgui.Create("DCheckBoxLabel")
        HomePanel_Col_Lis_1:SetText("Mute Vehicle Sounds")
        --HomePanel_Col_Lis_1:SetConVar( "moose_muteships" )
        --HomePanel_Col_Lis_1:SetValue( 1 )
        HomePanel_Col_Lis_1:SizeToContents()
        HomePanel_CollapseList:AddItem(HomePanel_Col_Lis_1)

        function HomePanel_Col_Lis_1:Paint(w, h)
            surface.SetDrawColor(colorPallete["First"])
            surface.DrawRect(0, 0, w, h)
        end

        function HomePanel_Col_Lis_1:OnChange(bVal)
            if (bVal) then
                LocalPlayer():ConCommand("moose_muteships 1")
                LocalPlayer():ConCommand("stopsound")
            else
                LocalPlayer():ConCommand("moose_muteships 0")
                LocalPlayer():ConCommand("stopsound")
            end
        end

        local HomePanel_Col_Lis_2 = vgui.Create("DCheckBoxLabel")
        HomePanel_Col_Lis_2:SetText("Toggle Chat Timestamps")
        HomePanel_Col_Lis_2:SizeToContents()
        HomePanel_CollapseList:AddItem(HomePanel_Col_Lis_2)

        function HomePanel_Col_Lis_2:Paint(w, h)
            surface.SetDrawColor(colorPallete["First"])
            surface.DrawRect(0, 0, w, h)
        end

        function HomePanel_Col_Lis_2:OnChange(bVal)
            if (bVal) then
                LocalPlayer():ConCommand("kumo_chatstamp 1")
            else
                LocalPlayer():ConCommand("kumo_chatstamp 0")
            end
        end

        local HomePanel_Col_Lis_3 = vgui.Create("DCheckBoxLabel")
        HomePanel_Col_Lis_3:SetText("Disable Forum Notifications")
        HomePanel_Col_Lis_3:SizeToContents()
        HomePanel_CollapseList:AddItem(HomePanel_Col_Lis_3)

        function HomePanel_Col_Lis_3:Paint(w, h)
            surface.SetDrawColor(colorPallete["First"])
            surface.DrawRect(0, 0, w, h)
        end

        function HomePanel_Col_Lis_3:OnChange(bVal)
            if (bVal) then
                LocalPlayer():ConCommand("kumo_forumoff 1")
            else
                LocalPlayer():ConCommand("kumo_forumoff 0")
            end
        end

        local AdminPanel_CollapseMenu = vgui.Create("DCollapsibleCategory", HomePanel)
        AdminPanel_CollapseMenu:SetSize(250, 100)
        AdminPanel_CollapseMenu:SetPos(HomePanel:GetWide() / 2 - AdminPanel_CollapseMenu:GetWide() / 2, HomePanel:GetTall() * 0.75)
        AdminPanel_CollapseMenu:SetExpanded(0)
        AdminPanel_CollapseMenu:SetLabel("Superadmin Settings")
        local AdminPanel_CollapseList = vgui.Create("DPanelList", HomePanel)
        AdminPanel_CollapseList:SetSpacing(0)
        AdminPanel_CollapseList:EnableHorizontal(false)
        AdminPanel_CollapseList:EnableVerticalScrollbar(true)
        AdminPanel_CollapseMenu:SetContents(AdminPanel_CollapseList)
        local AdminPanel_Col_Lis_1 = vgui.Create("DCheckBoxLabel")
        AdminPanel_Col_Lis_1:SetText("Toggle Hitbox Render")
        AdminPanel_Col_Lis_1:SizeToContents()
        AdminPanel_CollapseList:AddItem(AdminPanel_Col_Lis_1)

        function AdminPanel_Col_Lis_1:Paint(w, h)
            surface.SetDrawColor(colorPallete["Fourth"])
            surface.DrawRect(0, 0, w, h)
        end

        function AdminPanel_Col_Lis_1:OnChange(bVal)
            if (bVal) then
                LocalPlayer():ConCommand("hitbox_togglerender")
            else
                LocalPlayer():ConCommand("hitbox_togglerender")
            end
        end

        local AdminPanel_Col_Lis_2 = vgui.Create("DCheckBoxLabel")
        AdminPanel_Col_Lis_2:SetText("Toggle Command Echo")
        AdminPanel_Col_Lis_2:SizeToContents()
        AdminPanel_CollapseList:AddItem(AdminPanel_Col_Lis_2)

        function AdminPanel_Col_Lis_2:Paint(w, h)
            surface.SetDrawColor(colorPallete["Fourth"])
            surface.DrawRect(0, 0, w, h)
        end

        function AdminPanel_Col_Lis_2:OnChange(bVal)
            if (bVal) then
                LocalPlayer():ConCommand("ulx toggleecho")
            else
                LocalPlayer():ConCommand("ulx toggleecho")
            end
        end

        if not LocalPlayer():IsSuperAdmin() then
            AdminPanel_CollapseMenu:Hide()
        end

        --[[
                local HomePanel_Col_Lis_2 = vgui.Create( "DNumSlider" )
                    HomePanel_Col_Lis_2:SizeToContents()
                    HomePanel_Col_Lis_2:SetText( "PAC 3 Distance" )
                    HomePanel_Col_Lis_2:SetMin( 0 )
                    HomePanel_Col_Lis_2:SetMax( 999999 )
                    HomePanel_Col_Lis_2:SetDecimals( 0 )
                    HomePanel_Col_Lis_2:SetConVar( "pac_draw_distance" )
                    HomePanel_CollapseList:AddItem( HomePanel_Col_Lis_2 )

                function HomePanel_Col_Lis_2:Paint(w, h)
                    surface.SetDrawColor(colorPallete["First"])
                    surface.DrawRect(0, 0, w, h)
                end
]]
        -- Regiment Panel
        local RegimentPanel = vgui.Create("DPanel", MainPanel)
        RegimentPanel:SetPos(0, MainPanelHeader:GetTall())
        RegimentPanel:SetSize(MainPanel:GetWide(), MainPanel:GetTall() - MainPanelHeader:GetTall())
        RegimentPanel:Hide()

        function RegimentPanel:Paint(w, h)
            surface.SetDrawColor(colorPallete["First"])
            surface.DrawRect(0, 0, w, h)
        end

        if not LocalPlayer():IsAdmin() then
            RegimentPanel:Hide()
        end

        local selPlayer
        local prevSelPlayer
        local Regiment_Player_List = vgui.Create("DListView", RegimentPanel)
        Regiment_Player_List:SetPos(RegimentPanel:GetWide() / 25, RegimentPanel:GetTall() / 12)
        Regiment_Player_List:SetSize(RegimentPanel:GetWide() / 1.7, RegimentPanel:GetTall() / 1.5)
        Regiment_Player_List:SetMultiSelect(false)
        Regiment_Player_List:AddColumn("Name")
        Regiment_Player_List:AddColumn("SteamID")
        Regiment_Player_List:AddColumn("Regiment")
        Regiment_Player_List:AddColumn("Rank")

        Regiment_Player_List.OnRowSelected = function(self, line)
            local ply = self:GetLine(line):GetValue(2)
            selPlayer = player.GetBySteamID(ply)
        end

        for k, v in pairs(player.GetAll()) do
            Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
            Regiment_Player_List:SortByColumn(1, false)
        end

        local Regiment_Regiment_List = vgui.Create("DListView", RegimentPanel)
        Regiment_Regiment_List:SetPos(RegimentPanel:GetWide() - (RegimentPanel:GetWide() / 3 - 20), RegimentPanel:GetTall() / 12)
        Regiment_Regiment_List:SetSize(RegimentPanel:GetWide() / 4, RegimentPanel:GetTall() / 3.5)
        Regiment_Regiment_List:SetMultiSelect(false)
        Regiment_Regiment_List:AddColumn("Regiment")
        timer.Simple(1,function()
            for k, v in pairs(TeamTable) do
                Regiment_Regiment_List:AddLine(k, k)
            end
        end)

        local Regiment_Rank_List = vgui.Create("DListView", RegimentPanel)
        Regiment_Rank_List:SetPos(RegimentPanel:GetWide() - (RegimentPanel:GetWide() / 3 - 20), RegimentPanel:GetTall() / 2.5)
        Regiment_Rank_List:SetSize(RegimentPanel:GetWide() / 4, RegimentPanel:GetTall() / 3.5)
        Regiment_Rank_List:SetMultiSelect(false)
        Regiment_Rank_List:AddColumn("Rank")

        Regiment_Rank_List.Think = function(self)
            if not Regiment_Player_List:GetSelectedLine() then
                self:Clear()
                prevSelPlayer = nil
                selPlayer = nil
            elseif selPlayer ~= prevSelPlayer and IsValid(selPlayer) then
                self:Clear()

                for k, v in pairs(TeamTable[selPlayer:GetRegiment()]) do
                    self:AddLine(v.RealName, v.Rank)
                end

                self:SortByColumn(2)
            end

            prevSelPlayer = selPlayer
        end

        local Regiment_BSetRank = vgui.Create("DImageButton", RegimentPanel)
        Regiment_BSetRank:SetPos(RegimentPanel:GetWide() - (RegimentPanel:GetWide() / 3 - 20), RegimentPanel:GetTall() / 1.2)
        Regiment_BSetRank:SetSize(RegimentPanel:GetWide() / 9, (RegimentPanel:GetTall() / 10) / 2)
        Regiment_BSetRank:SetImage(bgImages["Set_Rank"])

        Regiment_BSetRank.Paint = function(self)
            if self:IsHovered() then
                self:SetImage(bgImages["Set_Rank_hov"])
            else
                self:SetImage(bgImages["Set_Rank"])
            end 
        end

        Regiment_BSetRank.DoClick = function()
            if not Regiment_Rank_List:GetSelectedLine() then return end
            if not selPlayer or not selPlayer:IsPlayer() then return end
            local count = Regiment_Rank_List:GetLine(Regiment_Rank_List:GetSelectedLine()):GetValue(2)
            net.Start("SetPlayerRank")
            net.WriteUInt(count, 10)
            net.WriteEntity(selPlayer)
            net.SendToServer()
            Regiment_Rank_List:Clear()
            Regiment_Player_List:Clear()

            for k, v in pairs(TeamTable[selPlayer:GetRegiment()]) do
                Regiment_Rank_List:AddLine(v.RealName, v.Rank)
                Regiment_Rank_List:SortByColumn(1, false)
            end

            for k, v in pairs(player.GetAll()) do
                Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
                Regiment_Player_List:SortByColumn(1, false)
            end
        end

        local Regiment_BSetRegiment = vgui.Create("DImageButton", RegimentPanel)
        Regiment_BSetRegiment:SetPos(RegimentPanel:GetWide() - (RegimentPanel:GetWide() / 3 - 20) + Regiment_BSetRank:GetWide(), RegimentPanel:GetTall() / 1.2)
        Regiment_BSetRegiment:SetSize(RegimentPanel:GetWide() / 9, (RegimentPanel:GetTall() / 10) / 2)
        Regiment_BSetRegiment:SetImage(bgImages["Set_Regiment"])

        Regiment_BSetRegiment.Paint = function(self)
            if self:IsHovered() then
                self:SetImage(bgImages["Set_Regiment_hov"])
            else
                self:SetImage(bgImages["Set_Regiment"])
            end
        end

        Regiment_BSetRegiment.DoClick = function()
            if not Regiment_Regiment_List:GetSelectedLine() then return end
            if not selPlayer then return end
            local reg = Regiment_Regiment_List:GetLine(Regiment_Regiment_List:GetSelectedLine()):GetValue(2)
            net.Start("SetPlayerRegiment")
            net.WriteString(reg)
            net.WriteEntity(selPlayer)
            net.SendToServer()
            Regiment_Rank_List:Clear()
            Regiment_Player_List:Clear()

            for k, v in pairs(TeamTable[selPlayer:GetRegiment()]) do
                Regiment_Rank_List:AddLine(v.RealName, v.Rank)
                Regiment_Rank_List:SortByColumn(1, false)
            end

            for k, v in pairs(player.GetAll()) do
                Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
                Regiment_Player_List:SortByColumn(1, false)
            end
        end

        local Regiment_TSearchImg = vgui.Create("DImage", RegimentPanel)
        Regiment_TSearchImg:SetSize(MainPanelHeader:GetWide() / 10, MainPanelHeader:GetTall() * 0.7)
        Regiment_TSearchImg:SetPos(RegimentPanel:GetWide() / 25, RegimentPanel:GetTall() / 12 - Regiment_TSearchImg:GetTall())
        Regiment_TSearchImg:SetImage(bgImages["Search_player"])
        local Regiment_TSearch = vgui.Create("DTextEntry", RegimentPanel) -- create the form as a child of frame
        Regiment_TSearch:SetSize(Regiment_BSetRegiment:GetWide(), Regiment_BSetRegiment:GetTall() / 2)
        Regiment_TSearch:SetPos(RegimentPanel:GetWide() / 25 + Regiment_TSearchImg:GetWide(), RegimentPanel:GetTall() / 12 - (Regiment_TSearch:GetTall() * 1.5))
        Regiment_TSearch:SetEnterAllowed(true)
        Regiment_TSearch:SetUpdateOnType(true)
        Regiment_TSearch:SetPlaceholderText("Player Search...")

        --Regiment_TSearch:MakePopup()
        -- Passes a single argument, the text entry object.
        Regiment_TSearch.OnGetFocus = function()
            --LocalPlayer():ChatPrint("Got Focus!")
            Regiment_TSearchImg:SetImage(bgImages["Search_player_hov"])
        end

        -- Passes a single argument, the text entry object.
        Regiment_TSearch.OnLoseFocus = function()
            --LocalPlayer():ChatPrint("Lost Focus!")
            Regiment_TSearchImg:SetImage(bgImages["Search_player"])
        end

        -- Passes a single argument, the text entry object.
        Regiment_TSearch.OnValueChange = function(self)
            Regiment_Player_List:Clear()

            if self:GetValue() == "" then
                for k, v in pairs(player.GetAll()) do
                    Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
                    Regiment_Player_List:SortByColumn(1, false)
                end
            else
                for k, v in pairs(player.GetAll()) do
                    if string.match(string.lower(v:Nick()), string.lower(self:GetValue())) then
                        Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
                        Regiment_Player_List:SortByColumn(1, false)
                    end
                end
            end
        end

        -- Promotion Panel
        local PromotionPanel = vgui.Create("DPanel", MainPanel)
        PromotionPanel:SetPos(0, MainPanelHeader:GetTall())
        PromotionPanel:SetSize(MainPanel:GetWide(), MainPanel:GetTall() - MainPanelHeader:GetTall())
        PromotionPanel:Hide()

        function PromotionPanel:Paint(w, h)
            surface.SetDrawColor(colorPallete["First"])
            surface.DrawRect(0, 0, w, h)
        end

        local promotionSelPlayer
        local SteamIDRemove
        local Promotion_Player_List = vgui.Create("DListView", PromotionPanel)
        Promotion_Player_List:SetPos(PromotionPanel:GetWide() / 25, PromotionPanel:GetTall() / 12)
        Promotion_Player_List:SetSize(PromotionPanel:GetWide() - (PromotionPanel:GetWide() / 25) * 2, PromotionPanel:GetTall() / 1.5)
        Promotion_Player_List:SetMultiSelect(false)
        Promotion_Player_List:AddColumn("Name")
        Promotion_Player_List:AddColumn("SteamID")
        Promotion_Player_List:AddColumn("Regiment")
        Promotion_Player_List:AddColumn("Rank")

        Promotion_Player_List.OnRowSelected = function(self, line)
            local ply = self:GetLine(line):GetValue(2)
            promotionSelPlayer = player.GetBySteamID(ply)
        end

        if LocalPlayer():GetRank() >= 4 then
            for k, v in pairs(player.GetAll()) do
                if v == LocalPlayer() then continue end

                if v:GetRank() == 0 then
                    Promotion_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName(), v:Team())
                    Regiment_Player_List:SortByColumn(1, false)
                end

                if LocalPlayer():GetRank() >= 10 then
                    if v:GetRegiment() == LocalPlayer():GetRegiment() and v:GetRank() + 1 <= LocalPlayer():GetRank() then
                        Promotion_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
                        Promotion_Player_List:SortByColumn(1, false)
                    end
                end
            end
        end

        local Promotion_BPromoteRank = vgui.Create("DImageButton", PromotionPanel)
        Promotion_BPromoteRank:SetPos(PromotionPanel:GetWide() - (PromotionPanel:GetWide() / 3 - 20), RegimentPanel:GetTall() / 1.2)
        Promotion_BPromoteRank:SetSize(PromotionPanel:GetWide() / 9, (PromotionPanel:GetTall() / 10) / 2)
        Promotion_BPromoteRank:SetImage(bgImages["Set_Promote"])

        Promotion_BPromoteRank.Paint = function(self)
            if self:IsHovered() then
                self:SetImage(bgImages["Set_Promote_hov"])
            else
                self:SetImage(bgImages["Set_Promote"])
            end
        end

        Promotion_BPromoteRank.DoClick = function(self)
            if not promotionSelPlayer then return end
            net.Start("PromoteUser")
            net.WriteEntity(promotionSelPlayer)
            net.SendToServer()
        end

        local Promotion_BDemoteRank = vgui.Create("DImageButton", PromotionPanel)
        Promotion_BDemoteRank:SetPos(PromotionPanel:GetWide() - (PromotionPanel:GetWide() / 3 - 20) + Promotion_BPromoteRank:GetWide(), RegimentPanel:GetTall() / 1.2)
        Promotion_BDemoteRank:SetSize(PromotionPanel:GetWide() / 9, (PromotionPanel:GetTall() / 10) / 2)
        Promotion_BDemoteRank:SetImage(bgImages["Set_Demote"])

        Promotion_BDemoteRank.Paint = function(self)
            if self:IsHovered() then
                self:SetImage(bgImages["Set_Demote_hov"])
            else
                self:SetImage(bgImages["Set_Demote"])
            end
        end

        Promotion_BDemoteRank.DoClick = function(self)
            if not promotionSelPlayer then return end
            net.Start("DemoteUser")
            net.WriteEntity(promotionSelPlayer)
            net.SendToServer()
        end

        local Promotion_BRemoveRank = vgui.Create("DButton", PromotionPanel)
        Promotion_BRemoveRank:SetPos(PromotionPanel:GetWide() - (PromotionPanel:GetWide() / 3 + 400), RegimentPanel:GetTall() / 1.2)
        Promotion_BRemoveRank:SetSize(PromotionPanel:GetWide() / 8, (PromotionPanel:GetTall() / 10) / 2)
        Promotion_BRemoveRank:SetText("REMOVE")
        Promotion_BRemoveRank:SetFont("Trebuchet24")
        Promotion_BRemoveRank:SetTextColor(Color(255, 255, 255, 255))

        Promotion_BRemoveRank.DoClick = function(self)
            if LocalPlayer():GetRank() <= 9 then return end
            if not SteamIDRemove then return end
            net.Start("RemoveBySteamID")
            net.WriteString(tostring(SteamIDRemove))
            net.SendToServer()
        end

        Promotion_BRemoveRank.Paint = function()
            surface.SetDrawColor(colorPallete["First"])
            surface.DrawRect(0, 0, Promotion_BRemoveRank:GetWide(), Promotion_BRemoveRank:GetTall())
        end

        local Promotion_BRemoveRankTXT = vgui.Create("DTextEntry", PromotionPanel)
        Promotion_BRemoveRank:SetPos(PromotionPanel:GetWide() - (PromotionPanel:GetWide() / 3 + 300), RegimentPanel:GetTall() / 1.2)
        Promotion_BRemoveRankTXT:SetPos(PromotionPanel:GetWide() - (PromotionPanel:GetWide() / 3 + 500), RegimentPanel:GetTall() / 1.2)
        Promotion_BRemoveRankTXT:SetSize(PromotionPanel:GetWide() / 4, (PromotionPanel:GetTall() / 9) / 2)
        Promotion_BRemoveRankTXT:SetText("STEAMID32/64")
        Promotion_BRemoveRankTXT:SetDrawBorder(true)
        Promotion_BRemoveRankTXT:SetUpdateOnType(true)

        Promotion_BRemoveRankTXT.OnGetFocus = function()
            Promotion_BRemoveRankTXT:SetText("")
        end

        Promotion_BRemoveRankTXT.OnLoseFocus = function()
            if Promotion_BRemoveRankTXT:GetValue() == "" then
                Promotion_BRemoveRankTXT:SetText("STEAMID32/64")
            end
        end

        Promotion_BRemoveRankTXT.OnValueChange = function(self)
            SteamIDRemove = self:GetValue()
        end

        if LocalPlayer():GetRank() < 10 then
            Promotion_BRemoveRank:Hide()
            Promotion_BRemoveRankTXT:Hide()
        end

        -- Admin Panel
        local AdminPanel = vgui.Create("DPanel", MainPanel)
        AdminPanel:DockPadding(AdminPanel:GetWide() * 1.3, AdminPanel:GetWide() * 0.1, AdminPanel:GetTall() * 0.5, AdminPanel:GetTall() * 3)
        AdminPanel:SetPos(0, MainPanelHeader:GetTall())
        AdminPanel:SetSize(MainPanel:GetWide(), MainPanel:GetTall() - MainPanelHeader:GetTall())
        AdminPanel:Hide()

        function AdminPanel:Paint(w, h)
            surface.SetDrawColor(colorPallete["Third"])
            surface.DrawRect(0, 0, w, h)
        end

        local AdminPanel_Sidebar = vgui.Create("DPanel", AdminPanel)
        AdminPanel_Sidebar:SetPos(0, 0)
        AdminPanel_Sidebar:SetSize(AdminPanel:GetWide() / 13, AdminPanel:GetTall())

        function AdminPanel_Sidebar:Paint(w, h)
            surface.SetDrawColor(colorPallete["Second"])
            surface.DrawRect(0, 0, w, h)
        end

        local AdminPanel_Sidebar_1 = vgui.Create("DImageButton", AdminPanel_Sidebar)
        AdminPanel_Sidebar_1:SetSize(AdminPanel_Sidebar:GetWide(), AdminPanel_Sidebar:GetWide())
        AdminPanel_Sidebar_1:SetPos(0, AdminPanel_Sidebar:GetTall() - AdminPanel_Sidebar_1:GetTall())
        AdminPanel_Sidebar_1:SetImage(bgImages["IG_Logo"])

        AdminPanel_Sidebar_1.Paint = function(self)
            if self:IsHovered() then
                self:SetImage(bgImages["IG_Logo_hov2"])
            else
                self:SetImage(bgImages["IG_Logo"])
            end
        end

        AdminPanel_Sidebar_1.DoClick = function(self)
            RunConsoleCommand("buttonForums")
        end

        local AdminPanel_Categorys = vgui.Create("DPropertySheet", AdminPanel)
        AdminPanel_Categorys:SetSize(AdminPanel:GetWide()-AdminPanel_Sidebar_1:GetWide()-AdminPanel_Sidebar_1:GetWide()*0.1,AdminPanel:GetTall())
        AdminPanel_Categorys:SetPos(AdminPanel:GetWide()*0.08,AdminPanel:GetTall()*0.0085)

        local regiments = vgui.Create("DPanel", AdminPanel_Categorys)
        regiments:SetSize(AdminPanel:GetWide(), AdminPanel:GetTall())
  --       regiments.Paint = function ()
		-- 	surface.SetDrawColor(0, 255, 0, 255)
		-- 	surface.DrawRect(0, 0, regiments:GetWide(), regiments:GetTall())
		-- end

        local regiments_List = vgui.Create("DListView", regiments)
        regiments_List:Dock(LEFT)
        regiments_List:InvalidateParent(true)
        regiments_List:SetSize(AdminPanel_Categorys:GetWide()*0.15, AdminPanel_Categorys:GetTall())

        regiments_List:SetMultiSelect(false)
        regiments_List:AddColumn("Regiment")

        timer.Simple(1,function()
            for k, v in pairs(TeamTable) do
                regiments_List:AddLine(k)
            end
        end)
        local regimentSelected = nil
        local prevSelRegiment = nil
        regiments_List.OnRowSelected = function(row,line)
            regimentSelected = row:GetLine(line):GetValue(1)
        end
        regiments:DockPadding(0, 0, AdminPanel_Categorys:GetWide()*0.2, 0)
        regiments:InvalidateParent(true)

        local ranks_List = vgui.Create("DListView", regiments)
        ranks_List:Dock(LEFT)
        ranks_List:InvalidateParent(true)
        ranks_List:SetSize(AdminPanel_Categorys:GetWide()*0.15, AdminPanel_Categorys:GetTall())
        ranks_List:SetSortable(false)

        ranks_List:SetMultiSelect(false)
        ranks_List:AddColumn("Ranks")

        ranks_List.Think = function(self)
            if not regiments_List:GetSelectedLine() then
                self:Clear()
                regimentSelected = nil
            elseif regimentSelected ~= prevSelRegiment and regimentSelected then
                self:Clear()

                for k, v in pairs(TeamTable[regimentSelected]) do
                    self:AddLine(v.RealName, v.Rank)
                end

                self:SortByColumn(2)
            end

            prevSelRegiment = regimentSelected
        end

        function GetPosTableMeme(panel)
            local postablememe,postablememe2 = panel:GetPos()
            return {postablememe,postablememe2}
        end

        function GetSizeTableMeme(panel)
            local postablememe,postablememe2 = panel:GetSize()
            return {postablememe,postablememe2}
        end

        local regiments_InputFields = vgui.Create("DScrollPanel", regiments)
        regiments_InputFields:SetSize(regiments:GetWide() * 0.40, regiments:GetTall() * 0.82 )
        regiments_InputFields:SetPos(regiments:GetWide() * 0.28, 0)
        regiments_InputFields:DockPadding(10, 10, -1, 5)
  --       regiments_InputFields.Paint = function ()
		-- 	surface.SetDrawColor(0, 0, 255, 255)
		-- 	surface.DrawRect(0, 0, regiments_InputFields:GetWide(), regiments_InputFields:GetTall())
		-- end


        local nametext = vgui.Create( "DLabel", regiments_InputFields )
        --nametext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.005)
        nametext:SetSize(regiments:GetWide()*0.5, regiments:GetTall()*0.05)
        nametext:Dock(TOP)
        nametext:SetText( "Name" )
        nametext:SetTextColor(Color(0,0,0))
        local nametextentry = vgui.Create( "DTextEntry", regiments_InputFields )
        --nametextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.05)
        nametextentry:Dock(TOP)
        nametextentry:SetSize(regiments_InputFields:GetWide() * 0.6, regiments:GetTall()*0.031)
        nametextentry:SetText( "" )
        nametextentry:SetTextColor(Color(0,0,0))

        local rnametext = vgui.Create( "DLabel", regiments_InputFields )
        --rnametext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.07)
        rnametext:Dock(TOP)
        rnametext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        rnametext:SetText( "Real Name" )
        rnametext:SetTextColor(Color(0,0,0))
        local rnametextentry = vgui.Create( "DTextEntry", regiments_InputFields )
        --rnametextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.11)
        rnametextentry:Dock(TOP)
        rnametextentry:SetSize(regiments_InputFields:GetWide() * 0.6, regiments:GetTall()*0.031)
        rnametextentry:SetText( "" )
        rnametextentry:InvalidateParent(false)
        rnametextentry:SetTextColor(Color(0,0,0))

        local regimenttext = vgui.Create( "DLabel", regiments_InputFields )
        --regimenttext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.138)
        regimenttext:Dock(TOP)
        regimenttext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        regimenttext:SetText( "Regiment" )
        regimenttext:SetTextColor(Color(0,0,0))
        local regimenttextentry = vgui.Create( "DTextEntry", regiments_InputFields )
       -- regimenttextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.178)
       	regimenttextentry:Dock(TOP)
        regimenttextentry:SetSize(regiments:GetWide()*0.35,regiments:GetTall()*0.031)
        regimenttextentry:SetText( "" )
        regimenttextentry:SetTextColor(Color(0,0,0))

        local modeltext = vgui.Create( "DLabel", regiments_InputFields )
        --modeltext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.2)
        modeltext:Dock(TOP)
        modeltext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        modeltext:SetText( "Model" )
        modeltext:SetTextColor(Color(0,0,0))
        local modeltextentry = vgui.Create( "DTextEntry", regiments_InputFields )
        --modeltextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.24)
        modeltextentry:Dock(TOP)
        modeltextentry:SetSize(regiments_InputFields:GetWide() * 0.6, regiments:GetTall()*0.031)
        modeltextentry:SetText( "" )
        modeltextentry:SetTextColor(Color(0,0,0))

        local healthtext = vgui.Create( "DLabel", regiments_InputFields )
        --healthtext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.265)
        healthtext:Dock(TOP)
        healthtext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        healthtext:SetText( "Health" )
        healthtext:SetTextColor(Color(0,0,0))
        local healthtextentry = vgui.Create( "DNumberWang", regiments_InputFields )
        --healthtextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.3)
        healthtextentry:Dock(TOP)
        healthtextentry:SetSize(regiments:GetWide()*0.35/5,regiments:GetTall()*0.031)
        healthtextentry:SetMin(1)
        healthtextentry:SetMax(999999)
        healthtextentry:SetValue(100)
        healthtextentry:SetTextColor(Color(0,0,0))


        local weaponstext = vgui.Create( "DLabel", regiments_InputFields )
        --weaponstext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.32)
        weaponstext:Dock(TOP)
        weaponstext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        weaponstext:SetText( "Weapons" )
        weaponstext:SetTextColor(Color(0,0,0))
        local weaponstextentry = vgui.Create( "DTextEntry", regiments_InputFields )
        --weaponstextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.36)
        weaponstextentry:Dock(TOP)
        weaponstextentry:SetSize(regiments:GetWide()*0.35,regiments:GetTall()*0.031)
        weaponstextentry:SetText( "{}" )
        weaponstextentry:SetTextColor(Color(0,0,0))

        local clearancetext = vgui.Create( "DLabel", regiments_InputFields )
        --clearancetext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.39)
        clearancetext:Dock(TOP)
        clearancetext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        clearancetext:SetText( "Clearance" )
        clearancetext:SetTextColor(Color(0,0,0))
        local clearancetextentry = vgui.Create( "DComboBox", regiments_InputFields )
        --clearancetextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.43)
        clearancetextentry:Dock(TOP)
        clearancetextentry:SetSize(regiments:GetWide()*0.35,regiments:GetTall()*0.031)
        clearancetextentry:SetValue("Clearance")
        clearancetextentry:AddChoice("0")
        clearancetextentry:AddChoice("1")
        clearancetextentry:AddChoice("2")
        clearancetextentry:AddChoice("3")
        clearancetextentry:AddChoice("4")
        clearancetextentry:AddChoice("5")
        clearancetextentry:AddChoice("6")
        clearancetextentry:AddChoice("ALL ACCESS")
        clearancetextentry:AddChoice("AREA ACCESS")
        clearancetextentry:AddChoice("CLASSIFIED")
        clearancetextentry:AddChoice("Imperial Citizen")
        clearancetextentry:SetTextColor(Color(0,0,0))

        local sidetext = vgui.Create( "DLabel", regiments_InputFields )
        --sidetext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.455)
        sidetext:Dock(TOP)
        sidetext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        sidetext:SetText( "Side" )
        sidetext:SetTextColor(Color(0,0,0))
        local sidetextentry = vgui.Create( "DNumberWang", regiments_InputFields )
        --sidetextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.495)
        sidetextentry:Dock(TOP)
        sidetextentry:SetSize(regiments:GetWide()*0.35/5,regiments:GetTall()*0.031)
        sidetextentry:SetMin(0)
        sidetextentry:SetMax(999999)
        sidetextentry:SetValue(1)
        sidetextentry:SetTextColor(Color(0,0,0))

        local ranktext = vgui.Create( "DLabel", regiments_InputFields )
        --ranktext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.525)
        ranktext:Dock(TOP)
        ranktext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        ranktext:SetText( "Rank" )
        ranktext:SetTextColor(Color(0,0,0))
        local ranktextentry = vgui.Create( "DNumberWang", regiments_InputFields )
        --ranktextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.565)
        ranktextentry:Dock(TOP)
        ranktextentry:SetSize(regiments:GetWide()*0.35/5,regiments:GetTall()*0.031)
        ranktextentry:SetMin(1)
        ranktextentry:SetMax(999999)
        ranktextentry:SetValue(1)
        ranktextentry:SetTextColor(Color(0,0,0))

        local othermtext = vgui.Create( "DLabel", regiments_InputFields )
        --othermtext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.6)
        othermtext:Dock(TOP)
        othermtext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        othermtext:SetText( "Other Models" )
        othermtext:SetTextColor(Color(0,0,0))
        local othermtextentry = vgui.Create( "DTextEntry", regiments_InputFields )
        --othermtextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.64)
        othermtextentry:Dock(TOP)
        othermtextentry:SetSize(regiments:GetWide()*0.35,regiments:GetTall()*0.031)
        othermtextentry:SetText( "{}" )
        othermtextentry:SetTextColor(Color(0,0,0))

        local bodytext = vgui.Create( "DLabel", regiments_InputFields )
        --bodytext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.68)
        bodytext:Dock(TOP)
        bodytext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        bodytext:SetText( "Bodygroups" )
        bodytext:SetTextColor(Color(0,0,0))
        local bodytextentry = vgui.Create( "DTextEntry", regiments_InputFields )
        --bodytextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.72)
        bodytextentry:Dock(TOP)
        bodytextentry:SetSize(regiments:GetWide()*0.35,regiments:GetTall()*0.031)
        bodytextentry:SetText( "" )
        bodytextentry:SetTextColor(Color(0,0,0))

        local skintext = vgui.Create( "DLabel", regiments_InputFields )
        --skintext:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.76)
        skintext:Dock(TOP)
        skintext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        skintext:SetText( "Skin" )
        skintext:SetTextColor(Color(0,0,0))
        local skintextentry = vgui.Create( "DNumberWang", regiments_InputFields )
        --skintextentry:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.8)
        skintextentry:Dock(TOP)
        skintextentry:SetSize(regiments:GetWide()*0.35/5,regiments:GetTall()*0.031)
        skintextentry:SetMin(0)
        skintextentry:SetMax(999999)
        skintextentry:SetValue(0)
        skintextentry:SetTextColor(Color(0,0,0))

        local movestext = vgui.Create( "DLabel", regiments_InputFields )
        --movestext:SetPos(regiments:GetWide()*0.38,regiments:GetTall()*0.76)
        movestext:Dock(TOP)
        movestext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        movestext:SetText( "Walk Speed" )
        movestext:SetTextColor(Color(0,0,0))
        local movesentry = vgui.Create( "DNumberWang", regiments_InputFields )
        --movesentry:SetPos(regiments:GetWide()*0.38,regiments:GetTall()*0.8)
        movesentry:Dock(TOP)
        movesentry:SetSize(regiments:GetWide()*0.35/5,regiments:GetTall()*0.031)
        movesentry:SetMin(0)
        movesentry:SetMax(999999)
        movesentry:SetValue(0)
        movesentry:SetTextColor(Color(0,0,0))

        local rmovestext = vgui.Create( "DLabel", regiments_InputFields )
        --rmovestext:SetPos(regiments:GetWide()*0.48,regiments:GetTall()*0.76)
        rmovestext:Dock(TOP)
        rmovestext:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        rmovestext:SetText( "Run Speed" )
        rmovestext:SetTextColor(Color(0,0,0))
        local rmovesentry = vgui.Create( "DNumberWang", regiments_InputFields )
        --rmovesentry:SetPos(regiments:GetWide()*0.48,regiments:GetTall()*0.8)
        rmovesentry:Dock(TOP)
        rmovesentry:SetSize(regiments:GetWide()*0.35/5,regiments:GetTall()*0.031)
        rmovesentry:SetMin(0)
        rmovesentry:SetMax(999999)
        rmovesentry:SetValue(0)
        rmovesentry:SetTextColor(Color(0,0,0))

        local clearanceCards = {
        	"Imperial Enlisted ID",
			"Imperial Non-Commissioned ID",
			"Imperial Officers ID",
			"Command Staff ID",
			"Executive Command Staff ID",
			"Medical Clearance",
			"Death Trooper Clearance",
			"Administration Clearance",
			"Operations Clearance",
			"Inquisitorius Clearance",
			"Intelligence Clearance",
			"Military Security Clearance",
			"Imperial Security Clearance",
			"Advanced Weapons Research Clearance",
			"Royal Clearance",
			"Imperial Civillian ID",
			"Imperial Contracted Bounty Hunter ID"
        }

        local cardsText = vgui.Create( "DLabel", regiments_InputFields )
        --rmovestext:SetPos(regiments:GetWide()*0.48,regiments:GetTall()*0.76)
        cardsText:Dock(TOP)
        cardsText:SetSize(regiments:GetWide()*0.5,regiments:GetTall()*0.05)
        cardsText:SetText( "Clearance Cards" )
        cardsText:SetTextColor(Color(0,0,0))

	    local regiments_AvailableClearances = vgui.Create("DListView", regiments_InputFields)
		regiments_AvailableClearances:AddColumn("Available Clearances")
		regiments_AvailableClearances:SetSize(0.45 * regiments_InputFields:GetWide(), 0.2 * regiments:GetTall())
		regiments_AvailableClearances:Dock(TOP)
		for k, v in pairs(clearanceCards) do
			regiments_AvailableClearances:AddLine(v)
		end

		local regiments_CurrentClearances = vgui.Create("DListView", regiments_InputFields)
		regiments_CurrentClearances:AddColumn("Current Clearances")
		regiments_CurrentClearances:SetSize(0.45 * regiments_InputFields:GetWide(), 0.2 * regiments:GetTall())
		regiments_CurrentClearances:Dock(TOP)

		function regiments_AvailableClearances:DoDoubleClick (lineID, line)
			regiments_CurrentClearances:AddLine(clearanceCards[lineID])
		end

		function regiments_CurrentClearances:DoDoubleClick (lineID, line)
			regiments_CurrentClearances:RemoveLine(regiments_CurrentClearances:GetSelectedLine())
		end

        local colourtextmix = vgui.Create( "DColorMixer", regiments )
        colourtextmix:SetPos(AdminPanel_Categorys:GetWide()*0.7625, AdminPanel_Categorys:GetTall()*0.625)
        colourtextmix:SetSize(colourtextmix:GetWide()*0.75, colourtextmix:GetTall()*0.75)
        colourtextmix:SetPalette( true ) 
        colourtextmix:SetAlphaBar( false )
        colourtextmix:SetWangs( true )

        local modeltextview = vgui.Create( "DModelPanel", regiments )
        modeltextview:SetPos(regiments:GetWide()*0.69,regiments:GetTall()*0.05)
        modeltextview:SetSize(regiments:GetWide()*0.2,regiments:GetTall()*0.55)
        modeltextview:SetModel( "models/props_canal/canalmap001.mdl" )
        modeltextview.Entity:SetColor(Color(0,0,0,0))
        modeltextview:SetFOV(40)
        modeltextview.Angles = Angle( 0, 43, 0 )
        function modeltextview:DragMousePress()
            self.PressX, self.PressY = gui.MousePos()
            self.Pressed = true
        end

        modeltextview.DoDoubleClick = function()
            local BDFrame = vgui.Create("DFrame")
            BDFrame:SetTitle("Kumo's Scuffed Bodygroup Editor")
            BDFrame:Center()
            BDFrame:SetDraggable(false)
            BDFrame:Dock(LEFT)
            BDFrame:SetSize(430,700)

            local bdcontrolspanel = vgui.Create( "DPanelList", BDFrame )
            bdcontrolspanel:EnableVerticalScrollbar( true )
            bdcontrolspanel:Dock( FILL )

            local function bodygroupstostring()
                local bodygroups2 = {}
                for k = 0, modeltextview.Entity:GetNumBodyGroups() - 1 do
                    bodygroups2[k] = modeltextview.Entity:GetBodygroup(k)
                end
                return string.sub(table.concat(bodygroups2),2)
            end

            local function UpdateBodyGroups( pnl, val )
            if ( pnl.type == "bgroup" ) then

                modeltextview.Entity:SetBodygroup( pnl.typenum, math.Round( val ) )
                bodytextentry:SetText(bodygroupstostring())

            elseif ( pnl.type == "skin" ) then

                modeltextview.Entity:SetSkin( math.Round( val ) )
                skintextentry:SetValue(math.Round( val ))

            end
        end

        local function MakeNiceName( str )
            local newname = {}

            for _, s in pairs( string.Explode( "_", str ) ) do
                if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
                table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) -- Ugly way to capitalize first letters.
            end

            return string.Implode( " ", newname )
        end

        local function RebuildBodygroupTab()
            bdcontrolspanel:Clear()

            local nskins = modeltextview.Entity:SkinCount() - 1
            if ( nskins > 0 ) then
                local skins = vgui.Create( "DNumSlider" )
                skins:Dock( TOP )
                skins:SetText( "Skin" )
                skins:SetDark( true )
                skins:SetTall( 50 )
                skins:SetDecimals( 0 )
                skins:SetMax( nskins )
                skins:SetValue( modeltextview.Entity:GetSkin() )
                skins.type = "skin"
                skins.OnValueChanged = UpdateBodyGroups

                bdcontrolspanel:AddItem( skins )

            end

            for k = 0, modeltextview.Entity:GetNumBodyGroups() - 1 do
                if ( modeltextview.Entity:GetBodygroupCount( k ) <= 1 ) then continue end

                local bgroup = vgui.Create( "DNumSlider" )
                bgroup:Dock( TOP )
                bgroup:SetText( MakeNiceName( modeltextview.Entity:GetBodygroupName( k ) ) )
                bgroup:SetDark( true )
                bgroup:SetTall( 50 )
                bgroup:SetDecimals( 0 )
                bgroup.type = "bgroup"
                bgroup.typenum = k
                bgroup:SetMax( modeltextview.Entity:GetBodygroupCount( k ) - 1 )
                bgroup:SetValue( modeltextview.Entity:GetBodygroup(k) )
                bgroup.OnValueChanged = UpdateBodyGroups

                bdcontrolspanel:AddItem( bgroup )
            end
        end
        RebuildBodygroupTab()
        end

        function modeltextview:DragMouseRelease() self.Pressed = false end
        function modeltextview:LayoutEntity( ent )
            if ( modeltextview.Pressed ) then
                local mx, my = gui.MousePos()
                self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

                self.PressX, self.PressY = gui.MousePos()
            end

            ent:SetAngles( self.Angles )
        end

        local gaytable = {["0"] = 1,
        ["1"] = 2,
        ["2"] = 3,
        ["3"] = 4,
        ["4"] = 5,
        ["5"] = 6,
        ["6"] = 7,
        ["ALL ACCESS"] = 8,
        ["AREA ACCESS"] = 9,
        ["CLASSIFIED"] = 10,
        ["Imperial Citizen"] = 11 }

        local function fixtabletostring(tbl)
            local tblstring = table.ToString(tbl)
            if string.sub(tblstring,string.len(tblstring)-1,string.len(tblstring)) == ",}" then
                tblstring = string.sub(tblstring,1,string.len(tblstring)-2).."}"
            end
            return tblstring
        end
        local rankselected
        local regselected 
        ranks_List.OnRowSelected = function(index,row)
            regselected = regiments_List:GetLine(regiments_List:GetSelectedLine()):GetValue(1)
            rankselected = ranks_List:GetLine(row):GetValue(2)
            local tbl = TeamTable[regselected][rankselected]
            if not tbl then net.Start("requestteamtbl") net.SendToServer() return end
            nametextentry:SetText(tbl.Name)
            rnametextentry:SetText(tbl.RealName)
            regimenttextentry:SetText(tbl.Regiment)
            modeltextentry:SetText(tbl.Model)
            modeltextview.Entity:SetModel(tbl.Model)
            modeltextview.Entity:SetBodyGroups(tbl.Bodygroups)
            modeltextview.Entity:SetSkin(tbl.Skin)
            colourtextmix:SetColor(tbl.Colour)
            healthtextentry:SetValue(tbl.Health)                           
            weaponstextentry:SetText(fixtabletostring(tbl.Weapons))
            clearancetextentry:ChooseOption(tbl.Clearance,gaytable[tbl.Clearance])
            sidetextentry:SetValue(tbl.Side)
            ranktextentry:SetValue(tbl.Rank)
            othermtextentry:SetText(fixtabletostring(tbl.OtherModels))
            bodytextentry:SetText(tbl.Bodygroups) 
            skintextentry:SetValue(tbl.Skin)
            movesentry:SetValue(tbl.WalkSpeed)
            rmovesentry:SetValue(tbl.RunSpeed)

            regiments_CurrentClearances:Clear()
            if (istable(tbl.ClearanceCards)) then
                for k, v in pairs(tbl.ClearanceCards) do
                    regiments_CurrentClearances:AddLine(v)
                end
            else
                print("ClearanceCards table not found. Das not good")
            end
        end

        function ListViewToTable (rows)
            local data = {}
            for k, v in pairs(rows) do
                table.insert(data, v:GetValue(1))
            end
            return data
        end

        local submitbutton = vgui.Create("DButton", regiments)
        submitbutton:SetPos(regiments:GetWide()*0.28,regiments:GetTall()*0.84)
        submitbutton:SetSize(regiments:GetWide()*0.1,regiments:GetTall()*0.08)
        submitbutton:SetText("Submit Changes")
        submitbutton:SetTextColor(Color(0,0,0))
        submitbutton.DoClick = function()
            Derma_Query("Are you sure you want to update this rank?","Update Rank","Yes",
                function() 
                    IG_WEAPONSTABLEUPDATER = nil
                    IG_OTHERMODELSTABLEUPDATER = nil
                    RunString("IG_WEAPONSTABLEUPDATER = "..weaponstextentry:GetText())
                    RunString("IG_OTHERMODELSTABLEUPDATER = "..othermtextentry:GetText())
                    local colorr = colourtextmix:GetColor()
                    local colorrr = Color(colorr.r,colorr.g,colorr.b)
                    net.Start("igupdaterank")
                        net.WriteString(regiments_List:GetLine(regiments_List:GetSelectedLine()):GetValue(1))
                        net.WriteUInt(ranks_List:GetLine(ranks_List:GetSelectedLine()):GetValue(2),8)
                        net.WriteString(nametextentry:GetText())
                        net.WriteString(rnametextentry:GetText())
                        net.WriteString(regimenttextentry:GetText())
                        net.WriteString(modeltextentry:GetText())
                        net.WriteColor(colorrr)
                        net.WriteUInt(healthtextentry:GetValue(),32)
                        net.WriteTable(IG_WEAPONSTABLEUPDATER)
                        net.WriteString(clearancetextentry:GetOptionText(clearancetextentry:GetSelectedID()))
                        net.WriteUInt(sidetextentry:GetValue(),8)
                        net.WriteUInt(ranktextentry:GetValue(),8)
                        net.WriteTable(IG_OTHERMODELSTABLEUPDATER)
                        net.WriteString(bodytextentry:GetText()) 
                        net.WriteUInt(skintextentry:GetValue(),8)
                        net.WriteUInt(rmovesentry:GetValue(),32)
                        net.WriteUInt(movesentry:GetValue(),32)
                        net.WriteTable(ListViewToTable(regiments_CurrentClearances:GetLines()))
                    net.SendToServer()
                end, "No", function() end)
        end

        local deleterbutton = vgui.Create("DButton", regiments)
        deleterbutton:SetPos(regiments:GetWide()*0.28+submitbutton:GetWide(),regiments:GetTall()*0.84)
        deleterbutton:SetSize(regiments:GetWide()*0.1,regiments:GetTall()*0.08)
        deleterbutton:SetText("Delete Regiment")
        deleterbutton:SetTextColor(Color(0,0,0))
        deleterbutton.DoClick = function()
            Derma_Query("Are you sure you want to delete this regiment?","Delete Regiment","Yes",
                function() 
                    net.Start("igremoveregiment")
                    net.WriteString(regiments_List:GetLine(regiments_List:GetSelectedLine()):GetValue(1))
                    net.SendToServer()
                end, "No", function() end)
        end

        local deletebutton = vgui.Create("DButton", regiments)
        deletebutton:SetPos(regiments:GetWide()*0.28+deleterbutton:GetWide()+submitbutton:GetWide(),regiments:GetTall()*0.84)
        deletebutton:SetSize(regiments:GetWide()*0.1,regiments:GetTall()*0.08)
        deletebutton:SetText("Delete Rank")
        deletebutton:SetTextColor(Color(0,0,0))
        deletebutton.DoClick = function()
            Derma_Query("Are you sure you want to delete this rank?","Delete Rank","Yes",
                function() 
                    if not regiments_List:GetSelectedLine() then LocalPlayer():ChatPrint("Please select a regiment") return end
                    if not ranks_List:GetSelectedLine() then LocalPlayer():ChatPrint("Please select a rank") return end
                    net.Start("igremoverank")
                    net.WriteString(regiments_List:GetLine(regiments_List:GetSelectedLine()):GetValue(1))
                    net.WriteUInt(ranks_List:GetLine(ranks_List:GetSelectedLine()):GetValue(2),8)
                    net.SendToServer()
                end, "No", function() end)
        end


        AdminPanel_Categorys:AddSheet("Regiments/Ranks", regiments, "icon16/cross.png")
        local creater = vgui.Create("DPanel", AdminPanel_Categorys)
        creater:SetSize(AdminPanel:GetWide(),AdminPanel:GetTall())

        local nametext = vgui.Create( "DLabel", creater )
        nametext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.005)
        nametext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        nametext:SetText( "Name" )
        nametext:SetTextColor(Color(0,0,0))
        local nametextentry = vgui.Create( "DTextEntry", creater )
        nametextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.05)
        nametextentry:SetSize(creater:GetWide()*0.35,creater:GetTall()*0.031)
        nametextentry:SetText( "" )
        nametextentry:SetTextColor(Color(0,0,0))

        local rnametext = vgui.Create( "DLabel", creater )
        rnametext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.07)
        rnametext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        rnametext:SetText( "Real Name" )
        rnametext:SetTextColor(Color(0,0,0))
        local rnametextentry = vgui.Create( "DTextEntry", creater )
        rnametextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.11)
        rnametextentry:SetSize(creater:GetWide()*0.35,creater:GetTall()*0.031)
        rnametextentry:SetText( "" )
        rnametextentry:InvalidateParent(false)
        rnametextentry:SetTextColor(Color(0,0,0))

        local regimenttext = vgui.Create( "DLabel", creater )
        regimenttext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.138)
        regimenttext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        regimenttext:SetText( "Regiment" )
        regimenttext:SetTextColor(Color(0,0,0))
        local regimenttextentry = vgui.Create( "DTextEntry", creater )
        regimenttextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.178)
        regimenttextentry:SetSize(creater:GetWide()*0.35,creater:GetTall()*0.031)
        regimenttextentry:SetText( "" )
        regimenttextentry:SetTextColor(Color(0,0,0))

        local modeltext = vgui.Create( "DLabel", creater )
        modeltext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.2)
        modeltext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        modeltext:SetText( "Model" )
        modeltext:SetTextColor(Color(0,0,0))
        local modeltextentry = vgui.Create( "DTextEntry", creater )
        modeltextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.24)
        modeltextentry:SetSize(creater:GetWide()*0.35,creater:GetTall()*0.031)
        modeltextentry:SetText( "" )
        modeltextentry:SetTextColor(Color(0,0,0))
        modeltextentry:SetUpdateOnType(true)

        local healthtext = vgui.Create( "DLabel", creater )
        healthtext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.265)
        healthtext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        healthtext:SetText( "Health" )
        healthtext:SetTextColor(Color(0,0,0))
        local healthtextentry = vgui.Create( "DNumberWang", creater )
        healthtextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.3)
        healthtextentry:SetSize(creater:GetWide()*0.35/5,creater:GetTall()*0.031)
        healthtextentry:SetMin(1)
        healthtextentry:SetMax(999999)
        healthtextentry:SetValue(100)
        healthtextentry:SetTextColor(Color(0,0,0))


        local weaponstext = vgui.Create( "DLabel", creater )
        weaponstext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.32)
        weaponstext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        weaponstext:SetText( "Weapons" )
        weaponstext:SetTextColor(Color(0,0,0))
        local weaponstextentry = vgui.Create( "DTextEntry", creater )
        weaponstextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.36)
        weaponstextentry:SetSize(creater:GetWide()*0.35,creater:GetTall()*0.031)
        weaponstextentry:SetText( "{}" )
        weaponstextentry:SetTextColor(Color(0,0,0))

        local clearancetext = vgui.Create( "DLabel", creater )
        clearancetext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.39)
        clearancetext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        clearancetext:SetText( "Clearance" )
        clearancetext:SetTextColor(Color(0,0,0))
        local clearancetextentry = vgui.Create( "DComboBox", creater )
        clearancetextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.43)
        clearancetextentry:SetSize(creater:GetWide()*0.35,creater:GetTall()*0.031)
        clearancetextentry:SetValue("Clearance")
        clearancetextentry:AddChoice("0")
        clearancetextentry:AddChoice("1")
        clearancetextentry:AddChoice("2")
        clearancetextentry:AddChoice("3")
        clearancetextentry:AddChoice("4")
        clearancetextentry:AddChoice("5")
        clearancetextentry:AddChoice("6")
        clearancetextentry:AddChoice("ALL ACCESS")
        clearancetextentry:AddChoice("AREA ACCESS")
        clearancetextentry:AddChoice("CLASSIFIED")
        clearancetextentry:AddChoice("Imperial Citizen")
        clearancetextentry:SetTextColor(Color(0,0,0))

        local sidetext = vgui.Create( "DLabel", creater )
        sidetext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.455)
        sidetext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        sidetext:SetText( "Side" )
        sidetext:SetTextColor(Color(0,0,0))
        local sidetextentry = vgui.Create( "DNumberWang", creater )
        sidetextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.495)
        sidetextentry:SetSize(creater:GetWide()*0.35/5,creater:GetTall()*0.031)
        sidetextentry:SetMin(0)
        sidetextentry:SetMax(999999)
        sidetextentry:SetValue(1)
        sidetextentry:SetTextColor(Color(0,0,0))

        local ranktext = vgui.Create( "DLabel", creater )
        ranktext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.525)
        ranktext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        ranktext:SetText( "Rank" )
        ranktext:SetTextColor(Color(0,0,0))
        local ranktextentry = vgui.Create( "DNumberWang", creater )
        ranktextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.565)
        ranktextentry:SetSize(creater:GetWide()*0.35/5,creater:GetTall()*0.031)
        ranktextentry:SetMin(1)
        ranktextentry:SetMax(999999)
        ranktextentry:SetValue(1)
        ranktextentry:SetTextColor(Color(0,0,0))

        local othermtext = vgui.Create( "DLabel", creater )
        othermtext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.6)
        othermtext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        othermtext:SetText( "Other Models" )
        othermtext:SetTextColor(Color(0,0,0))
        local othermtextentry = vgui.Create( "DTextEntry", creater )
        othermtextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.64)
        othermtextentry:SetSize(creater:GetWide()*0.35,creater:GetTall()*0.031)
        othermtextentry:SetText( "{}" )
        othermtextentry:SetTextColor(Color(0,0,0))

        local bodytext = vgui.Create( "DLabel", creater )
        bodytext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.68)
        bodytext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        bodytext:SetText( "Bodygroups" )
        bodytext:SetTextColor(Color(0,0,0))
        local bodytextentry = vgui.Create( "DTextEntry", creater )
        bodytextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.72)
        bodytextentry:SetSize(creater:GetWide()*0.35,creater:GetTall()*0.031)
        bodytextentry:SetText( "" )
        bodytextentry:SetTextColor(Color(0,0,0))

        local skintext = vgui.Create( "DLabel", creater )
        skintext:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.76)
        skintext:SetSize(creater:GetWide()*0.5,creater:GetTall()*0.05)
        skintext:SetText( "Skin" )
        skintext:SetTextColor(Color(0,0,0))
        local skintextentry = vgui.Create( "DNumberWang", creater )
        skintextentry:SetPos(creater:GetWide()*0.025,creater:GetTall()*0.8)
        skintextentry:SetSize(creater:GetWide()*0.35/5,creater:GetTall()*0.031)
        skintextentry:SetMin(0)
        skintextentry:SetMax(999999)
        skintextentry:SetValue(0)
        skintextentry:SetTextColor(Color(0,0,0))

        local desiredX, desiredY = nametextentry:GetPos()
        desiredX = desiredX + nametextentry:GetWide() + (0.01 * creater:GetWide())

        local creater_AvailableClearances = vgui.Create("DListView", creater)
        creater_AvailableClearances:AddColumn("Available Clearances")
        creater_AvailableClearances:SetSize(200, 250)
        creater_AvailableClearances:SetPos(desiredX, desiredY)
        for k, v in pairs(clearanceCards) do
            creater_AvailableClearances:AddLine(v)
        end

        local creater_CurrentClearances = vgui.Create("DListView", creater)
        creater_CurrentClearances:AddColumn("Current Clearances")
        creater_CurrentClearances:SetSize(200, 250)
        creater_CurrentClearances:SetPos(desiredX, desiredY + creater_AvailableClearances:GetTall() + (0.01 * creater:GetWide()))

        function creater_AvailableClearances:DoDoubleClick (lineID, line)
            creater_CurrentClearances:AddLine(clearanceCards[lineID])
        end

        function creater_CurrentClearances:DoDoubleClick (lineID, line)
            creater_CurrentClearances:RemoveLine(creater_CurrentClearances:GetSelectedLine())
        end

        local colourtextmix = vgui.Create( "DColorMixer", creater )
        colourtextmix:SetPos(AdminPanel_Categorys:GetWide()*0.7,AdminPanel_Categorys:GetTall()*0.55)
        colourtextmix:SetSize(colourtextmix:GetWide()*0.75,colourtextmix:GetTall()*0.75)
        colourtextmix:SetPalette( true ) 
        colourtextmix:SetAlphaBar( false )
        colourtextmix:SetWangs( true )

        local modeltextview = vgui.Create( "DModelPanel", creater )
        modeltextview:SetPos(AdminPanel_Categorys:GetWide()*0.7,creater:GetTall()*0.01)
        modeltextview:SetSize(creater:GetWide()*0.2,creater:GetTall()*0.55)
        modeltextview:SetModel( "models/props_canal/canalmap001.mdl" )
        modeltextview.Entity:SetColor(Color(0,0,0,0))
        modeltextview:SetFOV(40)
        modeltextview.Angles = Angle( 0, 43, 0 )
        modeltextentry.OnValueChange = function()
            local text = modeltextentry:GetValue()
            if string.EndsWith(text,".mdl") then
                modeltextview:SetModel(text)
            end
        end
        function modeltextview:DragMousePress()
            self.PressX, self.PressY = gui.MousePos()
            self.Pressed = true
        end

        modeltextview.DoDoubleClick = function()
            local BDFrame = vgui.Create("DFrame")
            BDFrame:SetTitle("Kumo's Scuffed Bodygroup Editor")
            BDFrame:Center()
            BDFrame:SetDraggable(false)
            BDFrame:Dock(LEFT)
            BDFrame:SetSize(430,700)

            local bdcontrolspanel = vgui.Create( "DPanelList", BDFrame )
            bdcontrolspanel:EnableVerticalScrollbar( true )
            bdcontrolspanel:Dock( FILL )

            local function bodygroupstostring()
                local bodygroups2 = {}
                for k = 0, modeltextview.Entity:GetNumBodyGroups() - 1 do
                    bodygroups2[k] = modeltextview.Entity:GetBodygroup(k)
                end
                return string.sub(table.concat(bodygroups2),2)
            end

            local function UpdateBodyGroups( pnl, val )
            if ( pnl.type == "bgroup" ) then

                modeltextview.Entity:SetBodygroup( pnl.typenum, math.Round( val ) )
                bodytextentry:SetText(bodygroupstostring())

            elseif ( pnl.type == "skin" ) then

                modeltextview.Entity:SetSkin( math.Round( val ) )
                skintextentry:SetValue(math.Round( val ))

            end
        end

        local function MakeNiceName( str )
            local newname = {}

            for _, s in pairs( string.Explode( "_", str ) ) do
                if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
                table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) -- Ugly way to capitalize first letters.
            end

            return string.Implode( " ", newname )
        end

        local function RebuildBodygroupTab()
            bdcontrolspanel:Clear()

            local nskins = modeltextview.Entity:SkinCount() - 1
            if ( nskins > 0 ) then
                local skins = vgui.Create( "DNumSlider" )
                skins:Dock( TOP )
                skins:SetText( "Skin" )
                skins:SetDark( true )
                skins:SetTall( 50 )
                skins:SetDecimals( 0 )
                skins:SetMax( nskins )
                skins:SetValue( modeltextview.Entity:GetSkin() )
                skins.type = "skin"
                skins.OnValueChanged = UpdateBodyGroups

                bdcontrolspanel:AddItem( skins )

            end

            for k = 0, modeltextview.Entity:GetNumBodyGroups() - 1 do
                if ( modeltextview.Entity:GetBodygroupCount( k ) <= 1 ) then continue end

                local bgroup = vgui.Create( "DNumSlider" )
                bgroup:Dock( TOP )
                bgroup:SetText( MakeNiceName( modeltextview.Entity:GetBodygroupName( k ) ) )
                bgroup:SetDark( true )
                bgroup:SetTall( 50 )
                bgroup:SetDecimals( 0 )
                bgroup.type = "bgroup"
                bgroup.typenum = k
                bgroup:SetMax( modeltextview.Entity:GetBodygroupCount( k ) - 1 )
                bgroup:SetValue( modeltextview.Entity:GetBodygroup(k) )
                bgroup.OnValueChanged = UpdateBodyGroups

                bdcontrolspanel:AddItem( bgroup )
            end
        end
        RebuildBodygroupTab()
        end

        function modeltextview:DragMouseRelease() self.Pressed = false end
        function modeltextview:LayoutEntity( ent )
            if ( modeltextview.Pressed ) then
                local mx, my = gui.MousePos()
                self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

                self.PressX, self.PressY = gui.MousePos()
            end

            ent:SetAngles( self.Angles )
        end


        local submitrbutton2 = vgui.Create("DButton", creater)
        submitrbutton2:Dock(BOTTOM)
        submitrbutton2:SetSize(submitrbutton2:GetWide()*1.75,submitrbutton2:GetTall()*2.5)
        submitrbutton2:SetText("Create Regiment/Rank")
        submitrbutton2:SetTextColor(Color(0,0,0))
        submitrbutton2.DoClick = function()
            Derma_Query("Are you sure you want to update this rank?","Update Rank","Yes",
                function() 
                    IG_WEAPONSTABLEUPDATER = nil
                    IG_OTHERMODELSTABLEUPDATER = nil
                    RunString("IG_WEAPONSTABLEUPDATER = "..weaponstextentry:GetText())
                    RunString("IG_OTHERMODELSTABLEUPDATER = "..othermtextentry:GetText())
                    local colorr = colourtextmix:GetColor()
                    local colorrr = Color(colorr.r,colorr.g,colorr.b)
                    net.Start("igaddrank")
                        net.WriteString(nametextentry:GetText())
                        net.WriteString(rnametextentry:GetText())
                        net.WriteString(regimenttextentry:GetText())
                        net.WriteString(modeltextentry:GetText())
                        net.WriteColor(colorrr)
                        net.WriteUInt(healthtextentry:GetValue(),32)
                        net.WriteTable(IG_WEAPONSTABLEUPDATER)
                        net.WriteString(clearancetextentry:GetOptionText(clearancetextentry:GetSelectedID()))
                        net.WriteUInt(sidetextentry:GetValue(),8)
                        net.WriteUInt(ranktextentry:GetValue(),8)
                        net.WriteTable(IG_OTHERMODELSTABLEUPDATER)
                        net.WriteString(bodytextentry:GetText()) 
                        net.WriteUInt(skintextentry:GetValue(),8)
                        -- net.WriteUInt(rmovesentry:GetValue(),32) -- Walk
                        -- net.WriteUInt(movesentry:GetValue(),32) -- Run
                        net.WriteUInt(240, 32) -- Sprint Speed. For some reason the create menu doesn't have a setting for this
                        net.WriteUInt(160, 32) -- Walk Speed. For some reason the create menu doesn't have a setting for this
                        net.WriteTable(ListViewToTable(creater_CurrentClearances:GetLines()))
                    net.SendToServer()
                end, "No", function() end)
        end

        AdminPanel_Categorys:AddSheet("Create New", creater, "icon16/cross.png")

        if not LocalPlayer():IsSuperAdmin() then
            AdminPanel:Hide()
        end

        --------------------------------------------------------------------------
        -- Button 1
        local MainPanelHeader_Menu_B1 = vgui.Create("DImageButton", MainPanelHeader)
        MainPanelHeader_Menu_B1:SetSize(MainPanelHeader:GetWide() / 10, MainPanelHeader:GetTall() * 0.7)
        MainPanelHeader_Menu_B1:SetPos((MainPanelHeader:GetWide() / 2) - (MainPanelHeader:GetWide() / 10) * 2, MainPanelHeader:GetTall() - MainPanelHeader_Menu_B1:GetTall())
        MainPanelHeader_Menu_B1:SetImage(bgImages["Menu_1"])

        MainPanelHeader_Menu_B1.DoClick = function()
            MainPanelHeader_Menu_B1_active = true
            MainPanelHeader_Menu_B2_active = false
            MainPanelHeader_Menu_B3_active = false
            MainPanelHeader_Menu_B4_active = false
            AdminPanel:Hide()
            PromotionPanel:Hide()
            RegimentPanel:Hide()
            HomePanel:Show()
        end

        MainPanelHeader_Menu_B1.Paint = function(self)
            if MainPanelHeader_Menu_B1_active == true then
                self:SetImage(bgImages["Menu_sel_1"])
            elseif self:IsHovered() then
                self:SetImage(bgImages["Menu_hov_1"])
            else
                self:SetImage(bgImages["Menu_1"])
            end
        end

        -- Button 2
        local MainPanelHeader_Menu_B2 = vgui.Create("DImageButton", MainPanelHeader)
        MainPanelHeader_Menu_B2:SetSize(MainPanelHeader:GetWide() / 10, MainPanelHeader:GetTall() * 0.7)
        MainPanelHeader_Menu_B2:SetPos((MainPanelHeader:GetWide() / 2) - (MainPanelHeader:GetWide() / 10), MainPanelHeader:GetTall() - MainPanelHeader_Menu_B2:GetTall())
        MainPanelHeader_Menu_B2:SetImage(bgImages["Menu_2"])

        MainPanelHeader_Menu_B2.DoClick = function()
            MainPanelHeader_Menu_B1_active = false
            MainPanelHeader_Menu_B2_active = true
            MainPanelHeader_Menu_B3_active = false
            MainPanelHeader_Menu_B4_active = false
            AdminPanel:Hide()
            PromotionPanel:Show()
            RegimentPanel:Hide()
            HomePanel:Hide()
        end

        MainPanelHeader_Menu_B2.Paint = function(self)
            if MainPanelHeader_Menu_B2_active == true then
                self:SetImage(bgImages["Menu_sel_2"])
            elseif self:IsHovered() then
                self:SetImage(bgImages["Menu_hov_2"])
            else
                self:SetImage(bgImages["Menu_2"])
            end
        end

        -- Button 3
        local MainPanelHeader_Menu_B3 = vgui.Create("DImageButton", MainPanelHeader)
        MainPanelHeader_Menu_B3:SetSize(MainPanelHeader:GetWide() / 10, MainPanelHeader:GetTall() * 0.7)
        MainPanelHeader_Menu_B3:SetPos((MainPanelHeader:GetWide() / 2), MainPanelHeader:GetTall() - MainPanelHeader_Menu_B3:GetTall())
        MainPanelHeader_Menu_B3:SetImage(bgImages["Menu_3"])

        MainPanelHeader_Menu_B3.DoClick = function()
            MainPanelHeader_Menu_B1_active = false
            MainPanelHeader_Menu_B2_active = false
            MainPanelHeader_Menu_B3_active = true
            MainPanelHeader_Menu_B4_active = false
            AdminPanel:Hide()
            PromotionPanel:Hide()
            RegimentPanel:Show()
            HomePanel:Hide()
        end

        MainPanelHeader_Menu_B3.Paint = function(self)
            if MainPanelHeader_Menu_B3_active == true then
                self:SetImage(bgImages["Menu_sel_3"])
            elseif self:IsHovered() then
                self:SetImage(bgImages["Menu_hov_3"])
            else
                self:SetImage(bgImages["Menu_3"])
            end
        end

        -- Button 4
        local MainPanelHeader_Menu_B4 = vgui.Create("DImageButton", MainPanelHeader)
        MainPanelHeader_Menu_B4:SetSize(MainPanelHeader:GetWide() / 10, MainPanelHeader:GetTall() * 0.7)
        MainPanelHeader_Menu_B4:SetPos((MainPanelHeader:GetWide() / 2) + (MainPanelHeader:GetWide() / 10), MainPanelHeader:GetTall() - MainPanelHeader_Menu_B4:GetTall())
        MainPanelHeader_Menu_B4:SetImage(bgImages["Menu_4"])

        MainPanelHeader_Menu_B4.DoClick = function()
            MainPanelHeader_Menu_B1_active = false
            MainPanelHeader_Menu_B2_active = false
            MainPanelHeader_Menu_B3_active = false
            MainPanelHeader_Menu_B4_active = true
            AdminPanel:Show()
            PromotionPanel:Hide()
            RegimentPanel:Hide()
            HomePanel:Hide()
        end

        MainPanelHeader_Menu_B4.Paint = function(self)
            if MainPanelHeader_Menu_B4_active == true then
                self:SetImage(bgImages["Menu_sel_4"])
            elseif self:IsHovered() then
                self:SetImage(bgImages["Menu_hov_4"])
            else
                self:SetImage(bgImages["Menu_4"])
            end
        end

        if LocalPlayer():GetRank() < 4 then
            PromotionPanel:Hide()
            MainPanelHeader_Menu_B2:Hide()
        end

        if not LocalPlayer():IsAdmin() then
            MainPanelHeader_Menu_B3:Hide()
            MainPanelHeader_Menu_B4:Hide()
        end

        -------------------------------------------------------------------------- NET STUFF
        MainPanel:SetVisible(false)

        net.Receive("OpenPromotionMenu", function()
            if MainPanel:IsVisible() then
                MainPanel:SetVisible(false)
            else
                MainPanel:SetVisible(true)
            end
        end)

        net.Receive("UpdateMenu", function()
            Regiment_Player_List:Clear()

            if Regiment_TSearch:GetValue() ~= "" then
                for k, v in pairs(player.GetAll()) do
                    if string.match(string.lower(v:Nick()), string.lower(Regiment_TSearch:GetValue())) then
                        Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
                        Regiment_Player_List:SortByColumn(1, false)
                    end
                end
            else
                for k, v in pairs(player.GetAll()) do
                    Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
                    Regiment_Player_List:SortByColumn(1, false)
                end
            end
            Regiment_Regiment_List:Clear()
            for k, v in pairs(TeamTable) do
                Regiment_Regiment_List:AddLine(k, k)
            end

            Promotion_Player_List:Clear()
            Promotion_Player_List:AddLine(LocalPlayer():Nick(), LocalPlayer():SteamID(), LocalPlayer():GetRegiment(), LocalPlayer():GetRankName())
            Promotion_Player_List:SortByColumn(1, false)

            if LocalPlayer():GetRank() >= 4 then
                for k, v in pairs(player.GetAll()) do
                    if v == LocalPlayer() then continue end

                    if v:GetRank() == 0 then
                        Promotion_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
                        Promotion_Player_List:SortByColumn(1, false)
                    end

                    if LocalPlayer():GetRank() >= 10 then
                        if v:GetRegiment() == LocalPlayer():GetRegiment() and v:GetRank() + 1 <= LocalPlayer():GetRank() then
                            Promotion_Player_List:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetRankName())
                            Promotion_Player_List:SortByColumn(1, false)
                        end
                    end
                end
            end

            if LocalPlayer():GetRank() > 4 then
                MainPanelHeader_Menu_B2:Show()
            elseif LocalPlayer():GetRank() <= 4 then
                MainPanelHeader_Menu_B2:Hide()
            end

            if LocalPlayer():GetRank() < 10 then
                Promotion_BRemoveRank:Hide()
                Promotion_BRemoveRankTXT:Hide()
            elseif LocalPlayer():GetRank() > 9 then
                Promotion_BRemoveRank:Show()
                Promotion_BRemoveRankTXT:Show()
            end

            if not LocalPlayer():IsAdmin() then
                MainPanelHeader_Menu_B3:Hide()
            elseif LocalPlayer():IsAdmin() then
                MainPanelHeader_Menu_B3:Show()
            end

            if not LocalPlayer():IsSuperAdmin() then
                MainPanelHeader_Menu_B4:Hide()
            elseif LocalPlayer():IsSuperAdmin() then
                MainPanelHeader_Menu_B4:Show()
                regiments_List:Clear()
                ranks_List:Clear()
                for k, v in pairs(TeamTable) do
                    regiments_List:AddLine(k)
                end
            end
        end)
    end
else
    local function buttonForums(ply)
        ply:SendLua([[gui.OpenURL("http://imperialgamingau.invisionzone.com/")]])
    end

    concommand.Add("buttonForums", buttonForums)

    local function buttonDonate(ply)
        ply:SendLua([[gui.OpenURL("http://imperialgaming.net/donate/")]])
    end

    concommand.Add("buttonDonate", buttonDonate)

    local function buttonTeamspeak(ply)
        ply:SendLua([[gui.OpenURL("http://invite.teamspeak.com/ts3.imperialgaming.net")]])
    end

    concommand.Add("buttonTeamspeak", buttonTeamspeak)
    ------MENU OPERATIONS
    util.AddNetworkString("OpenPromotionMenu")
    util.AddNetworkString("SetPlayerRegiment")
    util.AddNetworkString("SetPlayerRank")
    util.AddNetworkString("UpdateMenu")
    util.AddNetworkString("PromoteUser")
    util.AddNetworkString("DemoteUser")
    util.AddNetworkString("RemoveBySteamID")
    util.AddNetworkString("PromoteBySteamID")
    util.AddNetworkString("DemoteBySteamID")

    hook.Add("ShowTeam", "OpenPromotionMenu", function(ply)
        net.Start("UpdateMenu")
        net.Send(ply)
        net.Start("OpenPromotionMenu")
        net.Send(ply)
    end)

    net.Receive("PromoteUser", function(len, ply)
        if not ply:IsValid() then return end
        --if ply:GetRank() < 4 then return end
        local user = net.ReadEntity()

        if ply:GetRank() >= 10 or ply:GetRegiment() == "Inferno Squad" then
            if user == ply then return end

            if user:GetRank() == 0 then
                ulx.fancyLogAdmin(ply, "#A promoted #T from recruit", user)
                local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)
                user:SetRegiment("6th Infantry Division")
                user:SetRank(1)
                user:SetModel(TeamTable["6th Infantry Division"][1].Model)
                user:SetHUDModel(TeamTable["6th Infantry Division"][1].Model)
                user:StripWeapons()
            else
                if ply:GetRegiment() == "Inferno Squad" or user:GetRegiment() ~= ply:GetRegiment() or user:GetRank() + 1 >= ply:GetRank() then return end
                user:SetRank(user:GetRank() + 1)
                user:SetModel(user:GetJobTable().Model)
                user:SetHUDModel(user:GetJobTable().Model)
                user:StripWeapons()
                ulx.fancyLogAdmin(ply, "#A promoted #T to [#s] #s in #s", user, user:GetRank(), user:GetRankName(), user:GetRegiment())
                local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)
            end

            local weps = user:GetJobTable().Weapons

            for i = 1, #weps do
                user:Give(weps[i])
            end

            user:Give("weapon_empty_hands")
            user:Give("climb_swep2")
            user:Give("bkeycard")
            weps = user:GetWeapons()

            for i = 1, #weps do
                user:GiveAmmo(256, weps[i]:Ammo1(), true)
            end

            timer.Simple(0.3, function()
                net.Start("UpdateMenu")
                net.Send(ply)
            end)
        elseif (ply:GetRank() > 4 or ply:GetJobTable().Clearance == "2") and user:GetRank() == 0 then
            user:SetRegiment("6th Infantry Division")
            user:SetRank(1)
            user:SetModel(TeamTable["6th Infantry Division"][1].Model)
            user:SetHUDModel(TeamTable["6th Infantry Division"][1].Model)
            user:StripWeapons()
            ulx.fancyLogAdmin(ply, "#A promoted #T from recruit", user)
            local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)
            local weps = user:GetJobTable().Weapons

            for i = 1, #weps do
                user:Give(weps[i])
            end

            user:Give("weapon_empty_hands")
            user:Give("climb_swep2")
            user:Give("bkeycard")
            weps = user:GetWeapons()

            for i = 1, #weps do
                user:GiveAmmo(256, weps[i]:Ammo1(), true)
            end

            timer.Simple(0.3, function()
                net.Start("UpdateMenu")
                net.Send(ply)
            end)
        end
    end)

    net.Receive("DemoteUser", function(len, ply)
        if not ply:IsValid() then return end
        if ply:GetRank() < 10 then return end
        local user = net.ReadEntity()
        if not user then return end
        if user == ply or user:GetRegiment() ~= ply:GetRegiment() or user:GetRank() >= ply:GetRank() then return end

        if ply:GetRank() > 10 then
            if user:GetRank() == 1 then
                ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, user:GetRegiment())
                local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                user:SetRegiment("6th Infantry Division")
                user:SetRank(1)
                user:SetModel(user:GetJobTable().Model)
                user:SetHUDModel(user:GetJobTable().Model)
                user:StripWeapons()
            else
                user:SetRank(user:GetRank() - 1)
                --user:SetTeam(user:Team() - 1) -- Why is this here? It seems to be double demoting people/setting them to an entire different regiment if they are demoted from PFC
                user:SetModel(user:GetJobTable().Model)
                user:SetHUDModel(user:GetJobTable().Model)
                user:StripWeapons()
                ulx.fancyLogAdmin(ply, "#A demoted #T to [#s] #s in #s", user, user:GetRank(), user:GetRankName(), user:GetRegiment())
                local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                local weps = user:GetJobTable().Weapons

                for i = 1, #weps do
                    user:Give(weps[i])
                end

                user:Give("weapon_empty_hands")
                user:Give("climb_swep2")
                user:Give("bkeycard")
                weps = user:GetWeapons()

                for i = 1, #weps do
                    user:GiveAmmo(256, weps[i]:Ammo1(), true)
                end
            end

            timer.Simple(0.3, function()
                net.Start("UpdateMenu")
                net.Send(ply)
            end)
        end
    end)

    net.Receive("SetPlayerRegiment", function(len, ply)
        if not ply:IsValid() or not ply:IsAdmin() then return end
        local regiment = net.ReadString()
        local tbl = TeamTable[regiment][1]
        if not tbl then 
            tbl = TeamTable[regiment][0]
        end
        if tbl == nil then return end
        user = net.ReadEntity()
        user:SetRegiment(regiment)
        user:SetModel(tbl.Model)
        user:SetHUDModel(tbl.Model)
        user:StripWeapons()
        ulx.fancyLogAdmin(ply, "#A set the regiment of #T to #s", user, user:GetRegiment())
        local MooseSetPlayerRegiment = hook.Call("MooseSetPlayerRegiment", GAMEMODE, ply, user, user:GetRegiment())
        local weps = tbl.Weapons

        for i = 1, #weps do
            user:Give(weps[i])
        end

        user:SetBodyGroups(tbl.Bodygroups)
        user:SetSkin(tonumber(tbl.Skin))
        user:Give("weapon_empty_hands")
        user:Give("climb_swep2")
        user:Give("bkeycard")

        if user:IsAdmin() then
            user:Give("weapon_physgun")
            user:Give("gmod_tool")
        end

        weps = user:GetWeapons()

        for i = 1, #weps do
            if weps[i]:GetClass() == "fas2_m67" then continue end
            user:GiveAmmo(256, weps[i]:GetPrimaryAmmoType(), true)
        end

        timer.Simple(0.3, function()
            net.Start("UpdateMenu")
            net.Send(ply)
        end)
    end)

    net.Receive("SetPlayerRank", function(len, ply)
        if not ply:IsValid() then return end
        if not ply:IsAdmin() then return end
        local rank = net.ReadUInt(10)
        local user = net.ReadEntity()
        local tbl = TeamTable[user:GetRegiment()][rank]
        if tbl == nil then return end
        user:SetRank(rank)

        if type(tbl.Model) == "table" then
            user:SetModel(table.Random(tbl.Model))
        else
            user:SetModel(tbl.Model)
            user:SetHUDModel(tbl.Model)
        end

        user:SetBodyGroups(tbl.Bodygroups)
        user:SetSkin(tonumber(tbl.Skin))
        ulx.fancyLogAdmin(ply, "#A set the rank of #T to [#s] #s in #s", user, user:GetRank(), user:GetRankName(), user:GetRegiment())
        local MooseSetPlayerRank = hook.Call("MooseSetPlayerRank", GAMEMODE, ply, user, user:GetRank())

        timer.Simple(0.3, function()
            net.Start("UpdateMenu")
            net.Send(ply)
        end)
    end)

    net.Receive("RemoveBySteamID", function(len, ply)
        if not ply:IsValid() then return end
        if ply:GetRank() <= 9 and not ply:IsSuperAdmin() then return end
        local steamid = net.ReadString()
        local value = 1
        if not (steamid) then return end

        if string.match(steamid, "STEAM_") then
            if (player.GetBySteamID(steamid)) then
                local user = player.GetBySteamID(steamid)
                if user == ply or user:GetRegiment() ~= ply:GetRegiment() and not ply:IsSuperAdmin() or user:GetRank() >= ply:GetRank() and not ply:IsSuperAdmin() then return end
                ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, user:GetRegiment())
                user:SetRegiment("6th Infantry Division")
                user:SetRank(1)
                user:SetModel(user:GetJobTable().Model)
                user:SetHUDModel(user:GetJobTable().Model)
                user:StripWeapons()
            else
                local steamid64 = util.SteamIDTo64(steamid)
                ig_fwk_db:PrepareQuery("SELECT regiment, rank FROM igdata WHERE steamid64 = " .. sql.SQLStr(steamid64), function(query, status, data)
                    local val = data[1]
                    if val ~= nil then
                        if val.regiment == ply:GetRegiment() and val.rank < ply:GetRank() then
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET regiment = '6th Infantry Division',rank = 1 WHERE steamid64 = "..steamid64)
                            ulx.fancyLogAdmin(ply, "#A kicked " .. steamid64 .. " from the regiment #s", val.regiment)
                        elseif ply:IsSuperAdmin() then
                            ulx.fancyLogAdmin(ply, "#A kicked " .. steamid64 .. " from the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET regiment = '6th Infantry Division',rank = 1 WHERE steamid64 = "..steamid64)
                        else
                            ply:ChatPrint("This player is not in your regiment or outranks you")
                        end
                    else
                        ply:ChatPrint("This player does not exist, double check the steamid")
                    end
                end)
            end
        elseif tonumber(steamid) ~= nil then
            if (player.GetBySteamID64(steamid)) then
                local user = player.GetBySteamID64(steamid)
                if user == ply or user:GetRegiment() ~= ply:GetRegiment() and not ply:IsSuperAdmin() or user:GetRank() >= ply:GetRank() and not ply:IsSuperAdmin() then return end
                ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, user:GetRegiment())
                user:SetRegiment("6th Infantry Division")
                user:SetRank(1)
                user:SetModel(user:GetJobTable().Model)
                user:SetHUDModel(user:GetJobTable().Model)
                user:StripWeapons()
            else
                ig_fwk_db:PrepareQuery("SELECT regiment, rank FROM igdata WHERE steamid64 = " .. sql.SQLStr(steamid), function(query, status, data)
                    local val = data[1]
                    if val ~= nil then
                        if val.regiment == ply:GetRegiment() and val.rank < ply:GetRank() then
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET regiment = '6th Infantry Division',rank = 1 WHERE steamid64 = "..steamid)
                            ulx.fancyLogAdmin(ply, "#A kicked " .. steamid .. " from the regiment #s", val.regiment)
                        elseif ply:IsSuperAdmin() then
                            ulx.fancyLogAdmin(ply, "#A kicked " .. steamid .. " from the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET regiment = '6th Infantry Division',rank = 1 WHERE steamid64 = "..steamid)
                        else
                            ply:ChatPrint("This player is not in your regiment or outranks you")
                        end
                    else
                        ply:ChatPrint("This player does not exist, double check the steamid")
                    end
                end)
            end
        else
            ply:ChatPrint("Invalid STEAMID Given")
        end

        timer.Simple(0.3, function()
            net.Start("UpdateMenu")
            net.Send(ply)
        end)
    end)

    net.Receive("PromoteBySteamID", function(len, ply)
        if not ply:IsValid() then return end
        if ply:GetRank() <= 9 and not ply:IsSuperAdmin() then return end
        local steamid = net.ReadString()
        if not (steamid) then return end

        if string.match(steamid, "STEAM_") then
            if (player.GetBySteamID(steamid)) then
                local user = player.GetBySteamID(steamid)
                if user:GetRegiment() ~= ply:GetRegiment() or user:GetRank() + 1 >= ply:GetRank() and not ply:IsSuperAdmin() then return end
                user:SetRank(user:GetRank() + 1)
                user:SetTeam(user:Team() + 1)
                user:SetModel(user:GetJobTable().Model)
                user:SetHUDModel(user:GetJobTable().Model)
                user:StripWeapons()
                ulx.fancyLogAdmin(ply, "#A promoted #T to [#s] #s in #s", user, user:GetRank(), user:GetRankName(), user:GetRegiment())
                local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)
                local weps = user:GetJobTable().Weapons

                for i = 1, #weps do
                    user:Give(weps[i])
                end

                user:Give("weapon_empty_hands")
                user:Give("climb_swep2")
                user:Give("bkeycard")
                weps = user:GetWeapons()

                for i = 1, #weps do
                    user:GiveAmmo(256, weps[i]:Ammo1(), true)
                end
            else
                local steamid64 = util.SteamIDTo64(steamid)
                ig_fwk_db:PrepareQuery("SELECT regiment, rank FROM igdata WHERE steamid64 = " .. sql.SQLStr(steamid64), function(query, status, data)
                    local val = data[1]

                    if val ~= nil then
                        if val.regiment == ply:GetRegiment() and val.rank + 1 < ply:GetRank() then
                            ulx.fancyLogAdmin(ply, "#A promoted " .. steamid64 .. " in the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET rank = '"..(val.rank+1).."' WHERE steamid64 = "..steamid64)
                        elseif ply:IsSuperAdmin() then
                            ulx.fancyLogAdmin(ply, "#A promoted " .. steamid64 .. " in the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET rank = '"..(val.rank+1).."' WHERE steamid64 = "..steamid64)
                        else
                            ply:ChatPrint("This player is not in your regiment or outranks you")
                        end
                    else
                        ply:ChatPrint("This player does not exist, double check the steamid")
                    end
                end)
            end
        elseif tonumber(steamid) ~= nil then
            if (player.GetBySteamID64(steamid)) then
                local user = player.GetBySteamID64(steamid)
                if user:GetRegiment() ~= ply:GetRegiment() or user:GetRank() + 1 >= ply:GetRank() and not ply:IsSuperAdmin() then return end
                user:SetRank(user:GetRank() + 1)
                user:SetTeam(user:Team() + 1)
                user:SetModel(user:GetJobTable().Model)
                user:SetHUDModel(user:GetJobTable().Model)
                user:StripWeapons()
                ulx.fancyLogAdmin(ply, "#A promoted #T to [#s] #s in #s", user, user:GetRank(), user:GetRankName(), user:GetRegiment())
                local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)
                local weps = user:GetJobTable().Weapons

                for i = 1, #weps do
                    user:Give(weps[i])
                end

                user:Give("weapon_empty_hands")
                user:Give("climb_swep2")
                user:Give("bkeycard")
                weps = user:GetWeapons()

                for i = 1, #weps do
                    user:GiveAmmo(256, weps[i]:Ammo1(), true)
                end
            else
                ig_fwk_db:PrepareQuery("SELECT regiment, rank FROM igdata WHERE steamid64 = " .. sql.SQLStr(steamid), function(query, status, data)
                    local val = data[1]

                    if val ~= nil then
                        if val.regiment == ply:GetRegiment() and val.rank + 1 < ply:GetRank() then
                            ulx.fancyLogAdmin(ply, "#A promoted " .. steamid .. " in the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET rank = '"..(val.rank+1).."' WHERE steamid64 = "..steamid)
                        elseif ply:IsSuperAdmin() then
                            ulx.fancyLogAdmin(ply, "#A promoted " .. steamid .. " in the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET rank = '"..(val.rank+1).."' WHERE steamid64 = "..steamid)
                        else
                            ply:ChatPrint("This player is not in your regiment or outranks you")
                        end
                    else
                        ply:ChatPrint("This player does not exist, double check the steamid")
                    end
                end)
            end
        else
            ply:ChatPrint("Invalid STEAMID Given")
        end

        timer.Simple(0.3, function()
            net.Start("UpdateMenu")
            net.Send(ply)
        end)
    end)

    net.Receive("DemoteBySteamID", function(len, ply)
        if not ply:IsValid() then return end
        if ply:GetRank() <= 9 and not ply:IsSuperAdmin() then return end
        local steamid = net.ReadString()
        if not (steamid) then return end

        if string.match(steamid, "STEAM_") then
            if (player.GetBySteamID(steamid)) then
                local user = player.GetBySteamID(steamid)
                if user == ply or user:GetRegiment() ~= ply:GetRegiment() or user:GetRank() >= ply:GetRank() then return end

                if ply:GetRank() > 10 then
                    if user:GetRank() == 1 then
                        ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, user:GetRegiment())
                        local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                        user:SetRegiment("6th Infantry Division")
                        user:SetRank(1)
                        user:SetModel(TeamTable["6th Infantry Division"][1].Model)
                        user:SetHUDModel(TeamTable["6th Infantry Division"][1].Model)
                        user:StripWeapons()
                    else
                        user:SetRank(user:GetRank() - 1)
                        user:SetTeam(user:Team() - 1)
                        user:SetModel(user:GetJobTable().Model)
                        user:SetHUDModel(user:GetJobTable().Model)
                        user:StripWeapons()
                        ulx.fancyLogAdmin(ply, "#A demoted #T to [#s] #s in #s", user, user:GetRank(), user:GetRankName(), user:GetRegiment())
                        local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                        local weps = user:GetJobTable().Weapons

                        for i = 1, #weps do
                            user:Give(weps[i])
                        end

                        user:Give("weapon_empty_hands")
                        user:Give("climb_swep2")
                        user:Give("bkeycard")
                        weps = user:GetWeapons()

                        for i = 1, #weps do
                            user:GiveAmmo(256, weps[i]:Ammo1(), true)
                        end
                    end

                    timer.Simple(0.3, function()
                        net.Start("UpdateMenu")
                        net.Send(ply)
                    end)
                end
            else
                local steamid64 = util.SteamIDTo64(steamid)
                ig_fwk_db:PrepareQuery("SELECT regiment, rank FROM igdata WHERE steamid64 = " .. sql.SQLStr(steamid64), function(query, status, data)
                    local val = data[1]

                    if val ~= nil then
                        if val.regiment == ply:GetRegiment() and val.rank < ply:GetRank() then
                            ulx.fancyLogAdmin(ply, "#A promoted " .. steamid64 .. " in the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET rank = '"..(val.rank-1).."' WHERE steamid64 = "..steamid64)
                        elseif ply:IsSuperAdmin() then
                            ulx.fancyLogAdmin(ply, "#A promoted " .. steamid64 .. " in the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET rank = '"..(val.rank-1).."' WHERE steamid64 = "..steamid64)
                        else
                            ply:ChatPrint("This player is not in your regiment or outranks you")
                        end
                    else
                        ply:ChatPrint("This player does not exist, double check the steamid")
                    end
                end)
            end
        elseif tonumber(steamid) ~= nil then
            if (player.GetBySteamID64(steamid)) then
                local user = player.GetBySteamID64(steamid)
                if user == ply or user:GetRegiment() ~= ply:GetRegiment() or user:GetRank() >= ply:GetRank() then return end

                if ply:GetRank() > 10 then
                    if user:GetRank() == 1 then
                        ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, user:GetRegiment())
                        local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                        user:SetRegiment("6th Infantry Division")
                        user:SetRank(1)
                        user:SetModel(TeamTable["6th Infantry Division"][1].Model)
                        user:SetHUDModel(TeamTable["6th Infantry Division"][1].Model)
                        user:StripWeapons()
                    else
                        user:SetRank(user:GetRank() - 1)
                        user:SetTeam(user:Team() - 1)
                        user:SetModel(user:GetJobTable().Model)
                        user:SetHUDModel(user:GetJobTable().Model)
                        user:StripWeapons()
                        ulx.fancyLogAdmin(ply, "#A demoted #T to [#s] #s in #s", user, user:GetRank(), user:GetRankName(), user:GetRegiment())
                        local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                        local weps = user:GetJobTable().Weapons

                        for i = 1, #weps do
                            user:Give(weps[i])
                        end

                        user:Give("weapon_empty_hands")
                        user:Give("climb_swep2")
                        user:Give("bkeycard")
                        weps = user:GetWeapons()

                        for i = 1, #weps do
                            user:GiveAmmo(256, weps[i]:Ammo1(), true)
                        end
                    end

                    timer.Simple(0.3, function()
                        net.Start("UpdateMenu")
                        net.Send(ply)
                    end)
                end
            else
                ig_fwk_db:PrepareQuery("SELECT regiment, rank FROM igdata WHERE steamid64 = " .. sql.SQLStr(steamid), function(query, status, data)
                    local val = data[1]

                    if val ~= nil then
                        if val.regiment == ply:GetRegiment() and val.rank < ply:GetRank() then
                            ulx.fancyLogAdmin(ply, "#A promoted " .. steamid .. " in the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET rank = '"..(val.rank-1).."' WHERE steamid64 = "..steamid)
                        elseif ply:IsSuperAdmin() then
                            ulx.fancyLogAdmin(ply, "#A promoted " .. steamid .. " in the regiment #s", val.regiment)
                            ig_fwk_db:PrepareQuery("UPDATE igdata SET rank = '"..(val.rank-1).."' WHERE steamid64 = "..steamid)
                        else
                            ply:ChatPrint("This player is not in your regiment or outranks you")
                        end
                    else
                        ply:ChatPrint("This player does not exist, double check the steamid")
                    end
                end)
            end
        else
            ply:ChatPrint("Invalid STEAMID Given")
        end

        timer.Simple(0.3, function()
            net.Start("UpdateMenu")
            net.Send(ply)
        end)
    end)
end
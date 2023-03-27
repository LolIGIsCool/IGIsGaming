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
                local HomePanel_Col_Lis_1 = vgui.Create( "DCheckBoxLabel" )
                HomePanel_Col_Lis_1:SetText( "Mute Vehicle Sounds" )
                --HomePanel_Col_Lis_1:SetConVar( "moose_muteships" )
                --HomePanel_Col_Lis_1:SetValue( 1 )
                HomePanel_Col_Lis_1:SizeToContents()
                HomePanel_CollapseList:AddItem( HomePanel_Col_Lis_1 )

                function HomePanel_Col_Lis_1:Paint(w, h)
                    surface.SetDrawColor(colorPallete["First"])
                    surface.DrawRect(0, 0, w, h)
                end

                function HomePanel_Col_Lis_1:OnChange( bVal )
                    if ( bVal ) then
                        LocalPlayer():ConCommand( "moose_muteships 1")
                        LocalPlayer():ConCommand( "stopsound" )
                    else
                        LocalPlayer():ConCommand( "moose_muteships 0")
                        LocalPlayer():ConCommand( "stopsound" )
                    end
                end

                local HomePanel_Col_Lis_2 = vgui.Create( "DCheckBoxLabel" )
                HomePanel_Col_Lis_2:SetText( "Toggle Chat Timestamps" )
                HomePanel_Col_Lis_2:SizeToContents()
                HomePanel_CollapseList:AddItem( HomePanel_Col_Lis_2 )

                function HomePanel_Col_Lis_2:Paint(w, h)
                    surface.SetDrawColor(colorPallete["First"])
                    surface.DrawRect(0, 0, w, h)
                end

                function HomePanel_Col_Lis_2:OnChange( bVal )
                    if ( bVal ) then
                        LocalPlayer():ConCommand( "kumo_chatstamp 1")
                    else
                        LocalPlayer():ConCommand( "kumo_chatstamp 0")
                    end
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
            Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName)
            Regiment_Player_List:SortByColumn(1, false)
        end

        local Regiment_Regiment_List = vgui.Create("DListView", RegimentPanel)
        Regiment_Regiment_List:SetPos(RegimentPanel:GetWide() - (RegimentPanel:GetWide() / 3 - 20), RegimentPanel:GetTall() / 12)
        Regiment_Regiment_List:SetSize(RegimentPanel:GetWide() / 4, RegimentPanel:GetTall() / 3.5)
        Regiment_Regiment_List:SetMultiSelect(false)
        Regiment_Regiment_List:AddColumn("Regiment")

        for k, v in pairs(RegTable) do
            Regiment_Regiment_List:AddLine(v.Regiment, k)
        end

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

                for k, v in pairs(RegRanks[TeamTable[selPlayer:Team()].Regiment]) do
                    self:AddLine(v, k)
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
            if not selPlayer then return end
            local count = Regiment_Rank_List:GetLine(Regiment_Rank_List:GetSelectedLine()):GetValue(2)
            net.Start("SetPlayerRank")
            net.WriteUInt(count, 10)
            net.WriteEntity(selPlayer)
            net.SendToServer()
            Regiment_Rank_List:Clear()
            Regiment_Player_List:Clear()

            for k, v in pairs(RegRanks[TeamTable[selPlayer:Team()].Regiment]) do
                Regiment_Rank_List:AddLine(v, k)
                Regiment_Rank_List:SortByColumn(1, false)
            end

            for k, v in pairs(player.GetAll()) do
                Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName)
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
            local tbl = RegTable[reg]
            local count = tbl.Count
            net.Start("SetPlayerRegiment")
            net.WriteUInt(count, 10)
            net.WriteEntity(selPlayer)
            net.SendToServer()
            Regiment_Rank_List:Clear()
            Regiment_Player_List:Clear()

            for k, v in pairs(RegRanks[TeamTable[selPlayer:Team()].Regiment]) do
                Regiment_Rank_List:AddLine(v, k)
                Regiment_Rank_List:SortByColumn(1, false)
            end

            for k, v in pairs(player.GetAll()) do
                Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName)
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
                    Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName)
                    Regiment_Player_List:SortByColumn(1, false)
                end
            else
                for k, v in pairs(player.GetAll()) do
                    if string.match(string.lower(v:Nick()), string.lower(self:GetValue())) then
                        Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName)
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

        if TeamTable[LocalPlayer():Team()].Rank >= 4 then
            for k, v in pairs(player.GetAll()) do
                if v == LocalPlayer() then continue end

                if TeamTable[v:Team()].Rank == 0 then
                    Promotion_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName, v:Team())
                    Regiment_Player_List:SortByColumn(1, false)
                end

                if TeamTable[LocalPlayer():Team()].Rank >= 10 then
                    if TeamTable[v:Team()].Regiment == TeamTable[LocalPlayer():Team()].Regiment and TeamTable[v:Team()].Rank + 1 <= TeamTable[LocalPlayer():Team()].Rank then
                        Promotion_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName, v:Team())
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
            if TeamTable[LocalPlayer():Team()].Rank <= 9 then return end
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

        if TeamTable[LocalPlayer():Team()].Rank < 10 then
            Promotion_BRemoveRank:Hide()
            Promotion_BRemoveRankTXT:Hide()
        end

        -- Admin Panel
        local AdminPanel = vgui.Create("DPanel", MainPanel)
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

        local AdminPanel_IMG = vgui.Create("DImage", AdminPanel)
        AdminPanel_IMG:SetSize(AdminPanel:GetTall() / 2.3, AdminPanel:GetTall() / 2.3)
        AdminPanel_IMG:SetPos(AdminPanel:GetWide() / 2 - AdminPanel_IMG:GetWide() / 2, AdminPanel:GetTall() * 0.25)
        AdminPanel_IMG:SetImage(bgImages["Admin_Menu"])
        local AdminPanel_CollapseMenu = vgui.Create("DCollapsibleCategory", AdminPanel)
        AdminPanel_CollapseMenu:SetSize(AdminPanel_IMG:GetWide(), 100)
        AdminPanel_CollapseMenu:SetPos(AdminPanel:GetWide() / 2 - AdminPanel_CollapseMenu:GetWide() / 2, AdminPanel:GetTall() * 0.25 + AdminPanel_IMG:GetTall())
        AdminPanel_CollapseMenu:SetExpanded(0)
        AdminPanel_CollapseMenu:SetLabel("Superadmin Settings")
        local AdminPanel_CollapseList = vgui.Create("DPanelList", AdminPanel)
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

        if TeamTable[LocalPlayer():Team()].Rank < 4 then
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
                        Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName)
                        Regiment_Player_List:SortByColumn(1, false)
                    end
                end
            else
                for k, v in pairs(player.GetAll()) do
                    Regiment_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName)
                    Regiment_Player_List:SortByColumn(1, false)
                end
            end

            Promotion_Player_List:Clear()
            Promotion_Player_List:AddLine(LocalPlayer():Nick(), LocalPlayer():SteamID(), TeamTable[LocalPlayer():Team()].Regiment, TeamTable[LocalPlayer():Team()].RealName, LocalPlayer():Team())
            Promotion_Player_List:SortByColumn(1, false)

            if TeamTable[LocalPlayer():Team()].Rank >= 4 then
                for k, v in pairs(player.GetAll()) do
                    if v == LocalPlayer() then continue end

                    if TeamTable[v:Team()].Rank == 0 then
                        Promotion_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName, v:Team())
                        Promotion_Player_List:SortByColumn(1, false)
                    end

                    if TeamTable[LocalPlayer():Team()].Rank >= 10 then
                        if TeamTable[v:Team()].Regiment == TeamTable[LocalPlayer():Team()].Regiment and TeamTable[v:Team()].Rank + 1 <= TeamTable[LocalPlayer():Team()].Rank then
                            Promotion_Player_List:AddLine(v:Nick(), v:SteamID(), TeamTable[v:Team()].Regiment, TeamTable[v:Team()].RealName, v:Team())
                            Promotion_Player_List:SortByColumn(1, false)
                        end
                    end
                end
            end

            if TeamTable[LocalPlayer():Team()].Rank > 4 then
                MainPanelHeader_Menu_B2:Show()
            elseif TeamTable[LocalPlayer():Team()].Rank <= 4 then
                MainPanelHeader_Menu_B2:Hide()
            end

            if TeamTable[LocalPlayer():Team()].Rank < 10 then
                Promotion_BRemoveRank:Hide()
                Promotion_BRemoveRankTXT:Hide()
            elseif TeamTable[LocalPlayer():Team()].Rank > 9 then
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
            end
        end)
    end
else
    resource.AddSingleFile("materials/ig/menu/ig_banner.png")
    resource.AddSingleFile("materials/ig/menu/ig_close.png")
    resource.AddSingleFile("materials/ig/menu/ig_close_hov.png")
    resource.AddSingleFile("materials/ig/menu/ig_logo.png")
    resource.AddSingleFile("materials/ig/menu/ig_logo_hov.png")
    resource.AddSingleFile("materials/ig/menu/ig_logo_hov2.png")
    resource.AddSingleFile("materials/ig/menu/ig_mb.png")
    resource.AddSingleFile("materials/ig/menu/ig_mb_hov.png")
    resource.AddSingleFile("materials/ig/menu/ig_ts.png")
    resource.AddSingleFile("materials/ig/menu/ig_ts_hov.png")
    resource.AddSingleFile("materials/ig/menu/menu_b1.png")
    resource.AddSingleFile("materials/ig/menu/menu_b2.png")
    resource.AddSingleFile("materials/ig/menu/menu_b3.png")
    resource.AddSingleFile("materials/ig/menu/menu_b4.png")
    resource.AddSingleFile("materials/ig/menu/menu_hov_b1.png")
    resource.AddSingleFile("materials/ig/menu/menu_hov_b2.png")
    resource.AddSingleFile("materials/ig/menu/menu_hov_b3.png")
    resource.AddSingleFile("materials/ig/menu/menu_hov_b4.png")
    resource.AddSingleFile("materials/ig/menu/menu_sel_b1.png")
    resource.AddSingleFile("materials/ig/menu/menu_sel_b2.png")
    resource.AddSingleFile("materials/ig/menu/menu_sel_b3.png")
    resource.AddSingleFile("materials/ig/menu/menu_sel_b4.png")
    resource.AddSingleFile("materials/ig/menu/set_demote.png")
    resource.AddSingleFile("materials/ig/menu/set_demote_hov.png")
    resource.AddSingleFile("materials/ig/menu/set_promote.png")
    resource.AddSingleFile("materials/ig/menu/set_promote_hov.png")
    resource.AddSingleFile("materials/ig/menu/set_rank.png")
    resource.AddSingleFile("materials/ig/menu/set_rank_hov.png")
    resource.AddSingleFile("materials/ig/menu/set_regiment.png")
    resource.AddSingleFile("materials/ig/menu/set_regiment_hov.png")
    resource.AddSingleFile("materials/ig/menu/search_player.png")
    resource.AddSingleFile("materials/ig/menu/search_player_hov.png")
    resource.AddSingleFile("materials/ig/menu/menu_background.png")
    resource.AddSingleFile("materials/ig/menu/menu_png.png")
    resource.AddSingleFile("materials/ig/menu/ig_super_hov.png")

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
        --if TeamTable[ ply:Team() ].Rank <= 4 and !ply:IsAdmin() then return end
        net.Start("UpdateMenu")
        net.Send(ply)
        net.Start("OpenPromotionMenu")
        net.Send(ply)
    end)

    net.Receive("PromoteUser", function(len, ply)
        if not ply:IsValid() then return end
        if TeamTable[ply:Team()].Rank <= 4 then return end
        local user = net.ReadEntity()

        if TeamTable[ply:Team()].Rank >= 10 then
            if user == ply then return end

            if TeamTable[user:Team()].Rank == 0 then
                ulx.fancyLogAdmin(ply, "#A promoted #T from recruit", user)
                local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)

                if SERVER then
                    ply:ProgressQuest("Recruits", 1)
                    ply:ProgressQuest("Recruits", 2)
                    ply:ProgressQuest("Recruits", 3)
                end

                user:SetJData("job", 1)
                user:SetTeam(1)
                user:SetModel(TeamTable[1].Model)
                user:StripWeapons()
            else
                if TeamTable[user:Team()].Regiment ~= TeamTable[ply:Team()].Regiment or TeamTable[user:Team()].Rank + 1 >= TeamTable[ply:Team()].Rank then return end
                user:SetJData("job", user:Team() + 1)
                user:SetTeam(user:Team() + 1)
                user:SetModel(TeamTable[user:Team()].Model)
                user:StripWeapons()
                ulx.fancyLogAdmin(ply, "#A promoted #T to [#s] #s in #s", user, TeamTable[user:Team()].Rank, TeamTable[user:Team()].RealName, TeamTable[user:Team()].Regiment)
                local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)
            end

            local weps = TeamTable[user:Team()].Weapons

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
        elseif TeamTable[ply:Team()].Rank >= 4 and TeamTable[user:Team()].Rank == 0 then
            user:SetJData("job", 1)
            user:SetTeam(1)
            user:SetModel(TeamTable[1].Model)
            user:StripWeapons()
            ulx.fancyLogAdmin(ply, "#A promoted #T from recruit", user)
            local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)

            if SERVER then
                ply:ProgressQuest("Recruits", 1)
                ply:ProgressQuest("Recruits", 2)
                ply:ProgressQuest("Recruits", 3)
            end

            local weps = TeamTable[1].Weapons

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
        if TeamTable[ply:Team()].Rank < 10 then return end
        local user = net.ReadEntity()
        if not user then return end
        if user == ply or TeamTable[user:Team()].Regiment ~= TeamTable[ply:Team()].Regiment or TeamTable[user:Team()].Rank >= TeamTable[ply:Team()].Rank then return end

        if TeamTable[ply:Team()].Rank > 10 then
            if TeamTable[user:Team()].Rank == 1 then
                ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, TeamTable[user:Team()].Regiment)
                local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                user:SetJData("job", 1)
                user:SetTeam(1)
                user:SetModel(TeamTable[1].Model)
                user:StripWeapons()
            else
                user:SetJData("job", user:Team() - 1)
                user:SetTeam(user:Team() - 1)
                user:SetModel(TeamTable[user:Team()].Model)
                user:StripWeapons()
                ulx.fancyLogAdmin(ply, "#A demoted #T to [#s] #s in #s", user, TeamTable[user:Team()].Rank, TeamTable[user:Team()].RealName, TeamTable[user:Team()].Regiment)
                local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                local weps = TeamTable[user:Team()].Weapons

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
        if not ply:IsValid() then return end
        if not ply:IsAdmin() then return end
        local count = net.ReadUInt(10)
        local tbl = TeamTable[count]
        if tbl == nil then return end
        user = net.ReadEntity() -- Was ply
        user:SetJData("job", count) -- All of these were also ply
        user:SetTeam(count)

        --user:SetModel( tbl.Model )
        if type(tbl.Model) == "table" then
            user:SetModel(table.Random(tbl.Model))
        else
            user:SetModel(tbl.Model)
        end

        user:StripWeapons()
        ulx.fancyLogAdmin(ply, "#A set the regiment of #T to #s", user, TeamTable[user:Team()].Regiment)
        local MooseSetPlayerRegiment = hook.Call("MooseSetPlayerRegiment", GAMEMODE, ply, user, TeamTable[user:Team()].Regiment)
        local weps = tbl.Weapons

        for i = 1, #weps do
            user:Give(weps[i])
        end

        ply:SetBodyGroups(tbl.Bodygroups)
        ply:SetSkin(tonumber(tbl.Skin))
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
        local count = net.ReadUInt(10)
        local tbl = TeamTable[count]
        if tbl == nil then return end
        local user = net.ReadEntity() -- Was ply
        user:SetJData("job", count) -- All of these were ply
        user:SetTeam(count)

        --user:SetModel( tbl.Model )
        if type(tbl.Model) == "table" then
            user:SetModel(table.Random(tbl.Model))
        else
            user:SetModel(tbl.Model)
        end

        user:SetBodyGroups(tbl.Bodygroups)
        user:SetSkin(tonumber(tbl.Skin))
        ulx.fancyLogAdmin(ply, "#A set the rank of #T to [#s] #s in #s", user, TeamTable[user:Team()].Rank, TeamTable[user:Team()].RealName, TeamTable[user:Team()].Regiment)
        local MooseSetPlayerRank = hook.Call("MooseSetPlayerRank", GAMEMODE, ply, user, TeamTable[user:Team()].Rank)

        timer.Simple(0.3, function()
            net.Start("UpdateMenu")
            net.Send(ply)
        end)
    end)

    net.Receive("RemoveBySteamID", function(len, ply)
        if not ply:IsValid() then return end
        if TeamTable[ply:Team()].Rank <= 9 and not ply:IsSuperAdmin() then return end
        local steamid = net.ReadString()
        print(steamid)
        local value = 1
        if not (steamid) then return end

        if string.match(steamid, "STEAM_") then
            if (player.GetBySteamID(steamid)) then
                local user = player.GetBySteamID(steamid)
                if user == ply or TeamTable[user:Team()].Regiment ~= TeamTable[ply:Team()].Regiment and not ply:IsSuperAdmin() or TeamTable[user:Team()].Rank >= TeamTable[ply:Team()].Rank and not ply:IsSuperAdmin() then return end
                ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, TeamTable[user:Team()].Regiment)
                user:SetJData("job", 1)
                user:SetTeam(1)
                user:SetModel(TeamTable[1].Model)
                user:StripWeapons()
            else
                local steamid64 = util.SteamIDTo64(steamid)
                name = string.format("%s[%s]", steamid64, "job")
                local val = sql.QueryValue("SELECT value FROM jobdata WHERE steamid = " .. sql.SQLStr(name) .. " LIMIT 1")

                if val ~= nil then
                    if TeamTable[tonumber(val)].Regiment == TeamTable[ply:Team()].Regiment and TeamTable[tonumber(val)].Rank < TeamTable[ply:Team()].Rank then
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(value) .. " )")
                        ulx.fancyLogAdmin(ply, "#A kicked " .. steamid .. " from the regiment #s", TeamTable[tonumber(val)].Regiment)
                    elseif ply:IsSuperAdmin() then
                        ulx.fancyLogAdmin(ply, "#A kicked " .. steamid .. " from the regiment #s", TeamTable[tonumber(val)].Regiment)
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(value) .. " )")
                    else
                        ply:ChatPrint("This player is not in your regiment or outranks you")
                    end
                else
                    ply:ChatPrint("This player does not exist, double check the steamid")
                end
            end
        elseif tonumber(steamid) ~= nil then
            if (player.GetBySteamID64(steamid)) then
                local user = player.GetBySteamID64(steamid)
                if user == ply or TeamTable[user:Team()].Regiment ~= TeamTable[ply:Team()].Regiment and not ply:IsSuperAdmin() or TeamTable[user:Team()].Rank >= TeamTable[ply:Team()].Rank and not ply:IsSuperAdmin() then return end
                ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, TeamTable[user:Team()].Regiment)
                user:SetJData("job", 1)
                user:SetTeam(1)
                user:SetModel(TeamTable[1].Model)
                user:StripWeapons()
            else
                name = string.format("%s[%s]", steamid, "job")
                local val = sql.QueryValue("SELECT value FROM jobdata WHERE steamid = " .. sql.SQLStr(name) .. " LIMIT 1")

                if val ~= nil then
                    if TeamTable[tonumber(val)].Regiment == TeamTable[ply:Team()].Regiment and TeamTable[tonumber(val)].Rank < TeamTable[ply:Team()].Rank then
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(value) .. " )")
                        ulx.fancyLogAdmin(ply, "#A kicked " .. steamid .. " from the regiment #s", TeamTable[tonumber(val)].Regiment)
                    elseif ply:IsSuperAdmin() then
                        ulx.fancyLogAdmin(ply, "#A kicked " .. steamid .. " from the regiment #s", TeamTable[tonumber(val)].Regiment)
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(value) .. " )")
                    else
                        ply:ChatPrint("This player is not in your regiment or outranks you")
                    end
                else
                    ply:ChatPrint("This player does not exist, double check the steamid")
                end
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
        if TeamTable[ply:Team()].Rank <= 9 and not ply:IsSuperAdmin() then return end
        local steamid = net.ReadString()
        if not (steamid) then return end

        if string.match(steamid, "STEAM_") then
            if (player.GetBySteamID(steamid)) then
                local user = player.GetBySteamID(steamid)
                if TeamTable[user:Team()].Regiment ~= TeamTable[ply:Team()].Regiment or TeamTable[user:Team()].Rank + 1 >= TeamTable[ply:Team()].Rank and not ply:IsSuperAdmin() then return end
                user:SetJData("job", user:Team() + 1)
                user:SetTeam(user:Team() + 1)
                user:SetModel(TeamTable[user:Team()].Model)
                user:StripWeapons()
                ulx.fancyLogAdmin(ply, "#A promoted #T to [#s] #s in #s", user, TeamTable[user:Team()].Rank, TeamTable[user:Team()].RealName, TeamTable[user:Team()].Regiment)
                local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)
                local weps = TeamTable[user:Team()].Weapons

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
                name = string.format("%s[%s]", steamid64, "job")
                local val = sql.QueryValue("SELECT value FROM jobdata WHERE steamid = " .. sql.SQLStr(name) .. " LIMIT 1")

                if val ~= nil then
                    if TeamTable[tonumber(val)].Regiment == TeamTable[ply:Team()].Regiment and TeamTable[tonumber(val)].Rank + 1 < TeamTable[ply:Team()].Rank then
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(val + 1) .. " )")
                        ulx.fancyLogAdmin(ply, "#A promoted " .. steamid .. " in the regiment #s", TeamTable[tonumber(val)].Regiment)
                    elseif ply:IsSuperAdmin() then
                        ulx.fancyLogAdmin(ply, "#A promoted " .. steamid .. " in the regiment #s", TeamTable[tonumber(val)].Regiment)
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(val + 1) .. " )")
                    else
                        ply:ChatPrint("This player is not in your regiment or outranks you")
                    end
                else
                    ply:ChatPrint("This player does not exist, double check the steamid")
                end
            end
        elseif tonumber(steamid) ~= nil then
            if (player.GetBySteamID64(steamid)) then
                local user = player.GetBySteamID64(steamid)
                if TeamTable[user:Team()].Regiment ~= TeamTable[ply:Team()].Regiment or TeamTable[user:Team()].Rank + 1 >= TeamTable[ply:Team()].Rank and not ply:IsSuperAdmin() then return end
                user:SetJData("job", user:Team() + 1)
                user:SetTeam(user:Team() + 1)
                user:SetModel(TeamTable[user:Team()].Model)
                user:StripWeapons()
                ulx.fancyLogAdmin(ply, "#A promoted #T to [#s] #s in #s", user, TeamTable[user:Team()].Rank, TeamTable[user:Team()].RealName, TeamTable[user:Team()].Regiment)
                local MoosePromoteUser = hook.Call("MoosePromoteUser", GAMEMODE, ply, user)
                local weps = TeamTable[user:Team()].Weapons

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
                name = string.format("%s[%s]", steamid, "job")
                local val = sql.QueryValue("SELECT value FROM jobdata WHERE steamid = " .. sql.SQLStr(name) .. " LIMIT 1")

                if val ~= nil then
                    if TeamTable[tonumber(val)].Regiment == TeamTable[ply:Team()].Regiment and TeamTable[tonumber(val)].Rank + 1 < TeamTable[ply:Team()].Rank then
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(val + 1) .. " )")
                        ulx.fancyLogAdmin(ply, "#A promoted " .. steamid .. " in the regiment #s", TeamTable[tonumber(val)].Regiment)
                    elseif ply:IsSuperAdmin() then
                        ulx.fancyLogAdmin(ply, "#A promoted " .. steamid .. " in the regiment #s", TeamTable[tonumber(val)].Regiment)
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(val + 1) .. " )")
                    else
                        ply:ChatPrint("This player is not in your regiment or outranks you")
                    end
                else
                    ply:ChatPrint("This player does not exist, double check the steamid")
                end
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
        if TeamTable[ply:Team()].Rank <= 9 and not ply:IsSuperAdmin() then return end
        local steamid = net.ReadString()
        if not (steamid) then return end

        if string.match(steamid, "STEAM_") then
            if (player.GetBySteamID(steamid)) then
                local user = player.GetBySteamID(steamid)
                if user == ply or TeamTable[user:Team()].Regiment ~= TeamTable[ply:Team()].Regiment or TeamTable[user:Team()].Rank >= TeamTable[ply:Team()].Rank then return end

                if TeamTable[ply:Team()].Rank > 10 then
                    if TeamTable[user:Team()].Rank == 1 then
                        ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, TeamTable[user:Team()].Regiment)
                        local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                        user:SetJData("job", 1)
                        user:SetTeam(1)
                        user:SetModel(TeamTable[1].Model)
                        user:StripWeapons()
                    else
                        user:SetJData("job", user:Team() - 1)
                        user:SetTeam(user:Team() - 1)
                        user:SetModel(TeamTable[user:Team()].Model)
                        user:StripWeapons()
                        ulx.fancyLogAdmin(ply, "#A demoted #T to [#s] #s in #s", user, TeamTable[user:Team()].Rank, TeamTable[user:Team()].RealName, TeamTable[user:Team()].Regiment)
                        local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                        local weps = TeamTable[user:Team()].Weapons

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
                name = string.format("%s[%s]", steamid64, "job")
                local val = sql.QueryValue("SELECT value FROM jobdata WHERE steamid = " .. sql.SQLStr(name) .. " LIMIT 1")

                if val ~= nil then
                    if TeamTable[tonumber(val)].Regiment == TeamTable[ply:Team()].Regiment and TeamTable[tonumber(val)].Rank < TeamTable[ply:Team()].Rank and TeamTable[tonumber(val)].Rank == 1 then
                        ply:ChatPrint("Please use the kick from regiment feature instead")
                    elseif TeamTable[tonumber(val)].Regiment == TeamTable[ply:Team()].Regiment and TeamTable[tonumber(val)].Rank < TeamTable[ply:Team()].Rank then
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(val - 1) .. " )")
                        ulx.fancyLogAdmin(ply, "#A demoted " .. steamid .. " in the regiment #s", TeamTable[tonumber(val)].Regiment)
                    elseif ply:IsSuperAdmin() then
                        ulx.fancyLogAdmin(ply, "#A demoted " .. steamid .. " in the regiment #s", TeamTable[tonumber(val)].Regiment)
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(val - 1) .. " )")
                    else
                        ply:ChatPrint("This player is not in your regiment or outranks you")
                    end
                else
                    ply:ChatPrint("This player does not exist, double check the steamid")
                end
            end
        elseif tonumber(steamid) ~= nil then
            if (player.GetBySteamID64(steamid)) then
                local user = player.GetBySteamID64(steamid)
                if user == ply or TeamTable[user:Team()].Regiment ~= TeamTable[ply:Team()].Regiment or TeamTable[user:Team()].Rank >= TeamTable[ply:Team()].Rank then return end

                if TeamTable[ply:Team()].Rank > 10 then
                    if TeamTable[user:Team()].Rank == 1 then
                        ulx.fancyLogAdmin(ply, "#A kicked #T from the regiment #s", user, TeamTable[user:Team()].Regiment)
                        local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                        user:SetJData("job", 1)
                        user:SetTeam(1)
                        user:SetModel(TeamTable[1].Model)
                        user:StripWeapons()
                    else
                        user:SetJData("job", user:Team() - 1)
                        user:SetTeam(user:Team() - 1)
                        user:SetModel(TeamTable[user:Team()].Model)
                        user:StripWeapons()
                        ulx.fancyLogAdmin(ply, "#A demoted #T to [#s] #s in #s", user, TeamTable[user:Team()].Rank, TeamTable[user:Team()].RealName, TeamTable[user:Team()].Regiment)
                        local MooseDemoteUser = hook.Call("MooseDemoteUser", GAMEMODE, ply, user)
                        local weps = TeamTable[user:Team()].Weapons

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
                name = string.format("%s[%s]", steamid, "job")
                local val = sql.QueryValue("SELECT value FROM jobdata WHERE steamid = " .. sql.SQLStr(name) .. " LIMIT 1")

                if val ~= nil then
                    if TeamTable[tonumber(val)].Regiment == TeamTable[ply:Team()].Regiment and TeamTable[tonumber(val)].Rank < TeamTable[ply:Team()].Rank and TeamTable[tonumber(val)].Rank == 1 then
                        ply:ChatPrint("Please use the kick from regiment feature instead")
                    elseif TeamTable[tonumber(val)].Regiment == TeamTable[ply:Team()].Regiment and TeamTable[tonumber(val)].Rank < TeamTable[ply:Team()].Rank then
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(val - 1) .. " )")
                        ulx.fancyLogAdmin(ply, "#A demoted " .. steamid .. " in the regiment #s", TeamTable[tonumber(val)].Regiment)
                    elseif ply:IsSuperAdmin() then
                        ulx.fancyLogAdmin(ply, "#A demoted " .. steamid .. " in the regiment #s", TeamTable[tonumber(val)].Regiment)
                        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(val - 1) .. " )")
                    else
                        ply:ChatPrint("This player is not in your regiment or outranks you")
                    end
                else
                    ply:ChatPrint("This player does not exist, double check the steamid")
                end
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
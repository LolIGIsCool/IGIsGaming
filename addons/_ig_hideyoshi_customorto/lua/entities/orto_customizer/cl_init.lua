--                --
--  Client Files  --
--                --
include("or/displacements/cl_orto_displacements.lua")
include("or/map_orto/cl_map_orto.lua")
local imgui = include("lib/imgui.lua")

--                --
--  Shared Files  --
--                --
include('shared.lua')
include("or/sh_creationkit.lua")
--include("or/displacements/sh_orto_displacements.lua")
net.Receive("CreateCustomizerPanel", function()
    --models/combine_scanner/scanner_eye
    --cl_HideyoshiSetOrtoDisplacements("phoenix_storms/ps_grass", "models/props_wasteland/rockgranite02a")
    CreateCustomizerPanel() 
end)

net.Receive("HideyoshiOR_CLResetOrto", function()
    --lordtrilobite/snow01
    --cl_HideyoshiSetGroundOrto("lordtrilobite/snow01")
    if materials_backup["LORDTRILOBITE/SNOW_ROCKS_BLEND01"] then
        cl_setorto(materials_backup["LORDTRILOBITE/SNOW_ROCKS_BLEND01"],'Displacements')
    end

    if materials_backup["LORDTRILOBITE/SNOW01"] then
        cl_setorto(materials_backup["LORDTRILOBITE/SNOW01"],'Map')
    end
    cl_setDisplayMaterial("models/props/cs_office/snowmana", 'Map')

end)

hook.Add( "InitPostEntity", "HideyoshiOR_Ready.hook", function()
	net.Start( "HideyoshiOR_Ready" )
	net.SendToServer()
end )

surface.CreateFont( "Large_MonitorFont_OR", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 50,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )

surface.CreateFont( "Medium_DermaOR_Header", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 22.5,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
} )
function CreateCustomizerPanel() 
    local OrtoCustomizer_Frame = vgui.Create( "DFrame" )
    OrtoCustomizer_Frame:SetSize( 750, 580 ) 
    OrtoCustomizer_Frame:Center()
    OrtoCustomizer_Frame:SetTitle( "Orto Customizer" ) 
    OrtoCustomizer_Frame:SetVisible( true ) 
    OrtoCustomizer_Frame:SetDraggable( false ) 
    OrtoCustomizer_Frame:ShowCloseButton( true ) 
    OrtoCustomizer_Frame:MakePopup()

    local OrtoFloor_Header = vgui.Create( "DLabel", OrtoCustomizer_Frame )
	OrtoFloor_Header:Dock( TOP )
	OrtoFloor_Header:DockMargin( 0, 5, 0, 0 )    
    OrtoFloor_Header:SetFont("Medium_DermaOR_Header")
    OrtoFloor_Header:SetText( "Orto Floor Setting" )

    local OrtoFloor_MaterialLabel = vgui.Create( "DLabel", OrtoCustomizer_Frame )
	OrtoFloor_MaterialLabel:Dock( TOP )
	OrtoFloor_MaterialLabel:DockMargin( 0, 5, 0, 0 )    
    OrtoFloor_MaterialLabel:SetText( " Material Path" )

    OrtoFloor_Material1Entry = vgui.Create( "DTextEntry", OrtoCustomizer_Frame )
	OrtoFloor_Material1Entry:Dock( TOP )
	OrtoFloor_Material1Entry:DockMargin( 0, 5, 0, 5 )
	OrtoFloor_Material1Entry:SetPlaceholderText( "lordtrilobite/snow01" )
	--[[OrtoFloor_Material1Entry.OnEnter = function( self )
		cl_HideyoshiSetGroundOrto(self:GetValue())
	end]]--

    local OrtoDisplacement_Header = vgui.Create( "DLabel", OrtoCustomizer_Frame )
	OrtoDisplacement_Header:Dock( TOP )
	OrtoDisplacement_Header:DockMargin( 0, 5, 0, 0 )    
    OrtoDisplacement_Header:SetFont("Medium_DermaOR_Header")
    OrtoDisplacement_Header:SetText( "Orto Wall Setting (Displacement)" )

    local OrtoDisplacement_Material1Label = vgui.Create( "DLabel", OrtoCustomizer_Frame )
	OrtoDisplacement_Material1Label:Dock( TOP )
	OrtoDisplacement_Material1Label:DockMargin( 0, 5, 0, 0 )    
    OrtoDisplacement_Material1Label:SetText( " Material Path 1" )

    OrtoDisplacement_Material1Entry = vgui.Create( "DTextEntry", OrtoCustomizer_Frame )
	OrtoDisplacement_Material1Entry:Dock( TOP )
	OrtoDisplacement_Material1Entry:DockMargin( 0, 5, 0, 5 )
	OrtoDisplacement_Material1Entry:SetPlaceholderText( "lordtrilobite/snow01" )
	--[[OrtoDisplacement_Material1Entry.OnEnter = function( self )
		cl_HideyoshiSetGroundOrto(self:GetValue())
	end]]--

    local OrtoDisplacement_Material2Label = vgui.Create( "DLabel", OrtoCustomizer_Frame )
	OrtoDisplacement_Material2Label:Dock( TOP )
	OrtoDisplacement_Material2Label:DockMargin( 0, 5, 0, 0 )    
    OrtoDisplacement_Material2Label:SetText( " Material Path 2" )

    OrtoDisplacement_Material2Entry = vgui.Create( "DTextEntry", OrtoCustomizer_Frame )
	OrtoDisplacement_Material2Entry:Dock( TOP )
	OrtoDisplacement_Material2Entry:DockMargin( 0, 5, 0, 5 )
	OrtoDisplacement_Material2Entry:SetPlaceholderText( "lordtrilobite/snowrocks01" )
	--[[OrtoDisplacement_Material2Entry.OnEnter = function( self )
		cl_HideyoshiSetGroundOrto(self:GetValue())
	end]]--

    local OR_SettingHeader = vgui.Create( "DLabel", OrtoCustomizer_Frame )
	OR_SettingHeader:Dock( TOP )
	OR_SettingHeader:DockMargin( 0, 5, 0, 0 )    
    OR_SettingHeader:SetFont("Medium_DermaOR_Header")
    OR_SettingHeader:SetText( "Orientation/Custom Settings" )

    OR_ScaleX = vgui.Create( "DNumSlider", OrtoCustomizer_Frame )
	OR_ScaleX:Dock( TOP )
	OR_ScaleX:DockMargin( 3.7, 2, 0, 0 )    
    OR_ScaleX:SetText( "ScaleX" )
    OR_ScaleX:SetDefaultValue( 1 )
    OR_ScaleX:SetMin( 0.1 )
    OR_ScaleX:SetMax( 100 )
    OR_ScaleX:SetDecimals( 1 )	
    OR_ScaleX:ResetToDefaultValue()

    OR_ScaleY = vgui.Create( "DNumSlider", OrtoCustomizer_Frame )
	OR_ScaleY:Dock( TOP )
	OR_ScaleY:DockMargin( 3.7, 2, 0, 0 )    
    OR_ScaleY:SetText( "ScaleY" )
    OR_ScaleY:SetDefaultValue( 1 )
    OR_ScaleY:SetMin( 0.1 )
    OR_ScaleY:SetMax( 100 )
    OR_ScaleY:SetDecimals( 1 )	
    OR_ScaleY:ResetToDefaultValue()

    OR_OffsetX = vgui.Create( "DNumSlider", OrtoCustomizer_Frame )
	OR_OffsetX:Dock( TOP )
	OR_OffsetX:DockMargin( 3.7, 2, 0, 0 )    
    OR_OffsetX:SetText( "OffsetX" )
    OR_OffsetX:SetMin( 0 )
    OR_OffsetX:SetMax( 1000 )
    OR_OffsetX:SetDecimals( 0 )	

    OR_OffsetY = vgui.Create( "DNumSlider", OrtoCustomizer_Frame )
	OR_OffsetY:Dock( TOP )
	OR_OffsetY:DockMargin( 3.7, 2, 0, 0 )    
    OR_OffsetY:SetText( "OffsetY" )
    OR_OffsetY:SetMin( 0 )
    OR_OffsetY:SetMax( 1000 )
    OR_OffsetY:SetDecimals( 0 )	

    OR_Rotation = vgui.Create( "DNumSlider", OrtoCustomizer_Frame )
	OR_Rotation:Dock( TOP )
	OR_Rotation:DockMargin( 3.7, 2, 0, 0 )    
    OR_Rotation:SetText( "Rotation" )
    OR_Rotation:SetMin( 0 )
    OR_Rotation:SetMax( 360 )
    OR_Rotation:SetDecimals( 0 )	

    local OR_SubmissionHeader = vgui.Create( "DLabel", OrtoCustomizer_Frame )
	OR_SubmissionHeader:Dock( TOP )
	OR_SubmissionHeader:DockMargin( 0, 5, 0, 0 )    
    OR_SubmissionHeader:SetFont("Medium_DermaOR_Header")
    OR_SubmissionHeader:SetText( "Submit Changes" )

    local OR_Presets = vgui.Create( "DButton", OrtoCustomizer_Frame )
    OR_Presets:SetText( "Presets Menu" )					
	OR_Presets:Dock( TOP )
	OR_Presets:DockMargin( 0, 5, 0, 0 )   
    OR_Presets.DoClick = function()		
        if OR_PresetsFrame then
            OR_PresetsFrame:Remove()
            OR_PresetsFrame = nil
        end

        local setup_presets = {
            OrtoFloor_Material1Entry:GetValue(),
            OrtoDisplacement_Material1Entry:GetValue(),
            OrtoDisplacement_Material2Entry:GetValue(),
            OR_ScaleX:GetValue(),
            OR_ScaleY:GetValue(),
            OR_OffsetX:GetValue(),
            OR_OffsetY:GetValue(),
            OR_Rotation:GetValue()
        }

        HideyoshiOR_CreatePresetMenu(setup_presets)
    end

    local OR_SubmitFloor = vgui.Create( "DButton", OrtoCustomizer_Frame ) 
    OR_SubmitFloor:SetText( "Submit Floor Changes" )					
	OR_SubmitFloor:Dock( TOP )
	OR_SubmitFloor:DockMargin( 0, 5, 0, 0 )   
    OR_SubmitFloor.DoClick = function()		
        if (OrtoFloor_Material1Entry:GetValue() == "") then
            notification.AddLegacy( "The Materials Entry for Floor is empty", 1, 2 )
            return
        end
        
        local OR_tableofSettings = {
            OR_ScaleX:GetValue(),
            OR_ScaleY:GetValue(),
            OR_OffsetX:GetValue(),
            OR_OffsetY:GetValue(),
            OR_Rotation:GetValue()
        }
        cl_HideyoshiSetGroundOrto(OrtoFloor_Material1Entry:GetValue(),OR_tableofSettings)
    end

    local OR_SubmitDisplacements = vgui.Create( "DButton", OrtoCustomizer_Frame ) 
    OR_SubmitDisplacements:SetText( "Submit Displacements Changes" )					
	OR_SubmitDisplacements:Dock( TOP )
	OR_SubmitDisplacements:DockMargin( 0, 5, 0, 0 )   
    OR_SubmitDisplacements.DoClick = function()
        if (OrtoDisplacement_Material1Entry:GetValue() == "" || OrtoDisplacement_Material2Entry:GetValue() == "") then
            notification.AddLegacy( "One or more of the Materials Entries for Displacement is empty", 1, 2 )
            return
        end

        local OR_tableofSettings = {
            OR_ScaleX:GetValue(),
            OR_ScaleY:GetValue(),
            OR_OffsetX:GetValue(),
            OR_OffsetY:GetValue(),
            OR_Rotation:GetValue()
        }
        cl_HideyoshiSetOrtoDisplacements(OrtoDisplacement_Material1Entry:GetValue(), OrtoDisplacement_Material2Entry:GetValue(), OR_tableofSettings)
    end

    local OR_ResetOrto = vgui.Create( "DButton", OrtoCustomizer_Frame ) 
    OR_ResetOrto:SetText( "Reset Orto" )					
	OR_ResetOrto:Dock( TOP )
    OR_ResetOrto:SetTextColor( Color(255,255,255) )
	OR_ResetOrto:DockMargin( 0, 5, 0, 0 ) 
    OR_ResetOrto.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 155, 0, 0, 250 ) ) -- Draw a blue button
    end  
    OR_ResetOrto.DoClick = function()
        Derma_Query( "Are you sure you want to reset Orto Plutonia?", "Orto Customizer", "Yes", function() 
            net.Start("HideyoshiOR_ResetOrto") 
            net.SendToServer()
        end,
        "No", function()
            return
        end
        )
    end
end

function HideyoshiOR_CreatePresetMenu(data) 
    OR_PresetsFrame = vgui.Create( "DFrame" )
    OR_PresetsFrame:SetSize( 600, 400 ) 
    OR_PresetsFrame:Center()
    OR_PresetsFrame:SetTitle( "Orto Customizer Presets" ) 
    OR_PresetsFrame:SetVisible( true ) 
    OR_PresetsFrame:ShowCloseButton( true ) 
    OR_PresetsFrame:MakePopup()

    OR_PresetList = vgui.Create( "DListView", OR_PresetsFrame )
	OR_PresetList:Dock( TOP )
	OR_PresetList:DockMargin( 0, 5, 0, 0 )
    OR_PresetList:SetSize(0, 305)       
    OR_PresetList:SetMultiSelect( false )
    OR_PresetList:AddColumn( "#" ):SetFixedWidth(20)
    OR_PresetList:AddColumn( "Preset Name" )
    OR_PresetList:AddColumn( "Creator Name" )
    net.Start("sv_getortopresets")
    net.SendToServer()

    local OR_PresetList_LoadPreset = vgui.Create( "DButton", OR_PresetsFrame ) 
    OR_PresetList_LoadPreset:SetText( "Load Preset" )					
	OR_PresetList_LoadPreset:Dock( TOP )
	OR_PresetList_LoadPreset:DockMargin( 0, 5, 0, 0 ) 
    OR_PresetList_LoadPreset.DoClick = function()
        if (OR_PresetList:GetSelected()[1]==nil) then
            notification.AddLegacy( "No preset selected", 1, 2 )
            return
        end
        net.Start("sv_LoadORPreset")
            net.WriteString(OR_PresetList:GetSelected()[1]:GetColumnText(4))
        net.SendToServer()
    end
    
    local OR_PresetList_CreatePreset = vgui.Create( "DButton", OR_PresetsFrame ) 
    OR_PresetList_CreatePreset:SetText( "Create Preset" )					
	OR_PresetList_CreatePreset:Dock( TOP )
	OR_PresetList_CreatePreset:DockMargin( 0, 5, 0, 0 ) 
    OR_PresetList_CreatePreset.DoClick = function()
        if (data[1]=="") and (data[2]=="" or data[3]=="") then
            notification.AddLegacy( "One or more of your entries is empty", 1, 2 )
            return
        end

        Derma_StringRequest(
            "Orto Customizer - Preset Creator", 
            "Input the desired name of your preset",
            "",
            function(text) 
                data[8] = text
                net.Start("sv_createortopreset")
                    net.WriteTable(data)
                net.SendToServer()
                OR_PresetList:Clear()
                net.Start("sv_getortopresets")
                net.SendToServer()
            end,
            function(text) chat.AddText("[Orto Customizer][Presets] Cancelled input") end
        )
    end
end

local Planet_SurfaceViewer = vgui.Create( "DFrame" )
Planet_SurfaceViewer:SetSize( 750, 750 ) 
Planet_SurfaceViewer:SetPos(-400,15)
Planet_SurfaceViewer:SetPaintedManually(true)
Planet_SurfaceViewer.Paint = function( self, w, h )
    return
end

local Planet_SurfaceViewer_Mat = vgui.Create("DImage", Planet_SurfaceViewer)
Planet_SurfaceViewer_Mat:Dock( FILL )
Planet_SurfaceViewer_Mat:SetImage("models/props/cs_office/snowmana", "ace/sw/hologram")

function cl_setDisplayMaterial(Material1, type)
    if type == "Map" && IsValid(Planet_SurfaceViewer) && IsValid(Planet_SurfaceViewer_Mat) then
        Planet_SurfaceViewer_Mat:SetImage(Material1, "ace/sw/hologram")
    end
end

local border_mat = Material("vgui/planet_border.png")
function ENT:Draw()
    self:DrawModel()

    --local pos = self:LocalToWorld(Vector( -10, 0, 110 ))
	--local ang = self:LocalToWorldAngles(Angle(0, 90, 90))
    --cam.Start3D2D(pos , ang, 0.1)     
    if imgui.Entity3D2D(self, Vector( -10, 0, 110 ), Angle(0, 90, 90), 0.1) then
        draw.RoundedBox(0, -975, -145, 2000, 1135, Color(0,0,0,255))
        if ( string.match(game.GetMap(), "rp_stardestroyer") ) then
            Planet_SurfaceViewer:PaintManual()

            surface.SetDrawColor( 255, 255, 255, 255)
            surface.SetMaterial(border_mat)
            surface.DrawTexturedRect(-500, -75, 950, 950)
            draw.SimpleText("Planetary Surface Satellite", "Large_MonitorFont_OR", -25, -45, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

            if imgui.xTextButton("Travel Menu", "!Roboto@35", -300, 825, 550, 75, 3, Color(255,255,255), Color(0,0,255), Color(255,0,0)) then
                CreateCustomizerPanel() 
            end
        else
            draw.SimpleText("Err: Not on rp_stardestroyer_v2_5_inf", "Large_MonitorFont_OR", -0, 300, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    imgui.End3D2D()
    --cam.End3D2D()
    end
end

net.Receive("cl_sendortopresets", function()
    for k,v in pairs(net.ReadTable()) do
        OR_PresetList:AddLine(k,v[1],v[2],v[3])
    end
end)

net.Receive("cl_LoadORPreset", function()
    local preset_value = util.JSONToTable(net.ReadString())
    OrtoFloor_Material1Entry:SetValue(preset_value[1])
    OrtoDisplacement_Material1Entry:SetValue(preset_value[2])
    OrtoDisplacement_Material2Entry:SetValue(preset_value[3])
    OR_ScaleX:SetValue(preset_value[4])
    OR_ScaleY:SetValue(preset_value[5])
    OR_OffsetX:SetValue(preset_value[6])
    OR_OffsetY:SetValue(preset_value[7])
    OR_Rotation:SetValue(preset_value[8])
    OR_PresetsFrame:Remove()
end)
--[[ Nykez 2017. Do not edit ]]--
 
 
 surface.CreateFont( "StarHUDFontTitle", {          
	font = "Laconic",
	weight = 400,
	bold = true,
	shadow = true,
	size = ScreenScale(10)
  } )
  
surface.CreateFont( "StarHUDFontWeapon", {          
	font = "Laconic",
	weight = 400,
	bold = true,
	shadow = true,
	size = 24,
  } )
  
surface.CreateFont( "StarHUDFontWeapon2", {          
	font = "Laconic",
	weight = 400,
	bold = true,
	shadow = true,
	size = 18,
  } )
  
surface.CreateFont( "StarHUDFontWeapon3", {          
	font = "Laconic",
	weight = 400,
	bold = true,
	shadow = true,
	size = 14,
  })
  
  
local PANEL = {}

AccessorFunc( PANEL, "ActiveButton", "ActiveButton" )

function PANEL:Init()

	self.Navigation = vgui.Create( "DScrollPanel", self )
	self.Navigation:Dock( LEFT )
	self.Navigation:SetWidth( 150 )
	self.Navigation:DockMargin( 10, 10, 10, 0 )

	self.Content = vgui.Create( "Panel", self )
	self.Content:Dock( FILL )

	self.Items = {}

end

local sw_box = Material("sw_n_gui/sw_c_sheet.png")
function PANEL:Paint(w, h)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial(sw_box)
	surface.DrawTexturedRect( 0, 0, w, h )
end

function PANEL:UseButtonOnlyStyle()
	self.ButtonOnly = true
end


local template_left = Material("sw_n_gui/sw_button_normal.png")
local template_active = Material("sw_n_gui/sw_button_hov.png")
local template_activee = Material("sw_n_gui/sw_button_active.png")
function PANEL:AddSheet( label, panel, material )

	if ( !IsValid( panel ) ) then return end

	local Sheet = {}


	Sheet.Button = vgui.Create( "DButton", self.Navigation )
	Sheet.Button.Target = panel
	Sheet.Button:SetSize(225, 32)
	Sheet.Button:Dock( TOP )
	Sheet.Button:SetText("")
	Sheet.Button:DockMargin( 0, 8, 0, 0 )
	Sheet.Button.Paint = function(me)
		local mat = template_left
		
		if self.ActiveButton == Sheet.Button == true then
			mat = template_activee
		elseif me.hovered == true then
			mat = template_active
		end
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0,0,me:GetWide(), me:GetTall())
		
		local offset = me:GetWide()*.24
		local iw = offset*.4
		
		draw.SimpleText(label, "StarHUDFontWeapon2", offset + offset*.1, me:GetTall()/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(Material(material))
		surface.DrawTexturedRect(5,5,20, 20)
		
	end
	
	Sheet.Button.OnCursorEntered = function(me)
		//if self.ActiveButton == Sheet.Button then return end
		me.hovered = true
	end
	
	Sheet.Button.OnCursorExited = function(me)
		//if self.ActiveButton == Sheet.Button then return end
		me.hovered = false
	end
	
	Sheet.Button.DoClick = function()
		self:SetActiveButton( Sheet.Button )
		surface.PlaySound("ui/buttonclick.wav")
	end

	Sheet.Panel = panel
	Sheet.Panel:SetParent( self.Content )
	Sheet.Panel:SetVisible( false )
	
	if ( self.ButtonOnly ) then
		Sheet.Button:SizeToContents()
		--Sheet.Button:SetColor( Color( 150, 150, 150, 100 ) )
	end
	
	table.insert( self.Items, Sheet )

	if ( !IsValid( self.ActiveButton ) ) then
		self:SetActiveButton( Sheet.Button )
	end

end

function PANEL:SetActiveButton( active )

	if ( self.ActiveButton == active ) then return end

	if ( self.ActiveButton && self.ActiveButton.Target ) then
		self.ActiveButton.Target:SetVisible( false )
		self.ActiveButton:SetSelected( false )
		self.ActiveButton:SetToggle( false )
		--self.ActiveButton:SetColor( Color( 150, 150, 150, 100 ) )
	end

	self.ActiveButton = active
	active.Target:SetVisible( true )
	active:SetSelected( true )
	active:SetToggle( true )
	active.active = true

	self.Content:InvalidateLayout()

end

derma.DefineControl( "SW_DColumnSheet", "", PANEL, "Panel" )


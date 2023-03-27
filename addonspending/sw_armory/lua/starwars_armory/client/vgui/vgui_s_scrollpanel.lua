--[[ Nykez 2017. Do not edit ]]--

local ScrollBack = Material("starhud/derma/scroll/options_rail.png")
local ScrollButUp = Material("starhud/derma/scroll/up_n.png")
local ScrollButUpH = Material("starhud/derma/scroll/up_h.png")
local ScrollButDown = Material("starhud/derma/scroll/down_n.png")
local ScrollButDownH = Material("starhud/derma/scroll/down_h.png")
local ScrollBar = Material("starhud/derma/scroll/scroll_mp_n.png")
local ScrollBarH = Material("starhud/derma/scroll/scroll_mp_a.png")

function StarWars_CreateList(parent)
local list = vgui.Create("DScrollPanel", parent)
local vbar = list.VBar
local up = vbar.btnUp
local down = vbar.btnDown
local grip = vbar.btnGrip
--
  up.OnCursorEntered = function(me)
    me.ins = true
  end
  up.OnCursorExited = function(me)
    me.ins = false
  end
  down.OnCursorEntered = function(me)
    me.ins = true
  end
  down.OnCursorExited = function(me)
    me.ins = false
  end
  grip.OnCursorEntered = function(me)
	me.ins = true
  end
  grip.OnCursorExited = function(me)
	me.ins = false
  end
--
  vbar.Paint = function(me)
    local mat = ScrollBack
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end
  up.Paint = function(me)
    local mat = ScrollButUp
	if me.ins then
	  mat = ScrollButUpH
	end
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())  
  end
  down.Paint = function(me)
    local mat = ScrollButDown
	if me.ins then
	  mat = ScrollButDownH
	end
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())  
  end  
  grip.Paint = function(me)
    local mat = ScrollBar
	if me.ins then
	  mat = ScrollBarH
	end
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end
--
return list
end
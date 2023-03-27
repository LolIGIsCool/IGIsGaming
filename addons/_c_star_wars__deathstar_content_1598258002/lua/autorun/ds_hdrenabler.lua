
-- Created by Mattzi


-- keeping this in for the lolz... and also bcs Steam has issues when deleting files compared to changing files


--if game.GetMap() ~= "rp_deathstar" then return end
--
--if SERVER then 
--	AddCSLuaFile()
--end
--
--if CLIENT then
--	timer.Simple(5, function()
--	local deathstar_mat_hdr_level = GetConVar( "mat_hdr_level" ):GetInt()
--		if deathstar_mat_hdr_level < 2 then
--			local HDRFrame = vgui.Create("DFrame")
--			HDRFrame:SetSize(ScrW()*0.2, ScrH()*0.1)
--			HDRFrame:Center()
--			HDRFrame:MakePopup()
--			HDRFrame:SetTitle("Change HDR Level?")
--			HDRFrame:ShowCloseButton(false)
--		
--			local RichTextHDR = vgui.Create("RichText", HDRFrame)
--			RichTextHDR:InsertColorChange(255,70,70,255)
--			RichTextHDR:Dock(FILL)
--			RichTextHDR:SetVerticalScrollbarEnabled(false)
--			RichTextHDR:AppendText("This map requires HDR to be enabled\n if it isn't enabled the map will be fullbright!")
--		
--			local acceptbutton = vgui.Create("DButton", HDRFrame)
--			acceptbutton:SetText("Activate and reconnect")
--			acceptbutton:Dock(BOTTOM)
--			acceptbutton.DoClick = function()
--				RunConsoleCommand( "mat_hdr_level", "2" )
--				timer.Simple( 3, function() RunConsoleCommand( "retry" ) end )
--			end
--		
--			local leavebutton = vgui.Create("DButton", HDRFrame)
--			leavebutton:SetText("I want to leave")
--			leavebutton:Dock(BOTTOM)
--			leavebutton.DoClick = function()
--				RunConsoleCommand("disconnect")
--			end
--		end
--	end)
--end
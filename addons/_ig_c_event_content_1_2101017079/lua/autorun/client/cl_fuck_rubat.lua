hook.Add("Think", "sfdgsadf", function()	
	net.Receive("chatadd", function(len, pl)
		pl = LocalPlayer()
		local var = net.ReadString()
		white = Color( 240, 240, 240 )
		red = Color( 240, 50, 50 )
		gold = Color(240,240,60)
		if !(pl:IsAdmin() == true) then
			if var == "ad" then
				chat.AddText( red,"► " ,gold, "Hammerfall Networks", white, " provided the content for this server", white,".")
				chat.AddText( red,"► " ,gold, "Hammerfall Networks", white, " is back with Star Wars Roleplay! Check out our server at 74.91.124.48", white,".")
			end
		end
	end)
	
	
end)
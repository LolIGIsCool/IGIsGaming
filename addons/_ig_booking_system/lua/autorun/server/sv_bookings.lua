util.AddNetworkString("netopenbookingmenu")
util.AddNetworkString("addnewBooking")
util.AddNetworkString("removeBooking")
util.AddNetworkString("receiveBooking")
util.AddNetworkString("receiveAllBooking")
hangarbookings = {}
globalmh1booking = ""
globalmh2booking = ""
globaltiebooking = ""
globalmsgbooking = "Message Imperial Navy to make a Booking"

hook.Add("PlayerInitialSpawn", "BookingBroadcastSpawn", function(ply)
    net.Start("receiveAllBooking")
    net.WriteString(globalmh1booking)
    net.WriteString(globalmh2booking)
    net.WriteString(globaltiebooking)
    net.WriteString(globalmsgbooking)
    net.Send(ply)
end)

net.Receive("addnewBooking", function(len, ply)
    if game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        if ply:GetRegiment() == "Imperial Navy" or ply:GetRegiment() == "Imperial Security Bureau" or ply:GetRegiment() == "IHC Administration" or ply:GetRegiment() == "Imperial High Command" or ply:GetRegiment() == "Imperial Naval Engineer" or ply:IsAdmin() then
            local bookedregiment = net.ReadString()
            local formattedregiment
            if string.match(bookedregiment, "MH1") then
                formattedregiment = string.gsub(bookedregiment, "- MH1", "")
                globalmh1booking = formattedregiment
                net.Start("receiveBooking")
                net.WriteString("MH1")
                net.WriteString(formattedregiment)
                net.Broadcast()
            elseif string.match(bookedregiment, "MH2") then
                formattedregiment = string.gsub(bookedregiment, "- MH2", "")
                globalmh2booking = formattedregiment
                net.Start("receiveBooking")
                net.WriteString("MH2")
                net.WriteString(formattedregiment)
                net.Broadcast()
            elseif string.match(bookedregiment, "TIE") then
                formattedregiment = string.gsub(bookedregiment, "- TIE Bays", "")
                globaltiebooking = formattedregiment
                net.Start("receiveBooking")
                net.WriteString("TIE")
                net.WriteString(formattedregiment)
                net.Broadcast()
            end
            if table.HasValue(hangarbookings, bookedregiment) then return end
            local safetable = hangarbookings
			for k, v in pairs(safetable) do
				if string.match(v, "MH1") and string.match(bookedregiment, "MH1") then
					table.RemoveByValue(hangarbookings, v)
				elseif string.match(v, "MH2") and string.match(bookedregiment, "MH2") then
					table.RemoveByValue(hangarbookings, v)
				elseif string.match(v, "TIE") and string.match(bookedregiment, "TIE") then
					table.RemoveByValue(hangarbookings, v)
				end
			end
            table.insert(hangarbookings, bookedregiment)
            
        end
    elseif game.GetMap() == "rp_titan_base_bananakin_ig" then
        if ply:GetRegiment() == "Imperial Navy" or ply:GetRegiment() == "Imperial Security Bureau" or ply:GetRegiment() == "IHC Administration" or ply:GetRegiment() == "Imperial High Command" or ply:GetRegiment() == "Imperial Naval Engineer" or ply:IsAdmin() then
            local bookedregiment = net.ReadString()
            local formattedregiment

            if string.match(bookedregiment, "Training Hangar Alpha") then
                formattedregiment = string.gsub(bookedregiment, "- Training Hangar Alpha", "")
                SetGlobalString("simabooking", formattedregiment)
            elseif string.match(bookedregiment, "Training Hangar Beta") then
                formattedregiment = string.gsub(bookedregiment, "- Training Hangar Beta", "")
                SetGlobalString("simbbooking", formattedregiment)
            elseif string.match(bookedregiment, "Training Hangar Gamma") then
                formattedregiment = string.gsub(bookedregiment, "- Training Hangar Gamma", "")
                --formattedregiment = string.gsub(formattedregiment, "", "")
                --formattedregiment = string.gsub(formattedregiment, "", "")
                SetGlobalString("dockbooking", formattedregiment)
            elseif string.match(bookedregiment, "Training Hangar Delta") then
                formattedregiment = string.gsub(bookedregiment, "- Training Hangar Delta", "")
                --formattedregiment = string.gsub(formattedregiment, "", "")
                --formattedregiment = string.gsub(formattedregiment, "", "")
                SetGlobalString("tiehbbooking", formattedregiment)
            end

            if table.HasValue(hangarbookings, bookedregiment) then return end
			for k, v in pairs(hangarbookings) do
				if string.match(v, "Training Hangar Alpha") and string.match(bookedregiment, "Training Hangar Alpha") then
					table.RemoveByValue(hangarbookings, v)
				elseif string.match(v, "Training Hangar Beta") and string.match(bookedregiment, "Training Hangar Beta") then
					table.RemoveByValue(hangarbookings, v)
				elseif string.match(v, "Training Hangar Gamma") and string.match(bookedregiment, "Training Hangar Gamma") then
					table.RemoveByValue(hangarbookings, v)
				elseif string.match(v, "Training Hangar Delta") and string.match(bookedregiment, "Training Hangar Delta") then
					table.RemoveByValue(hangarbookings, v)
				end
			end
            table.insert(hangarbookings, bookedregiment)
            end
		else
		if ply:GetRegiment() == "Imperial Navy" or ply:GetRegiment() == "Imperial Security Bureau" or ply:GetRegiment() == "IHC Administration" or ply:GetRegiment() == "Imperial High Command" or ply:IsAdmin() or ply:GetRegiment() == "Imperial Naval Engineer" then
            local bookedregiment = net.ReadString()
            local formattedregiment

            if string.match(bookedregiment, "Training Hangar Aurek") then
                formattedregiment = string.gsub(bookedregiment, "- Training Hangar Aurek", "")
                SetGlobalString("simabooking", formattedregiment)
            elseif string.match(bookedregiment, "Training Hangar Besh") then
                formattedregiment = string.gsub(bookedregiment, "- Training Hangar Besh", "")
                SetGlobalString("simbbooking", formattedregiment)
            elseif string.match(bookedregiment, "Training Hangar Cresh") then
                formattedregiment = string.gsub(bookedregiment, "- Training Hangar Cresh", "")
                --formattedregiment = string.gsub(formattedregiment, "", "")
                --formattedregiment = string.gsub(formattedregiment, "", "")
                SetGlobalString("dockbooking", formattedregiment)
            elseif string.match(bookedregiment, "Simulation Field") then
                formattedregiment = string.gsub(bookedregiment, "- Simulation Field", "")
                --formattedregiment = string.gsub(formattedregiment, "", "")
                --formattedregiment = string.gsub(formattedregiment, "", "")
                SetGlobalString("tiehbbooking", formattedregiment)
            end

            if table.HasValue(hangarbookings, bookedregiment) then return end
			for k, v in pairs(hangarbookings) do
				if string.match(v, "Training Hangar Aurek") and string.match(bookedregiment, "Training Hangar Aurek") then
					table.RemoveByValue(hangarbookings, v)
				elseif string.match(v, "Training Hangar Besh") and string.match(bookedregiment, "Training Hangar Besh") then
					table.RemoveByValue(hangarbookings, v)
				elseif string.match(v, "Training Hangar Cresh") and string.match(bookedregiment, "Training Hangar Cresh") then
					table.RemoveByValue(hangarbookings, v)
				elseif string.match(v, "Simulation Field") and string.match(bookedregiment, "Simulation Field") then
					table.RemoveByValue(hangarbookings, v)
				end
			end
            table.insert(hangarbookings, bookedregiment)
        end
	end
end)

-- end
net.Receive("removeBooking", function(len, ply)
    if game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        if ply:GetRegiment() == "Imperial Navy" or ply:GetRegiment() == "Imperial Security Bureau" or ply:GetRegiment() == "IHC Administration" or ply:GetRegiment() == "Imperial High Command" or ply:IsAdmin() or ply:GetRegiment() == "Imperial Naval Engineer" then
            local removedregiment = net.ReadString()

            if string.match(removedregiment, "MH1") then
                globalmh1booking = ""
                net.Start("receiveBooking")
                net.WriteString("MH1")
                net.WriteString("")
                net.Broadcast()
            elseif string.match(removedregiment, "MH2") then
                globalmh2booking = ""
                net.Start("receiveBooking")
                net.WriteString("MH2")
                net.WriteString("")
                net.Broadcast()
            elseif string.match(removedregiment, "TIE") then
                globaltiebooking = ""
                net.Start("receiveBooking")
                net.WriteString("TIE")
                net.WriteString("")
                net.Broadcast()
            end

            table.RemoveByValue(hangarbookings, removedregiment)
        end
    elseif game.GetMap() == "rp_titan_base_bananakin_ig" then
        if ply:GetRegiment() == "Imperial Navy" or ply:GetRegiment() == "Imperial Security Bureau" or ply:GetRegiment() == "IHC Administration" or ply:GetRegiment() == "Imperial High Command" or ply:IsAdmin() or ply:GetRegiment() == "Imperial Naval Engineer" then
            local removedregiment = net.ReadString()

            if string.match(removedregiment, "Training Hangar Alpha") then
                SetGlobalString("simabooking", "")
            elseif string.match(removedregiment, "Training Hangar Beta") then
                SetGlobalString("simbbooking", "")
            elseif string.match(removedregiment, "Training Hangar Gamma") then
                SetGlobalString("dockbooking", "")
            elseif string.match(removedregiment, "Training Hangar Delta") then
                SetGlobalString("tiehbbooking", "")
            end

            table.RemoveByValue(hangarbookings, removedregiment)
        end
	else
        if ply:GetRegiment() == "Imperial Navy" or ply:GetRegiment() == "Imperial Security Bureau" or ply:GetRegiment() == "IHC Administration" or ply:GetRegiment() == "Imperial High Command" or ply:IsAdmin() or ply:GetRegiment() == "Imperial Naval Engineer" then
            local removedregiment = net.ReadString()

            if string.match(removedregiment, "Training Hangar Aurek") then
                SetGlobalString("simabooking", "")
            elseif string.match(removedregiment, "Training Hangar Besh") then
                SetGlobalString("simbbooking", "")
            elseif string.match(removedregiment, "Training Hangar Cresh") then
                SetGlobalString("dockbooking", "")
            elseif string.match(removedregiment, "Simulation Field") then
                SetGlobalString("tiehbbooking", "")
            end

            table.RemoveByValue(hangarbookings, removedregiment)
        end
    end
end)

hook.Add("IGPlayerSay", "OpenPilotLicenseMenuthing", function(ply, txt)
    if (string.lower(txt) == "!book") or (string.lower(txt) == "!booking") or (string.lower(txt) == "!bookings") then
        if ply:GetRegiment() == "Imperial Navy" or ply:GetRegiment() == "Imperial Security Bureau" or ply:GetRegiment() == "IHC Administration" or ply:GetRegiment() == "Imperial High Command" or ply:IsAdmin() or ply:GetRegiment() == "Imperial Naval Engineer" then
            net.Start("netopenbookingmenu")
            net.WriteTable(hangarbookings)
            net.Send(ply)
        end

        return ""
    end
end)
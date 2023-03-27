--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

























































































































































local addon = {}

local recordingScenes = {}

local textData = {
	Color(255,150,150),
	"[Scene System] "
}

net.Receive("wOS.PES.Scene.StartRecording", function()

	local entIndex = net.ReadDouble()
	for index, dermaE in ipairs(recordingScenes) do
		if IsValid(dermaE) then
			dermaE.data[#dermaE.data + 1] = entIndex
		end
	end
end)

addon.StartRecording = function(dermaElement)
	for index, dermaE in ipairs(recordingScenes) do
		if !IsValid(dermaE) then
			table.RemoveByValue(recordingScenes, dermaE)
		end
	end

	local len = #recordingScenes

	recordingScenes[len + 1] = dermaElement

	if len == 0 then
		chat.AddText(textData[1], textData[2], color_white, "Please spawn props and position them how you want to. Once you are finished open the menu again and press the recording button, ", Color(150,150,150), "if you dont do this it won't save!!!")
	end

	chat.AddText( textData[1], textData[2], color_white, tostring(len + 1), " Active Recordings")

	net.Start("wOS.PES.Scene.StartRecording")
	net.SendToServer()

end

addon.StopRecording = function(dermaElement)
	table.RemoveByValue(recordingScenes, dermaElement)
	
	if #recordingScenes == 0 then
		net.Start("wOS.PES.Scene.StopRecording")
		net.SendToServer()
	end
end


wOS.PES.Modules:RegisterAddon( addon )
local function checkForTFA()
	if TFA and TFA_BASE_VERSION and TFA_BASE_VERSION >= 4 then return end -- we're 100% good

	if CLIENT then
		
	else
		print("#################### WARNING!!! ####################")
		print("The weapon(s) you have installed requires TFA Base.")
		print("http://steamcommunity.com/workshop/filedetails/?id=415143062")
		print("####################################################")
	end
end

hook.Add("InitPostEntity", "INSTALL TFA BASE", checkForTFA)
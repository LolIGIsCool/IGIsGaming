function cl_HideyoshiSetGroundOrto(materials1, settings)
    --local displacement = "LORDTRILOBITE/SNOW_ROCKS_BLEND01"
    --
    local ground_orto = "LORDTRILOBITE/SNOW01"
	local data = sh_HideyoshiCreateDataTable(LocalPlayer(), { oldMaterial = ground_orto }, settings)

    if !(materials1) then
		chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - materials1 is not valid")
        return
    end

    if !(sh_HideyoshiValidateMaterials(materials1)) then
		chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - materials1 is not a valid material")
        return
    end

    net.Start("HideyoshiOR.SetOrtoGround")
        net.WriteString(ground_orto)
        net.WriteString(materials1)
        net.WriteTable(data)
    net.SendToServer()
end

net.Receive("cl_applychanges", function()
    sh_HideyoshiApplyChanges(LocalPlayer(), net.ReadTable(), false)
end)

function cl_setorto(data, type) 
    local oldMaterial = Material(data.oldMaterial)
	if data.newMaterial and Material(data.newMaterial):GetTexture("$basetexture") then
		oldMaterial:SetTexture("$basetexture", Material(data.newMaterial):GetTexture("$basetexture"))
	else
		print("Check 1 - $basetexture failed")
		chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - (Check 1) $basetexture set failed")
	end

	if type == "Displacements" then
		if data.newMaterial2 and Material(data.newMaterial2):GetTexture("$basetexture") then
			oldMaterial:SetTexture("$basetexture2", Material(data.newMaterial2):GetTexture("$basetexture"))
		else
			print("Check 2 - $basetexture2 failed")
			chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - (Check 2) $basetexture2 set failed")
		end
	end

	if data.alpha then
		oldMaterial:SetString("$translucent", "1")
		oldMaterial:SetString("$alpha", data.alpha)
	else
		print("Check 3 - $alpha failed")
		chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - (Check 3) $alpha set failed")
	end

	local textureMatrix = oldMaterial:GetMatrix("$basetexturetransform")
	local matrixChanged = false

	if textureMatrix and data.rotation then
		textureMatrix:SetAngles(Angle(0, data.rotation, 0)) 
		matrixChanged = true
	else
		print("Check 4 - Rotation failed")
		chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - (Check 4) Rotation failed")
	end

	if textureMatrix and (data.scaleX or data.scaleY) then
		textureMatrix:SetScale(Vector(1/(data.scaleX or 1), 1/(data.scaleY or 1), 1))
		if not matrixChanged then matrixChanged = true; end
	else
		print("Check 5 - Scale failed")
		chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - (Check 5) Scale failed")
	end

	if textureMatrix and (data.offsetX or data.offsetY) then
		textureMatrix:SetTranslation(Vector(data.offsetX or 0, data.offsetY or 0)) 
		if not matrixChanged then matrixChanged = true; end
	else
		print("Check 6 - Offset failed")
		chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - (Check 6) Offset failed")
	end

	if matrixChanged then
		oldMaterial:SetMatrix("$basetexturetransform", textureMatrix)
	else
		print("Check 7 - Matrix Application failed")
		chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - (Check 7) Matrix Application failed")
	end
end
function cl_HideyoshiSetOrtoDisplacements(materials1, materials2, settings)
    --local displacement = "LORDTRILOBITE/SNOW_ROCKS_BLEND01"
    --LORDTRILOBITE/SNOW01
    local displacement = "LORDTRILOBITE/SNOW_ROCKS_BLEND01"
	local data = sh_HideyoshiCreateDataTable(LocalPlayer(), { oldMaterial = displacement }, settings)

    if !(materials1) or !(materials2) then
        chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - Either materials1 or materials2 is not valid")
        return    
    end

    if !(sh_HideyoshiValidateMaterials(materials1)) or !(sh_HideyoshiValidateMaterials(materials2)) then
        chat.AddText(Color( 137, 222, 255 ), "[Orto Customizer] Error - Either materials1 or materials2 is not a valid material")
        return
    end

    net.Start("HideyoshiOR.SetOrtoDisplacements")
        net.WriteString(displacement)
        net.WriteString(materials1)
        net.WriteString(materials2)
        net.WriteTable(data)
    net.SendToServer()
end
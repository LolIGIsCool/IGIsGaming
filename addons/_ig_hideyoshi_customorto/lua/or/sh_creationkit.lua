if SERVER then
    util.AddNetworkString("cl_applychanges")
end

materials_backup = {}
or_current_materials = {}

function sh_HideyoshiValidateMaterials(material)
    if not material then return false end
    local ConvertMaterial = Material(material)
    local Validity = false

    if CLIENT then
        if ConvertMaterial:IsError() then
            Validity = false
        elseif ConvertMaterial:GetTexture("$basetexture") then
            Validity = true
        end
    elseif SERVER then
        if Material(material) and not Material(material):IsError() then
            Validity = true
        end
    end

    return Validity
end

function sh_HideyoshiCreateDataTable(ply, materialInfo, settings)
    local data = {
        ent = game.GetWorld(),
        oldMaterial = materialInfo and materialInfo.oldMaterial or "",
        offsetX = settings[3] or 0,
        offsetY = settings[4] or 0,
        scaleX = settings[1] or 1,
        scaleY = settings[2] or 1,
        rotation = settings[5] or 0,
        alpha = string.format("%.2f", Material(materialInfo.oldMaterial):GetString("$alpha") or 1) or nil
    }

    return data
end

function sh_HideyoshiCreateDataTableFromMaterial(oldMaterialIn, newMaterial, newMaterial2)
    local oldMaterial = Material(oldMaterialIn)
    if not oldMaterial then return end
    local scaleX = oldMaterial:GetMatrix("$basetexturetransform") and oldMaterial:GetMatrix("$basetexturetransform"):GetScale() and oldMaterial:GetMatrix("$basetexturetransform"):GetScale()[1] or "1.00"
    local scaleY = oldMaterial:GetMatrix("$basetexturetransform") and oldMaterial:GetMatrix("$basetexturetransform"):GetScale() and oldMaterial:GetMatrix("$basetexturetransform"):GetScale()[2] or "1.00"
    local offsetX = oldMaterial:GetMatrix("$basetexturetransform") and oldMaterial:GetMatrix("$basetexturetransform"):GetTranslation() and oldMaterial:GetMatrix("$basetexturetransform"):GetTranslation()[1] or "0.00"
    local offsetY = oldMaterial:GetMatrix("$basetexturetransform") and oldMaterial:GetMatrix("$basetexturetransform"):GetTranslation() and oldMaterial:GetMatrix("$basetexturetransform"):GetTranslation()[2] or "0.00"

    local data = {
        ent = game.GetWorld(),
        oldMaterial = oldMaterialIn,
        newMaterial = newMaterial or nil,
        newMaterial2 = newMaterial2 or nil,
        offsetX = string.format("%.2f", math.floor(offsetX * 100) / 100) or nil,
        offsetY = string.format("%.2f", math.floor(offsetY * 100) / 100) or nil,
        scaleX = string.format("%.2f", math.ceil((1 / scaleX) * 1000) / 1000),
        scaleY = string.format("%.2f", math.ceil((1 / scaleY) * 1000) / 1000),
        rotation = (oldMaterial:GetMatrix("$basetexturetransform") and oldMaterial:GetMatrix("$basetexturetransform"):GetAngles() and string.format("%.2f", oldMaterial:GetMatrix("$basetexturetransform"):GetAngles().y)) or nil,
        alpha = string.format("%.2f", oldMaterial:GetString("$alpha") or 1) or nil,
    }

    return data
end

function sh_firststeps(ply, check, data, type)
    if not ply then return false end

    if check then
        --if CLIENT then
        if not sh_HideyoshiValidateMaterials(check.material) then return false end

        if type == "Displacements" and not sh_HideyoshiValidateMaterials(check.material2) then
            return false
        end
        --end
    end

    return true
end

function sh_Hideyoshi_GetBackup(type)
    if type == "Displacements" then
        return "or/orto_disp_backup", "or/orto_disp_backup0"
    elseif type == "Map" then
        return "or/orto_ground_backup"
    end

    return nil
end

function sh_Hideyoshi_ifSame(Material1, Material2, type)
    if type == "Map" and Material1 == "lordtrilobite/snow01" then
        return true
    else
        if type == "Map" and Material1 == "lordtrilobite/snow01" and Material2 == "lordtrilobite/snowrocks01" then return true end

        return false
    end
end

function sh_HideyoshiApplyChanges(ply, data, broadcast)
    if not ply then return end

    if broadcast then
        if SERVER and not (ply:IsAdmin() or ply:GetRegiment() == "Imperial Navy") then
            ply:PrintMessage(HUD_PRINTTALK, "[Orto Customizer] You do not have permission to use this tool")

            return
        end

        if SERVER and ( !string.match(game.GetMap(), "rp_stardestroyer") ) then
            PrintMessage(HUD_PRINTTALK, "[Orto Customizer] Not on rp_stardestroyer_v2_5_inf")

            return
        end
    end

    local map_select = {}

    if data.oldMaterial == "LORDTRILOBITE/SNOW_ROCKS_BLEND01" then
        map_select.isDisplacement = true
        map_select.type = "Displacements"
        or_current_materials.displacement_data = data
    else
        map_select.isDisplacement = false
        map_select.type = "Map"
        or_current_materials.map_data = data
    end

    local check

    if map_select.type == "Displacements" then
        check = {
            material = data.newMaterial,
            material2 = data.newMaterial2
        }
    else
        check = {
            material = data.newMaterial,
        }
    end

    if not sh_firststeps(ply, check, data, map_select.type) then return end

    if SERVER then
        net.Start("cl_applychanges")
        net.WriteTable(data)
        net.WriteBool(true)

        if broadcast then
            net.Broadcast()
        elseif not broadcast then
            net.Send(ply)
        end
    end

    if (table.HasValue(table.GetKeys(materials_backup), data.oldMaterial)) then
        if CLIENT then
            if map_select.type == "Map" then
                cl_setorto(materials_backup[data.oldMaterial], map_select.type)
                cl_setDisplayMaterial("models/props/cs_office/snowmana", map_select.type)
            else
                if map_select.type == "Displacements" then
                    cl_setorto(materials_backup[data.oldMaterial], map_select.type)
                end
            end

			if sh_Hideyoshi_ifSame(data.newMaterial, data.material2, map_select.type) then return end

        end
    else
		data.backup = sh_HideyoshiCreateDataTableFromMaterial(data.oldMaterial, sh_Hideyoshi_GetBackup(map_select.type))

		if data.newMaterial then
			Material(data.backup.newMaterial):SetTexture("$basetexture", Material(data.oldMaterial):GetTexture("$basetexture"))
		end

		if data.newMaterial2 then
			Material(data.backup.newMaterial2):SetTexture("$basetexture", Material(data.oldMaterial):GetTexture("$basetexture2"))
		end

		materials_backup[data.oldMaterial] = data.backup
	end

    if CLIENT and data and istable(data) and data.oldMaterial ~= nil then
        cl_setDisplayMaterial(data.newMaterial, map_select.type)
        cl_setorto(data, map_select.type)
    end
    
end


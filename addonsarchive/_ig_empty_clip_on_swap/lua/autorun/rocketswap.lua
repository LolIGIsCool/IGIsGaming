if SERVER then
    -- This is a list of weapons that should be unloaded on swap
    --local UnloadOnSwap = {"rw_sw_smartlauncher", "rw_sw_iqa11", "rw_sw_dlt19d", "rw_sw_huntershotgun", "rw_sw_scattershotgun", "rw_sw_dp23", "rw_sw_tusken_cycler", "rw_sw_e5s", "rw_sw_nt242c", "str_sw_iqa11_carbine", "rw_sw_e11s", "rw_sw_dlt20a", "rw_sw_dc15x", "rw_sw_nt242"}

	local UnloadOnSwap = {"weapons_not_doing_this_anymore"}
	
    hook.Add("PlayerSwitchWeapon", "SwapUnload", function(player, oldwep, newwep)
        if not IsValid(newwep) then return false end

        if table.HasValue(UnloadOnSwap, newwep:GetClass()) then
            local InClip = newwep:Clip1()
            newwep:SetClip1(0)
            player:GiveAmmo(InClip, newwep:GetPrimaryAmmoType(), true)
        end
    end)
end

--Config GUI

if CLIENT then
	language.Add("chromadmg.preset_sharp","Sharp")
	local function CreateConfigPanel(panel)
		--Here are whatever default categories you want.
		local Presets = {
			Options = {},
			CVars = {},
			Label = "#Presets",
			MenuButton = "1",
			Folder = "TFAChromADMG"
		}

		Presets.Options["#preset.default"] = {
			cl_tfa_chromadmg_enable = "1",
			cl_tfa_chromadmg_strength = "1",
			cl_tfa_chromadmg_recovery = "1",
			cl_tfa_chromadmg_minimum = "1",
			cl_tfa_chromadmg_maximum = "1",
			cl_tfa_chromadmg_healthscale = "1"
		}

		Presets.Options["#chromadmg.preset_sharp"] = {
			cl_tfa_chromadmg_enable = "1",
			cl_tfa_chromadmg_strength = "1.75",
			cl_tfa_chromadmg_recovery = "2.5",
			cl_tfa_chromadmg_minimum = "1",
			cl_tfa_chromadmg_maximum = "1",
			cl_tfa_chromadmg_healthscale = "1"
		}

		Presets.CVars = table.GetKeys( Presets.Options[ "#preset.default" ] )

		panel:AddControl("ComboBox", Presets)

		--These are the panel controls.  Adding these means that you don't have to go into the console.

		panel:AddControl("CheckBox", {
			Label = "Enable",
			Command = "cl_tfa_chromadmg_enable"
		})

		panel:AddControl("Slider", {
			Label = "Strength Multiplier",
			Command = "cl_tfa_chromadmg_strength",
			Type = "Float",
			Min = "0",
			Max = "5"
		})

		panel:AddControl("Slider", {
			Label = "Recovery Speed",
			Command = "cl_tfa_chromadmg_recovery",
			Type = "Float",
			Min = "0",
			Max = "5"
		})

		panel:AddControl("Slider", {
			Label = "Minimum Intensity",
			Command = "cl_tfa_chromadmg_minimum",
			Type = "Float",
			Min = "0",
			Max = "5"
		})

		panel:AddControl("Slider", {
			Label = "Maximum Intensity",
			Command = "cl_tfa_chromadmg_maximum",
			Type = "Float",
			Min = "0",
			Max = "5"
		})

		panel:AddControl("Slider", {
			Label = "Low Health Effect Strength",
			Command = "cl_tfa_chromadmg_healthscale",
			Type = "Float",
			Min = "0",
			Max = "5"
		})

		panel:AddControl("Label", {
			Text = "By TheForgottenArchitect"
		})
	end

	local function PopulateMenu()
		spawnmenu.AddToolMenuOption("Options", "ChromA Damage", "TFAChromADamageIndicator", "Clientside", "", "", CreateConfigPanel)
	end

	hook.Add("PopulateToolMenu", "ChromADamage_PopulateMenu", PopulateMenu)
else
	AddCSLuaFile()
end

-------------------------------------------------------- FONTS --------------------------------------------------------
surface.CreateFont("title", {size = 25, weight = 500})
surface.CreateFont("subtitle", {size = 22, weight = 500})
surface.CreateFont("label", {size = 20, weight = 500})
surface.CreateFont("button", {size = 15, weight = 500})

local bracketColor = Color(0, 0, 0, 255)
local addonColour = Color(52, 119, 235, 255)
local msgColor = Color(255, 255, 255, 255)
local uiHighlight = Color(0, 255, 200, 255)

local ecPresets = nil
local managePresetDisplay = nil
local currentValues = nil

----------------------------------------------------- NET MESSAGES ----------------------------------------------------
net.Receive("ecm_openDerma", function()
	ecPresets = net.ReadTable()
	currentValues = net.ReadTable()
	MakeWindow(ecPresets)
end)

net.Receive("ecm_addClientChatMessage", function()
	local msg = net.ReadString()
	ShowChatMessage(msg)
end)

net.Receive("ecm_getCurrentValues", function()
	currentValues = net.ReadTable()
end)

net.Receive("ecm_updatePresetList", function()
	ecPresets = net.ReadTable()
end)

net.Receive("ecm_getPresetByName", function()
	managePresetDisplay = net.ReadTable()
end)

----------------------------------------------------- MAIN WINDOW -----------------------------------------------------

function MakeWindow (ecPresets)
	local w = ScrW()
	local h = ScrH()

	local frame = vgui.Create("DFrame")
	frame:SetSize(0.45*w, 0.45*h)
	frame:Center()
	frame:SetVisible(true)
	frame:MakePopup()
	frame:SetTitle("")
	frame.Paint = function ()
		surface.SetDrawColor(32, 32, 32, 255)
		surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
	end

	---------- PANELS ----------
	-- Left Nav Bar
	local leftPanel = vgui.Create("DPanel", frame)
	leftPanel:SetSize(0.11 * frame:GetWide(), frame:GetTall())
	leftPanel.Paint = function ()
		surface.SetDrawColor(110, 0, 227, 255)
		surface.DrawRect(0, 0, leftPanel:GetWide(), leftPanel:GetTall())
	end

	local activeIndicator = vgui.Create("DPanel", leftPanel) -- Declare active indicator panel here to avoid error

	-- Main Panel
	local mainPanel = vgui.Create("DPanel", frame)
	mainPanel:SetSize(frame:GetWide() - leftPanel:GetWide(), frame:GetTall())
	mainPanel:SetPos(leftPanel:GetWide(), 0)
	mainPanel.Paint = function ()
		surface.SetDrawColor(32, 32, 32, 255)
		surface.DrawRect(0, 0, mainPanel:GetWide(), mainPanel:GetTall())
	end

	---------- BUTTONS ----------
	-- Main Menu Button
	local mainMenuButton = vgui.Create("DImageButton", leftPanel)
	mainMenuButton:SetImage("home.png")
	mainMenuButton:SizeToContents()
	mainMenuButton:SetPos(0.5 * leftPanel:GetWide() - 0.5 * mainMenuButton:GetWide(), 0.1 * leftPanel:GetTall() - 0.5 * mainMenuButton:GetTall())
	mainMenuButton.DoClick = function ()
		IndicateActivePage(mainMenuButton, activeIndicator, leftPanel)
		MainMenu(mainPanel)
	end

	-- Setup active indicator here to avoid error
	activeIndicator:SetSize(2, mainMenuButton:GetTall())
	activeIndicator:SetPos(leftPanel:GetWide() - 2, 0.1 * leftPanel:GetTall() - 0.5 * mainMenuButton:GetTall())
	activeIndicator.Paint = function ()
		surface.SetDrawColor(uiHighlight)
		surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
	end

	-- Make Preset Button
	local makePresetButton = vgui.Create("DImageButton", leftPanel)
	makePresetButton:SetImage("makepreset.png")
	makePresetButton:SizeToContents()
	makePresetButton:SetPos(0.5 * leftPanel:GetWide() - 0.5 * makePresetButton:GetWide(), 0.3 * leftPanel:GetTall() - 0.5 * makePresetButton:GetTall())
	makePresetButton.DoClick = function ()
		IndicateActivePage(makePresetButton, activeIndicator, leftPanel)
		MakePreset(mainPanel)
	end

	-- Manage Presets Button
	local managePresetButton = vgui.Create("DImageButton", leftPanel)
	managePresetButton:SetImage("managepreset.png")
	managePresetButton:SizeToContents()
	managePresetButton:SetPos(0.5 * leftPanel:GetWide() - 0.5 * managePresetButton:GetWide(), 0.5 * leftPanel:GetTall() - 0.5 * managePresetButton:GetTall())
	managePresetButton.DoClick = function ()
		IndicateActivePage(managePresetButton, activeIndicator, leftPanel)
		ManagePreset(mainPanel)
	end

	-- Exit Button
	local exitButton = vgui.Create("DImageButton", leftPanel)
	exitButton:SetImage("exit.png")
	exitButton:SizeToContents()
	exitButton:SetPos(0.5 * leftPanel:GetWide() - 0.5 * exitButton:GetWide(), 0.9 * leftPanel:GetTall() - 0.5 * exitButton:GetTall())
	exitButton.DoClick = function ()
		frame:Close()
	end

	MainMenu(mainPanel)
end

------------------------------------------------------ FUNCTIONS ------------------------------------------------------
-- Adds a message to the clients chat window
function ShowChatMessage (msg)
	chat.AddText(bracketColor, "[", addonColour, "EC MANAGER", bracketColor, "] ", msgColor, msg)
end

-- Sets the indicator panel to be inline with the page that is currently being displayed.
function IndicateActivePage (page, indicator, parentPanel)
	local posX, posY = page:GetPos()
	--indicator:SetPos(parentPanel:GetWide() - 2, posY)
	indicator:MoveTo(parentPanel:GetWide() - 2, posY, 0.1, 0, -999)
end

function UpdateCurrentValuesDisplay (modelContainer, weaponContainer, nameContainer, authorContainer, healthContainer, data)
	modelContainer:SetText("")
	for _, v in pairs(data["ecModels"]) do
		modelContainer:SetText(modelContainer:GetText() .. "\n" .. v)
	end

	weaponContainer:SetText("")
	for _, v in pairs(data["ecWeapons"]) do
		weaponContainer:SetText(weaponContainer:GetText() .. "\n" .. v)
	end

	nameContainer:SetText("Preset Name: " .. data["presetName"])
	nameContainer:SizeToContents()

	authorContainer:SetText("Preset Author: " .. data["author"])
	authorContainer:SizeToContents()

	local hpContainerText = string.Explode(" ", healthContainer:GetText())
	if (#hpContainerText > 2) then
		hpContainerText = hpContainerText[1] .. " " .. hpContainerText[2] .. " "
		healthContainer:SetText(hpContainerText .. data["ecHealth"])
	else
		healthContainer:SetText(data["ecHealth"])
	end
	healthContainer:SizeToContents()
end

----------------------------------------------------- PAGE SETUPS -----------------------------------------------------

-------------------- Main Menu --------------------
-- Shows the derma for the main menu page
function MainMenu (parent)
	parent:Clear()

	local prevX, prevY

	local heading = vgui.Create("DLabel", parent)
	heading:SetText("Main Menu")
	heading:SetFont("title")
	heading:SizeToContents()
	heading:SetPos(0.5 * parent:GetWide() - 0.5 * heading:GetWide(), 0.02 * parent:GetTall())

	-- Preset drop down
	local presetDD = vgui.Create("DComboBox", parent)
	presetDD:SetFont("label")
	presetDD:SetValue("Available Presets...")
	presetDD:SetSize(0.7 * parent:GetWide(), 0.06 * parent:GetTall())
	presetDD:SetPos(0.05 * parent:GetWide(), 0.1 * parent:GetTall())
	if(ecPresets ~= nil) then
		for k, v in pairs(ecPresets) do
			presetDD:AddChoice(v)
		end
	end
	prevX, prevY = presetDD:GetPos()

	-- Load Preset Button
	local loadPresetButton = vgui.Create("DButton", parent)
	loadPresetButton:SetText("Load")
	loadPresetButton:SetFont("label")
	loadPresetButton:SetTextColor(Color(11, 200, 36, 255))
	loadPresetButton:SetSize(0.2 * parent:GetWide() - 0.01 * parent:GetWide(), presetDD:GetTall())
	loadPresetButton:SetPos(prevX + presetDD:GetWide() + 0.01 * parent:GetWide(), prevY)
	local barStatus = 0
	local speed = 8
	loadPresetButton.Paint = function (self, w, h)
		if (self:IsHovered()) then
			barStatus = math.Clamp(barStatus + speed * RealFrameTime(), 0, 1)
		else
			barStatus = math.Clamp(barStatus - speed * RealFrameTime(), 0, 1)
		end

		surface.SetDrawColor(45, 45, 45, 255)
		surface.DrawRect(0, 0, loadPresetButton:GetWide(), loadPresetButton:GetTall())

		surface.SetDrawColor(uiHighlight)
		surface.DrawRect(0, loadPresetButton:GetTall() * 0.9, loadPresetButton:GetWide() * barStatus, 2)
	end

	-- Current Preset
	local currentLabel = vgui.Create("DLabel", parent)
	currentLabel:SetText("Current Values")
	currentLabel:SetFont("subtitle")
	currentLabel:SizeToContents()
	currentLabel:SetPos(0.5 * parent:GetWide() - 0.5 * currentLabel:GetWide(), prevY + currentLabel:GetTall() + 0.05 * parent:GetTall())
	prevX, prevY = currentLabel:GetPos()

	-- Label for models
	local modelPreviewLabel = vgui.Create("DLabel", parent)
	modelPreviewLabel:SetText("Models")
	modelPreviewLabel:SetFont("label")
	modelPreviewLabel:SizeToContents()

	modelPreviewLabel:SetPos(0.5 * (1/3) * parent:GetWide() - 0.5 * modelPreviewLabel:GetWide() + 0.05 * parent:GetWide(), 
		prevY + modelPreviewLabel:GetTall() + 0.05 * parent:GetTall())

	-- Label for weapons
	local weaposPreviewLabel = vgui.Create("DLabel", parent)
	weaposPreviewLabel:SetText("Weapons")
	weaposPreviewLabel:SetFont("label")
	weaposPreviewLabel:SizeToContents()

	weaposPreviewLabel:SetPos(0.5 * parent:GetWide() - 0.5 * weaposPreviewLabel:GetWide(), 
		prevY + weaposPreviewLabel:GetTall() + 0.05 * parent:GetTall())

	-- Label for other vals
	local otherValuesPreviewLabel = vgui.Create("DLabel", parent)
	otherValuesPreviewLabel:SetText("Other")
	otherValuesPreviewLabel:SetFont("label")
	otherValuesPreviewLabel:SizeToContents()

	local placeholderX = (parent:GetWide() - 1/3 * parent:GetWide())
	local dist = (parent:GetWide() - placeholderX) - 0.05 * parent:GetWide()

	otherValuesPreviewLabel:SetPos(placeholderX + 0.5 * dist - 0.5 * otherValuesPreviewLabel:GetWide(), 
		prevY + otherValuesPreviewLabel:GetTall() + 0.05 * parent:GetTall())

	prevX, prevY = otherValuesPreviewLabel:GetPos()

	-- Models
	local modelPreview = vgui.Create("DTextEntry", parent)
	modelPreview:SetMultiline(true)
	modelPreview:SetFont("label")
	--modelPreview:SetText(currentValues["ecModels"])
	modelPreview:SetSize(0.83 * 1/3 * parent:GetWide() - 0.05, 0.6 * parent:GetTall())
	modelPreview:SetPos(0.5 * (1/3) * parent:GetWide() - 0.5 * modelPreview:GetWide() + 0.05 * parent:GetWide(), 
		prevY + modelPreviewLabel:GetTall() + 0.01 * parent:GetTall())
	for _, v in pairs(currentValues["ecModels"]) do
		modelPreview:SetText(modelPreview:GetText() .. "\n" .. v)
	end

	-- Weapons
	local weaponPreview = vgui.Create("DTextEntry", parent)
	weaponPreview:SetMultiline(true)
	weaponPreview:SetFont("label")
	weaponPreview:SetSize(0.83 * 1/3 * parent:GetWide() - 0.05, 0.6 * parent:GetTall())
	weaponPreview:SetPos(0.5 * parent:GetWide() - 0.5 * weaponPreview:GetWide(), 
		prevY + weaposPreviewLabel:GetTall() + 0.01 * parent:GetTall())
	for _, v in pairs(currentValues["ecWeapons"]) do
		weaponPreview:SetText(weaponPreview:GetText() .. "\n" .. v)
	end

	-- Preset Name
	local ecPresetNameLabel = vgui.Create("DLabel", parent)
	ecPresetNameLabel:SetText("Preset Name: " .. currentValues["presetName"])
	ecPresetNameLabel:SetFont("label")
	ecPresetNameLabel:SizeToContents()
	ecPresetNameLabel:SetPos(parent:GetWide() - 1/3 * parent:GetWide(), prevY + otherValuesPreviewLabel:GetTall() + 0.01 * parent:GetTall())
	prevX, prevY = ecPresetNameLabel:GetPos()

	-- Preset Author
	local ecPresetAuthorLabel = vgui.Create("DLabel", parent)
	ecPresetAuthorLabel:SetText("Preset Author: " .. currentValues["author"])
	ecPresetAuthorLabel:SetFont("label")
	ecPresetAuthorLabel:SizeToContents()
	ecPresetAuthorLabel:SetPos(parent:GetWide() - 1/3 * parent:GetWide(), prevY + ecPresetNameLabel:GetTall() + 0.01 * parent:GetTall())
	prevX, prevY = ecPresetAuthorLabel:GetPos()

	-- Preset HP
	local ecPresetHpLabel = vgui.Create("DLabel", parent)
	ecPresetHpLabel:SetText("Preset Health: " .. currentValues["ecHealth"])
	ecPresetHpLabel:SetFont("label")
	ecPresetHpLabel:SizeToContents()
	ecPresetHpLabel:SetPos(parent:GetWide() - 1/3 * parent:GetWide(), prevY + ecPresetAuthorLabel:GetTall() + 0.01 * parent:GetTall())
	prevX, prevY = ecPresetHpLabel:GetPos()

	loadPresetButton.DoClick = function ()
		if (presetDD:GetValue() ~= "Available Presets...") then
			net.Start("ecm_loadPreset")
			net.WriteString(presetDD:GetValue())
			net.SendToServer()

			timer.Create("ecm_awaitCurrentValuesUpdate", 0.5, 1, function ()
				UpdateCurrentValuesDisplay(modelPreview, weaponPreview, ecPresetNameLabel, ecPresetAuthorLabel, ecPresetHpLabel, currentValues)
			end)
			
		else
			ShowChatMessage("You need to select a preset.")
		end
	end

end

------------------- Make Preset -------------------
-- Shows the derma for the make presets page
function MakePreset (parent)
	parent:Clear()
	local prevX, prevY -- Used to store the X and Y position of the previous element

	-- Page title
	local heading = vgui.Create("DLabel", parent)
	heading:SetText("Make Preset")
	heading:SetFont("title")
	heading:SizeToContents()
	heading:SetPos(0.5 * parent:GetWide() - 0.5 * heading:GetWide(), 0.02 * parent:GetTall())

	-- Preset name input
	local nameField = vgui.Create("DTextEntry", parent)
	nameField:SetFont("label")
	nameField:SetSize(0.7 * parent:GetWide(), 0.06 * parent:GetTall())
	nameField:SetPos(0.05 * parent:GetWide(), 0.1 * parent:GetTall())
	prevX, prevY = nameField:GetPos()

	-- Preset name label
	local nameLabel = vgui.Create("DLabel", parent)
	nameLabel:SetText("Preset Name")
	nameLabel:SetFont("label")
	nameLabel:SizeToContents()
	nameLabel:SetPos(0.8 * parent:GetWide(), prevY + 0.5 * nameField:GetTall() - 0.5 * nameLabel:GetTall())

	-- Model input
	local modelField = vgui.Create("DTextEntry", parent)
	modelField:SetFont("label")
	modelField:SetMultiline(true)
	modelField:SetSize(0.7 * parent:GetWide(), 0.29 * parent:GetTall())
	modelField:SetPos(prevX, prevY + 0.03 * parent:GetTall() + nameField:GetTall())
	prevX, prevY = modelField:GetPos()


	-- Model label
	local modelLabel = vgui.Create("DLabel", parent)
	modelLabel:SetText("Models")
	modelLabel:SetFont("label")
	modelLabel:SizeToContents()
	modelLabel:SetPos(0.8 * parent:GetWide(), prevY + 0.5 * modelField:GetTall() - 0.5 * modelLabel:GetTall())


	-- Weapon input
	local weaponField = vgui.Create("DTextEntry", parent)
	weaponField:SetFont("label")
	weaponField:SetMultiline(true)
	weaponField:SetSize(0.7 * parent:GetWide(), 0.29 * parent:GetTall())
	weaponField:SetPos(prevX, prevY + 0.03 * parent:GetTall() + modelField:GetTall())
	prevX, prevY = weaponField:GetPos()

	-- Weapon label
	local weaponLabel = vgui.Create("DLabel", parent)
	weaponLabel:SetText("Weapons")
	weaponLabel:SetFont("label")
	weaponLabel:SizeToContents()
	weaponLabel:SetPos(0.8 * parent:GetWide(), prevY + 0.5 * weaponField:GetTall() - 0.5 * weaponLabel:GetTall())

	local healthField =  vgui.Create("DTextEntry", parent)
	healthField:SetFont("label")
	healthField:SetSize(0.7 * parent:GetWide(), 0.06 * parent:GetTall())
	healthField:SetPos(prevX, prevY + 0.03 * parent:GetTall() + weaponField:GetTall())
	prevX, prevY = healthField:GetPos()

	local healthLabel = vgui.Create("DLabel", parent)
	healthLabel:SetText("Health")
	healthLabel:SetFont("label")
	healthLabel:SizeToContents()
	healthLabel:SetPos(0.8 * parent:GetWide(), prevY + 0.5 * healthField:GetTall() - 0.5 * healthLabel:GetTall())

	local sendPresetButton = vgui.Create("DButton", parent)
	sendPresetButton:SetText("Save")
	sendPresetButton:SetFont("label")
	sendPresetButton:SetTextColor(Color(11, 200, 36, 255))
	sendPresetButton:SetSize(0.2 * parent:GetWide() - 0.01 * parent:GetWide(), 0.07 * parent:GetTall())
	--sendPresetButton:SetPos(0.8 * parent:GetWide(), prevY + 0.03 * parent:GetTall() + healthField:GetTall()) -- Bottom Right
	--sendPresetButton:SetPos(0.5 * parent:GetWide() - 0.5 * sendPresetButton:GetWide(), prevY + 0.03 * parent:GetTall() + healthField:GetTall()) -- Center
	sendPresetButton:SetPos(0.05 * parent:GetWide(), prevY + 0.03 * parent:GetTall() + healthField:GetTall()) -- Bottom Left
	local barStatus = 0
	local speed = 8
	sendPresetButton.Paint = function (self, w, h)
		if (self:IsHovered()) then
			barStatus = math.Clamp(barStatus + speed * RealFrameTime(), 0, 1)
		else
			barStatus = math.Clamp(barStatus - speed * RealFrameTime(), 0, 1)
		end

		surface.SetDrawColor(45, 45, 45, 255)
		surface.DrawRect(0, 0, sendPresetButton:GetWide(), sendPresetButton:GetTall())

		surface.SetDrawColor(uiHighlight)
		surface.DrawRect(0, sendPresetButton:GetTall() * 0.9, sendPresetButton:GetWide() * barStatus, 2)
	end
	sendPresetButton.DoClick = function ()
		local data = {
			nameField:GetText(),
			modelField:GetText(),
			weaponField:GetText(),
			healthField:GetText()
		}
		
		nameField:SetText("")
		modelField:SetText("")
		weaponField:SetText("")
		healthField:SetText("")

		net.Start("ecm_sendDataToServer")
		net.WriteTable(data)
		net.SendToServer()

		net.Start("ecm_updatePresetList")
		net.SendToServer()
	end
end

------------------ Manage Preset ------------------
-- Shows the derma for the manage presets page
function ManagePreset (parent)
	parent:Clear()

	local prevX, prevY

	local heading = vgui.Create("DLabel", parent)
	heading:SetText("Manage Presets")
	heading:SetFont("title")
	heading:SizeToContents()
	heading:SetPos(0.5 * parent:GetWide() - 0.5 * heading:GetWide(), 0.02 * parent:GetTall())

	-- Preset drop down
	local presetDD = vgui.Create("DComboBox", parent)
	presetDD:SetFont("label")
	presetDD:SetValue("Available Presets...")
	presetDD:SetSize(0.7 * parent:GetWide(), 0.06 * parent:GetTall())
	presetDD:SetPos(0.05 * parent:GetWide(), 0.1 * parent:GetTall())
	if(ecPresets ~= nil) then
		for k, v in pairs(ecPresets) do
			presetDD:AddChoice(v)
		end
	end
	prevX, prevY = presetDD:GetPos()

	-- Load Preset Button
	local loadPresetButton = vgui.Create("DButton", parent)
	loadPresetButton:SetText("View")
	loadPresetButton:SetFont("label")
	loadPresetButton:SetTextColor(Color(11, 200, 36, 255))
	loadPresetButton:SetSize(0.2 * parent:GetWide() - 0.01 * parent:GetWide(), presetDD:GetTall())
	loadPresetButton:SetPos(prevX + presetDD:GetWide() + 0.01 * parent:GetWide(), prevY)
	local barStatus = 0
	local speed = 8

	loadPresetButton.Paint = function (self, w, h)
		if (self:IsHovered()) then
			barStatus = math.Clamp(barStatus + speed * RealFrameTime(), 0, 1)
		else
			barStatus = math.Clamp(barStatus - speed * RealFrameTime(), 0, 1)
		end

		surface.SetDrawColor(45, 45, 45, 255)
		surface.DrawRect(0, 0, loadPresetButton:GetWide(), loadPresetButton:GetTall())

		surface.SetDrawColor(uiHighlight)
		surface.DrawRect(0, loadPresetButton:GetTall() * 0.9, loadPresetButton:GetWide() * barStatus, 2)
	end

	-- Current Preset
	local currentLabel = vgui.Create("DLabel", parent)
	currentLabel:SetText("Preset Details")
	currentLabel:SetFont("subtitle")
	currentLabel:SizeToContents()
	currentLabel:SetPos(0.5 * parent:GetWide() - 0.5 * currentLabel:GetWide(), prevY + currentLabel:GetTall() + 0.05 * parent:GetTall())
	prevX, prevY = currentLabel:GetPos()

	-- Label for models
	local modelPreviewLabel = vgui.Create("DLabel", parent)
	modelPreviewLabel:SetText("Models")
	modelPreviewLabel:SetFont("label")
	modelPreviewLabel:SizeToContents()

	modelPreviewLabel:SetPos(0.5 * (1/3) * parent:GetWide() - 0.5 * modelPreviewLabel:GetWide() + 0.05 * parent:GetWide(), 
		prevY + modelPreviewLabel:GetTall() + 0.05 * parent:GetTall())

	-- Label for weapons
	local weaposPreviewLabel = vgui.Create("DLabel", parent)
	weaposPreviewLabel:SetText("Weapons")
	weaposPreviewLabel:SetFont("label")
	weaposPreviewLabel:SizeToContents()

	weaposPreviewLabel:SetPos(0.5 * parent:GetWide() - 0.5 * weaposPreviewLabel:GetWide(), 
		prevY + weaposPreviewLabel:GetTall() + 0.05 * parent:GetTall())

	-- Label for other vals
	local otherValuesPreviewLabel = vgui.Create("DLabel", parent)
	otherValuesPreviewLabel:SetText("Other")
	otherValuesPreviewLabel:SetFont("label")
	otherValuesPreviewLabel:SizeToContents()

	local placeholderX = (parent:GetWide() - 1/3 * parent:GetWide())
	local dist = (parent:GetWide() - placeholderX) - 0.05 * parent:GetWide()

	otherValuesPreviewLabel:SetPos(placeholderX + 0.5 * dist - 0.5 * otherValuesPreviewLabel:GetWide(), 
		prevY + otherValuesPreviewLabel:GetTall() + 0.05 * parent:GetTall())

	prevX, prevY = otherValuesPreviewLabel:GetPos()

	-- Models
	local modelPreview = vgui.Create("DTextEntry", parent)
	modelPreview:SetMultiline(true)
	modelPreview:SetFont("label")
	modelPreview:SetSize(0.83 * 1/3 * parent:GetWide() - 0.05, 0.6 * parent:GetTall())
	modelPreview:SetPos(0.5 * (1/3) * parent:GetWide() - 0.5 * modelPreview:GetWide() + 0.05 * parent:GetWide(), 
		prevY + modelPreviewLabel:GetTall() + 0.01 * parent:GetTall())

	-- Weapons
	local weaponPreview = vgui.Create("DTextEntry", parent)
	weaponPreview:SetMultiline(true)
	weaponPreview:SetFont("label")
	weaponPreview:SetSize(0.83 * 1/3 * parent:GetWide() - 0.05, 0.6 * parent:GetTall())
	weaponPreview:SetPos(0.5 * parent:GetWide() - 0.5 * weaponPreview:GetWide(), 
		prevY + weaposPreviewLabel:GetTall() + 0.01 * parent:GetTall())

	-- Preset Name
	local ecPresetNameLabel = vgui.Create("DLabel", parent)
	ecPresetNameLabel:SetText("Preset Name: ")
	ecPresetNameLabel:SetFont("label")
	ecPresetNameLabel:SizeToContents()
	ecPresetNameLabel:SetPos(parent:GetWide() - 1/3 * parent:GetWide(), prevY + otherValuesPreviewLabel:GetTall() + 0.01 * parent:GetTall())
	prevX, prevY = ecPresetNameLabel:GetPos()

	-- Preset Author
	local ecPresetAuthorLabel = vgui.Create("DLabel", parent)
	ecPresetAuthorLabel:SetText("Preset Author: ")
	ecPresetAuthorLabel:SetFont("label")
	ecPresetAuthorLabel:SizeToContents()
	ecPresetAuthorLabel:SetPos(parent:GetWide() - 1/3 * parent:GetWide(), prevY + ecPresetNameLabel:GetTall() + 0.01 * parent:GetTall())
	prevX, prevY = ecPresetAuthorLabel:GetPos()

	-- Preset HP
	local ecPresetHpLabel = vgui.Create("DLabel", parent)
	ecPresetHpLabel:SetText("Preset Health:")
	ecPresetHpLabel:SetFont("label")
	ecPresetHpLabel:SizeToContents()
	ecPresetHpLabel:SetPos(parent:GetWide() - 1/3 * parent:GetWide(), prevY + ecPresetAuthorLabel:GetTall() + 0.01 * parent:GetTall())
	prevX, prevY = ecPresetHpLabel:GetPos()

	-- Textbox to change values of health
	local ecHealthField =  vgui.Create("DTextEntry", parent)
	ecHealthField:SetFont("label")
	ecHealthField:SetSize((parent:GetWide() - prevX) - 0.05 * parent:GetWide(), 0.06 * parent:GetTall())
	ecHealthField:SetPos(prevX, prevY + ecPresetHpLabel:GetTall() + 0.01 * parent:GetTall())
	prevX, prevY = ecHealthField:GetPos()

	-- Actions heading 
	local actionsLabel = vgui.Create("DLabel", parent)
	actionsLabel:SetText("Actions")
	actionsLabel:SetFont("subtitle")
	actionsLabel:SizeToContents()
	local dist = (parent:GetWide() - prevX) - 0.05 * parent:GetWide()
	actionsLabel:SetPos(prevX + 0.5 * dist - 0.5 * actionsLabel:GetWide(), prevY + actionsLabel:GetTall() + 0.1 * parent:GetTall())
	local aprevX, aprevY = actionsLabel:GetPos()

	-- Button to update preset
	local updatePresetButton = vgui.Create("DButton", parent)
	updatePresetButton:SetFont("label")
	updatePresetButton:SetText("Update")
	updatePresetButton:SetTextColor(Color(66, 135, 245, 255))
	updatePresetButton:SetPos(prevX, aprevY + actionsLabel:GetTall() + 0.01 * parent:GetTall())
	updatePresetButton:SetSize(0.55 * (parent:GetWide() - prevX) - 0.05 * parent:GetWide(), 0.06 * parent:GetTall())
	local barStatus = 0
	updatePresetButton.Paint = function (self, w, h)
		if (self:IsHovered()) then
			barStatus = math.Clamp(barStatus + speed * RealFrameTime(), 0, 1)
		else
			barStatus = math.Clamp(barStatus - speed * RealFrameTime(), 0, 1)
		end

		surface.SetDrawColor(45, 45, 45, 255)
		surface.DrawRect(0, 0, updatePresetButton:GetWide(), updatePresetButton:GetTall())

		surface.SetDrawColor(uiHighlight)
		surface.DrawRect(0, updatePresetButton:GetTall() * 0.9, updatePresetButton:GetWide() * barStatus, 2)
	end
	updatePresetButton.DoClick = function ()
		if (presetDD:GetText() ~= "Available Presets..." && ecHealthField:GetText() ~= "") then
			local newValues = {}
			newValues["ecHealth"] = ecHealthField:GetText()
			newValues["ecModels"] = modelPreview:GetText()
			newValues["ecWeapons"] = weaponPreview:GetText()

			net.Start("ecm_updatePreset")
			net.WriteString(presetDD:GetText())
			net.WriteTable(newValues)
			net.SendToServer()

			ManagePreset(parent)
		else
			ShowChatMessage("You need to first view a preset!")
		end
	end
	prevX, prevY = updatePresetButton:GetPos()

	-- Button to delete preset
	local deletePresetButton = vgui.Create("DButton", parent)
	deletePresetButton:SetFont("label")
	deletePresetButton:SetText("Delete")
	deletePresetButton:SetTextColor(Color(240, 35, 35, 255))
	deletePresetButton:SetSize(0.55 * (parent:GetWide() - prevX) - 0.05 * parent:GetWide(), 0.06 * parent:GetTall())
	deletePresetButton:SetPos(parent:GetWide() - 0.05 * parent:GetWide() - deletePresetButton:GetWide(), prevY)
	local barStatus = 0
	deletePresetButton.Paint = function (self, w, h)
		if (self:IsHovered()) then
			barStatus = math.Clamp(barStatus + speed * RealFrameTime(), 0, 1)
		else
			barStatus = math.Clamp(barStatus - speed * RealFrameTime(), 0, 1)
		end

		surface.SetDrawColor(45, 45, 45, 255)
		surface.DrawRect(0, 0, deletePresetButton:GetWide(), deletePresetButton:GetTall())

		surface.SetDrawColor(uiHighlight)
		surface.DrawRect(0, deletePresetButton:GetTall() * 0.9, deletePresetButton:GetWide() * barStatus, 2)
	end
	deletePresetButton.DoClick = function ()
		if (presetDD:GetValue() ~= "Available Presets..." && ecHealthField:GetText() ~= "") then
			net.Start("ecm_deletePreset")
			net.WriteString(presetDD:GetValue())
			net.SendToServer()

			timer.Create("ecm_awaitPresetListUpdate", 0.5, 1, function ()
				ManagePreset(parent)
			end)
		else
			ShowChatMessage("You need to view a preset first!")
		end
	end
	prevX, prevY = actionsLabel:GetPos()


	loadPresetButton.DoClick = function ()
		if (presetDD:GetValue() ~= "Available Presets...") then
			net.Start("ecm_getPresetByName")
			net.WriteString(presetDD:GetValue())
			net.SendToServer()

			timer.Create("ecm_awaitManageValuesUpdate", 0.5, 1, function ()
				UpdateCurrentValuesDisplay(modelPreview, weaponPreview, ecPresetNameLabel, ecPresetAuthorLabel, ecHealthField, managePresetDisplay)
			end)
		else
			ShowChatMessage("You need to select a preset.")
		end
	end
end

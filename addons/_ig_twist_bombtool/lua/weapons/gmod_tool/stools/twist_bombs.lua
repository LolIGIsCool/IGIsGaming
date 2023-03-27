TOOL.Category = "Imperial Gaming"

TOOL.Name = "Bomb Dropper"

if (CLIENT) then
	language.Add("Tool.twist_bombs.name", "Bomber Dropper")
    language.Add("Tool.twist_bombs.desc", "Drop some bombs")
	language.Add("Tool.twist_bombs.left", "Choose the location do blow up")
end

TOOL.Information = {
	{ name = "left" },
}

TOOL.ClientConVar["height"] = "0"
TOOL.ClientConVar["bomb"] = ""
TOOL.ClientConVar["delay"] = "0"

function TOOL:LeftClick(trace, attach)
	if (!trace.HitPos) then return false end

	local Delay = self:GetClientInfo("delay")
    local Height = self:GetClientNumber("height")
    local Bomb = self:GetClientInfo("bomb")

    timer.Simple(Delay, function()
        local ent = ents.Create(Bomb)
        ent:SetOwner(self:GetOwner())
        ent:SetPos(trace.HitPos + Vector(0,0,Height))
        ent:Spawn()
        ent:Arm()

        undo.Create("Bomb")
            undo.AddEntity(ent)
            undo.SetPlayer(self:GetOwner())
            undo.SetCustomUndoText("Undone Bomb")
        undo.Finish()
        return false
    end)
end
function TOOL:RightClick(trace)
    
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)
    if not CLIENT then return end
    CPanel:SetName("Bomb Dropper")
    CPanel:NumSlider("Height", "twist_bombs_height", 0, 10000)
    CPanel:ControlHelp("Sets the height of the bomb.")
    CPanel:NumSlider("Delay", "twist_bombs_delay", 0, 10, 1)
    CPanel:ControlHelp("Set the delay.")
    changebomb = vgui.Create("DComboBox")
		changebomb:SetSize(100, 25)
		changebomb:SetValue("Change Bomb")
			changebomb:AddChoice("gb_bomb_250gp") // Small
			changebomb:AddChoice("gb_bomb_1000gp") // Medium
			changebomb:AddChoice("gb_bomb_2000gp") // Big
			changebomb:AddChoice("gb_bomb_cbu") // Cluster
			changebomb:AddChoice("gb_bomb_mk77") // Napalm
		changebomb.OnSelect = function( self,  value , index)
			RunConsoleCommand("twist_bombs_bomb", index)
		end
	CPanel:AddItem(changebomb)
end
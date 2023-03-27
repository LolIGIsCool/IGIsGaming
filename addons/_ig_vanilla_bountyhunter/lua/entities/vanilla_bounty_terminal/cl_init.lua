include("shared.lua");
local imgui = include("bh/bh_imgui.lua");

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT;

surface.CreateFont("vanilla_bountyboard_title",{
    font = "Acumin Pro",
    italic = true,
    antialias = true,
    weight = 800,
    size = 32
})
surface.CreateFont("vanilla_bountyboard_text1",{
    font = "Acumin Pro",
    antialias = true,
    weight = 800,
    size = 16
})
surface.CreateFont("vanilla_bountyboard_text2",{
    font = "Acumin Pro",
    extended = true,
    antialias = true,
    weight = 1,
    size = 16
})
surface.CreateFont("vanilla_bountyboard_text3",{
    font = "Acumin Pro",
    extended = true,
    italic = true,
    antialias = true,
    weight = 1,
    size = 10
})

local col = {
    white = Color(255,255,255,255),
    grey = Color(20,20,20,255),
    blue = Color(20,125,205,255),
    darkBlue = Color(20,20,200,255)
}

local bountyBoard = {
    {
        owner = nil,
        target = nil,
        method = "",
        reward = "",
        location = "",
        hunters = {},
        banned = {}
    }
}

local index = 1;

net.Receive("VANILLABOUNTY_net_BroadcastBounty", function()
    bountyBoard = net.ReadTable();

    if #bountyBoard == 0 then
        bountyBoard[1] = {
            owner = nil,
            target = nil,
            method = "",
            reward = "",
            location = "",
            hunters = {},
            banned = {}
        }
    end

    //if the current selected bounty is removed, move to the last available one
    if index > #bountyBoard then index = #bountyBoard end
end)

local w, h = 300, 150;

local bord = 10;

function ENT:DrawTranslucent()
    self:DrawModel();

    if imgui.Entity3D2D(self, Vector(15, -75, 45), Angle(0, 180, 30), 0.1, 300, 0) then
        for _, v in ipairs(bountyBoard) do
            if not IsValid(v.target) and method ~= "" then
                table.RemoveByValue(bountyBoard, v);

                if #bountyBoard == 0 then
                    bountyBoard[1] = {
                        owner = nil,
                        target = nil,
                        method = "",
                        reward = "",
                        location = "",
                        hunters = {},
                        banned = {}
                    }
                end

                //if the current selected bounty is removed, move to the last available one
                if index > #bountyBoard then index = #bountyBoard end
            end
        end

        //background
        surface.SetDrawColor(col.grey);
        surface.DrawRect(0,0,w,h);

        //outline
        surface.SetDrawColor(col.white);
        surface.DrawLine(bord,bord,w - bord,bord);
        surface.DrawLine(bord,bord,bord,h - bord * 2);
        surface.DrawLine(w - bord,bord,w - bord,h - bord * 2);

        surface.DrawLine(w - bord,h - bord * 2,w - bord * 2,h - bord * 2);
        surface.DrawLine(bord,h - bord * 2,bord * 2,h - bord * 2);

        if LocalPlayer():GetRegiment() ~= "Bounty Hunter" then
            surface.SetDrawColor(Color(255,73,73,125));
            surface.DrawRect(0, h * 0.3, w, h * 0.3);

            surface.SetTextColor(col.white);
            surface.SetFont("vanilla_bountyboard_text1");
            surface.SetTextPos(95,60);
            surface.DrawText("ACCESS DENIED");

            surface.SetFont("vanilla_bountyboard_text2");
            surface.SetTextPos(30,120);
            surface.DrawText("If you believe there is an error, you are wrong.");

            imgui.End3D2D();
            return
        end

        local claim;
        local claimCol;
        local claimButtonText;

        if bountyBoard[1].owner ~= nil then

            //claim text generator
            claim = "Unclaimed";
            claimCol = col.white;
            claimButtonText = "CLAIM";
            for _, v in ipairs(bountyBoard[index].hunters) do
                if v:IsValid() and v:Nick() == LocalPlayer():Nick() then
                    claim = "Claimed"
                    claimCol = col.blue;
                    claimButtonText = "UNCLAIM";
                end
            end

        else

            claim = "";
            claimCol = Color(0,0,0,0);
            claimButtonText = "";

        end

        //info
        surface.SetTextColor(col.white);

        surface.SetFont("vanilla_bountyboard_text1");
        surface.SetTextPos(20,15);
        surface.DrawText("NAME: ");
        surface.SetFont("vanilla_bountyboard_text2");

            if bountyBoard[1].owner ~= nil then
                surface.DrawText(bountyBoard[index].target:Nick());
            else
                surface.DrawText("NO BOUNTIES");
            end

        surface.SetFont("vanilla_bountyboard_text1");
        surface.SetTextPos(20,30);
        surface.DrawText("REGIMENT: ");
            surface.SetFont("vanilla_bountyboard_text2");
            if bountyBoard[1].owner ~= nil then
                surface.DrawText(bountyBoard[index].target:GetRegiment());
            end

        surface.SetFont("vanilla_bountyboard_text1");
        surface.SetTextPos(20,55);
        surface.DrawText("REWARD: ");
            surface.SetFont("vanilla_bountyboard_text2");
            if bountyBoard[1].owner ~= nil then
                surface.DrawText(string.Comma(bountyBoard[index].reward) .. " credits");
            end


        surface.SetFont("vanilla_bountyboard_text1");
        surface.SetTextPos(20,80);
        surface.DrawText("LAST LOCATION: ");
            surface.SetFont("vanilla_bountyboard_text2");
            surface.DrawText(bountyBoard[index].location);


        surface.SetFont("vanilla_bountyboard_text1");
        surface.SetTextPos(20,95);
        surface.DrawText("STATUS: ");
            surface.SetFont("vanilla_bountyboard_text2");
            surface.SetTextColor(claimCol)
            surface.DrawText(claim);

        //title
        draw.SimpleText("BOUNTY BOARD","vanilla_bountyboard_title", w / 2, -15, col.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

        //claim button
        local claimButton = imgui.xTextButton(claimButtonText, "vanilla_bountyboard_text3", (w / 2) - 30, h - 30, 60, 20, 2, col.white, col.blue, col.darkBlue);

        if claimButton and bountyBoard[1].owner ~= nil then
            local found = false;
            for _, v in ipairs(bountyBoard[index].banned) do
                if v == LocalPlayer() then found = true; end
            end

            if (bountyBoard[index].target == LocalPlayer()) then found = true; end

            if not found then
                if claim == "Unclaimed" then
                    table.insert(bountyBoard[index].hunters, LocalPlayer());
                else
                    table.RemoveByValue(bountyBoard[index].hunters, LocalPlayer());
                end
            end

            net.Start("VANILLABOUNTY_net_ClaimBounty");
            net.WriteUInt(index, 6);
            net.SendToServer();
        end

        //arrow buttons
        local rightButton = imgui.xTextButton(">", "vanilla_bountyboard_text3", (w / 2) + 35, h - 30, 60, 20, 2, col.white, col.blue, col.darkBlue);
        local leftButton = imgui.xTextButton("<", "vanilla_bountyboard_text3", (w / 2) - 95, h - 30, 60, 20, 2, col.white, col.blue, col.darkBlue);

        //button movement
        if rightButton and index < #bountyBoard then
            index = index + 1;
        end

        if leftButton and index > 1 then
            index = index - 1;
        end

        //cursor
        imgui.xCursor(0, 0, w, h);

        imgui.End3D2D();
    end
end

net.Receive("VANILLABOUNTY_net_PrettyText", function()
    local white = Color(255,255,255);
    local orange = Color(255, 93, 0);
    local text = net.ReadString();
    chat.AddText(white, "[", orange, "ENCRYPTED-MESSAGE", white, "] This is ", orange, "CODENAME-TWILIGHT", white, ". ", text);
end)

net.Receive("VANILLABOUNTY_net_FauxComms", function()
    local text = net.ReadString();
    chat.AddText(Color(255, 93, 0), "(BH COMMS) ", "Agent Twilight", Color(255,255,255), ": ", text);
end)
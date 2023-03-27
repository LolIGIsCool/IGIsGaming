if SERVER then
    // icons
    resource.AddFile("materials/vanilla/hud/health.png");
    resource.AddFile("materials/vanilla/hud/star.png");
    resource.AddFile("shenesis/pointshop/credits.png");

    // fonts
    resource.AddFile("resource/fonts/vanilla/robotocondensed-light.ttf");
    resource.AddFile("resource/fonts/vanilla/proxima_nova.ttf");
end

if CLIENT then
    // remove default hud
    local hidden = {
        CHudHealth = true,
        CHudBattery = true,
        CHudAmmo = false
    }

    hook.Add("HUDShouldDraw", "HideHUD", function(name)
        if hidden[name] then return false end
    end)

    //setup blur panel
    local blur = Material("pp/blurscreen")

    //custom functions
    function vanillaBlurPanel(x, y, w, h, color)
        if color.a == 0 then return end
        
        blur:SetFloat("$blur", 5);
        blur:Recompute();
        render.UpdateScreenEffectTexture();

        //blur
        surface.SetDrawColor(255,255,255,255);
        surface.SetMaterial(blur);

        render.SetScissorRect(x,y,x + w,y + h,true);
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH());
        render.SetScissorRect(0, 0, 0, 0, false);

        //panel
        surface.SetDrawColor(color);
        surface.DrawRect(x,y,w,h);
    end

    local function LerpColor(frac,from,to)
        local col = Color(
            Lerp(frac,from.r,to.r),
            Lerp(frac,from.g,to.g),
            Lerp(frac,from.b,to.b),
            Lerp(frac,from.a,to.a)
        )
        return col
    end

    local function LerpColours(frac,colTable)
        local cUnit = 1 / #colTable;

        if (frac <= 0) then frac = 0.001; end

        return LerpColor(frac % cUnit / cUnit, colTable[math.Clamp(math.floor(frac / cUnit),1,3)], colTable[math.Clamp(math.ceil(frac / cUnit),1,3)]);
    end

    //setup fonts
    surface.CreateFont("vanilla_font_defcon", {
        font = "Proxima Nova Rg",
        size = ScreenScale(11),
        weight = 800
    })
    surface.CreateFont("vanilla_font_info", {
        font = "Proxima Nova Rg",
        size = ScreenScale(6),
        weight = 800
    })
    surface.CreateFont("vanilla_font_health", {
        font = "Roboto Condensed",
        size = ScreenScale(23),
        weight = 500
    })

    surface.CreateFont("vanilla_font_hp", {
        font = "Roboto Condensed",
        size = ScreenScale(6),
        weight = 500
    })

    //setup materials
    local healthMat = Material("materials/vanilla/hud/health.png");
    local starMat = Material("materials/vanilla/hud/star.png");
    local creditsMat = Material("shenesis/pointshop/credits.png");

    function IGHUD()
        
    //setup colours
    local colourTable = {
        textColour = Color(255,255,255),
        panelColour = Color(0,0,0,100),
        barColour = Color(40,40,40,255)
    }
    // DEFCON HUD -----------------------------
        //defcon value
        local dc = string.Split(vanillaignewdefcon,"");
        local defconcolors = {Color(202, 66, 75, 255), Color(25, 255, 125, 255), Color(255, 140, 69, 255), Color(255, 231, 69, 255)}

        //get text size
        surface.SetFont("vanilla_font_defcon");
        local defconOffset = surface.GetTextSize(string.upper(vanillaIGDEFCONTYPES[tonumber(dc[1])][tonumber(dc[2])]));

        //panel + text
        vanillaBlurPanel(ScrW() * 0.985 - (defconOffset + ScrW() * 0.005), ScrH() * 0.897,defconOffset + ScrW() * 0.01, ScrH() * 0.044,colourTable.panelColour);
        draw.SimpleText(string.upper(vanillaIGDEFCONTYPES[tonumber(dc[1])][tonumber(dc[2])]), "vanilla_font_defcon", ScrW() * 0.9845, ScrH() * 0.904, defconcolors[tonumber(dc[1])], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP);
    // -----------------------------

    // HEALTHBAR HUD -----------------------------
        // health offset
        surface.SetFont("vanilla_font_health");
        local hpOffset = surface.GetTextSize(LocalPlayer():Health());

        surface.SetFont("vanilla_font_hp");
        local maxHpOffset = surface.GetTextSize("/ " .. LocalPlayer():GetMaxHealth());

        // panel
        vanillaBlurPanel(ScrW() * 0.01, ScrH() * 0.91, hpOffset + ScrW() * 0.043 + maxHpOffset, ScrH() * 0.077, colourTable.panelColour);

        // colour picker
        local maxHealth = LocalPlayer():GetMaxHealth();
        local currentHealth = LocalPlayer():Health();
        local healthColour;

        local lerp = currentHealth / maxHealth;

        local healthColours = {
            Color(202, 66, 75, 255), //red
            Color(255, 140, 69, 255), //orange
            Color(25, 255, 125, 255) //green
        }

        healthColour = LerpColours(lerp,healthColours);

        //if (lerp == 1) then healthColour = healthColours[3]; end

/*
        if (currentHealth > maxHealth / 2) then
            healthColour = LerpColor(currentHealth / maxHealth, Color(255, 140, 69, 255), Color(25, 255, 125, 255));
            print(currentHealth / maxHealth);
        else
            healthColour = LerpColor(currentHealth / (maxHealth / 2), Color(202, 66, 75, 255), Color(255, 140, 69, 255));
        end*/

        // cross icon
        surface.SetDrawColor(healthColour);
        surface.SetMaterial(healthMat);
        surface.DrawTexturedRect(ScrW() * 0.02,ScrH() * 0.935,ScrW() * 0.015, ScrW() * 0.015);

        // text
        surface.SetFont("vanilla_font_health");
        surface.SetTextColor(healthColour);
        surface.SetTextPos(ScrW() * 0.043,ScrH() * 0.916);
        surface.DrawText(currentHealth);

        surface.SetTextColor(colourTable.textColour);
        surface.SetFont("vanilla_font_hp");
        surface.SetTextPos(hpOffset + ScrW() * 0.045,ScrH() * 0.953);
        surface.DrawText("/ " .. maxHealth);
    // -----------------------------

    // LEVEL HUD -----------------------------
        // panel
        vanillaBlurPanel(ScrW() * 0.82,ScrH() * 0.952,ScrW() * 0.05,ScrH() * 0.035, colourTable.panelColour);

        vanillaBlurPanel(ScrW() * 0.71,ScrH() * 0.952,ScrW() * 0.1,ScrH() * 0.035, colourTable.panelColour);

        // icon
        surface.SetDrawColor(255,255,255,255);
        surface.SetMaterial(starMat);
        surface.DrawTexturedRect(ScrW() * 0.825,ScrH() * 0.96 ,ScrW() * 0.011,ScrW() * 0.01);

        // progress bar
        local xp = SimpleXPGetXP(LocalPlayer());
        local level = SimpleXPCalculateXPToLevel(xp);
        local nextLevel = SimpleXPCalculateLevelToXP(level + 1);
        local lastLevel = SimpleXPCalculateLevelToXP(level);
        local percent = math.floor(xp - lastLevel) / (nextLevel - lastLevel);

        surface.SetDrawColor(0,0,0,200);
        surface.DrawRect(ScrW() * 0.74,ScrH() * 0.965,ScrW() * 0.06,ScrH() * 0.008);

        surface.SetDrawColor(defconcolors[tonumber(dc[1])]);
        surface.DrawRect(ScrW() * 0.74,ScrH() * 0.965,ScrW() * 0.06 * percent,ScrH() * 0.008);

        // text
        surface.SetFont("vanilla_font_info");
        surface.SetTextColor(colourTable.textColour);
        surface.SetTextPos(ScrW() * 0.84, ScrH() * 0.961);
        surface.DrawText(level);

        surface.SetTextPos(ScrW() * 0.715, ScrH() * 0.961);
        surface.DrawText(math.floor(percent * 100) .. "%");
    // -----------------------------

    // CREDITS HUD -----------------------------
        // panel
        vanillaBlurPanel(ScrW() * 0.88,ScrH() * 0.952,ScrW() * 0.11,ScrH() * 0.035, colourTable.panelColour);

        // icon
        surface.SetDrawColor(255,255,255,255);
        surface.SetMaterial(creditsMat);
        surface.DrawTexturedRect(ScrW() * 0.885,ScrH() * 0.96 ,ScrW() * 0.01,ScrW() * 0.01);

        // text
        surface.SetTextPos(ScrW() * 0.9, ScrH() * 0.961);
        surface.DrawText(string.Comma(LocalPlayer():SH_GetPremiumPoints()));
    // -----------------------------

    // BEARING HUD -----------------------------
        // vars
        local eyeangle = LocalPlayer():EyeAngles();
        local bearing = math.Round(eyeangle.y, 0);
        local direction = "N";

        while bearing < 0 do
            bearing = bearing + 360;
        end

        while bearing > 360 do
            bearing = bearing - 360;
        end

        bearing = -1 * bearing + 360;

        if bearing >= 347.5 or bearing < 22.5 then
            direction = "N";
        elseif bearing >= 22.5 and bearing < 67.5 then
            direction = "NE";
        elseif bearing >= 67.5 and bearing < 112.5 then
            direction = "E";
        elseif bearing >= 112.5 and bearing < 157.5 then
            direction = "SE";
        elseif bearing >= 157.5 and bearing < 202.5 then
            direction = "S";
        elseif bearing >= 202.5 and bearing < 247.5 then
            direction = "SW";
        elseif bearing >= 247.5 and bearing < 302.5 then
            direction = "W";
        elseif bearing >= 302.5 and bearing < 347.5 then
            direction = "NW";
        end

        local e = (direction .. " | " .. bearing .. "°");
        local length = surface.GetTextSize(e);

        //panel
        vanillaBlurPanel(hpOffset + ScrW() * 0.065 + maxHpOffset,ScrH() * 0.952,ScrW() * 0.01 + length,ScrH() * 0.035, colourTable.panelColour);

        //text
        surface.SetTextPos(hpOffset + ScrW() * 0.07 + maxHpOffset, ScrH() * 0.961);
        surface.DrawText(e);
    // -----------------------------
    end
    hook.Add("HUDPaint", "IGDrawHud", IGHUD);
end

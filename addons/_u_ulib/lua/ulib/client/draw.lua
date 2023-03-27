--[[
	Title: Draw

	Our client-side draw functions
]]

--[[
	Function: csayDraw

	Draws a csay text on the screen.

	Parameters:

		msg - The message to draw.
		color - *(Optional, defaults to 255, 255, 255, 255)* The color of the text
		duration - *(Optional, defaults to 5)* The length of the text
		fade - *(Optional, defaults to 0.5)* The length of fade time

	Revisions:

		v2.10 - Added fade parameter
]]

surface.CreateFont( "CSayFont", {
	font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function ULib.csayDraw( msg, color, duration, fade )
	color = color or Color( 255, 0, 0, 255 ) -- Where to change color of the csay text
	duration = duration or 10
	fade = fade or 0.5
	local start = CurTime()

	local function drawToScreen()
		local alpha = 255
		local dtime = CurTime() - start

		if dtime > duration then -- Our time has come :'(
			hook.Remove( "HUDPaint", "CSayHelperDraw" )
			return
		end

		if fade - dtime > 0 then -- beginning fade
			alpha = (fade - dtime) / fade -- 0 to 1
			alpha = 1 - alpha -- Reverse
			alpha = alpha * 255
		end

		if duration - dtime < fade then -- ending fade
			alpha = (duration - dtime) / fade -- 0 to 1
			alpha = alpha * 255
		end
		color.a  = alpha

		draw.DrawText( msg, "CSayFont", ScrW() * 0.5, ScrH() * 0.25, color, TEXT_ALIGN_CENTER )
	end

	hook.Add( "HUDPaint", "CSayHelperDraw", drawToScreen )
end

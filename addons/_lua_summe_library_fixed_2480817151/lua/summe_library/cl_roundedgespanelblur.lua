local blurMat = Material("pp/blurscreen")

function SummeLibrary:DrawBlur(cornerRadius, panel, amount, passes, x, y, w, h)
    if not cornerRadius or not panel or not amount or not passes then return end

    x, y = panel:LocalToScreen(x, y)

    surface.SetMaterial(blurMat)
    surface.SetDrawColor(color_white)

    for i = -(passes or 0.2), 1, 0.2 do
        -- Do things to the blur material to make it blurry.
        blurMat:SetFloat("$blur", i * 5)
        blurMat:Recompute()

        -- Draw the blur material over the screen.
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, x, y)
    end

    x, y = 0, 0

    local poly = {}
	poly[1] = { x = x + w/2, y = y + h/2, u = 0.5, v = 0.5}

	poly[2] = {x = x + w/2, y = y, u = 0.5, v = 0}
	poly[3] = {x = x + w - cornerRadius, y = y, u = (w-cornerRadius) / w, v = 0}

	local topX = x + w-cornerRadius
	local topY = y + cornerRadius
	for i = -89, 0 do
		local X = topX + math.cos(math.rad(i)) * cornerRadius 
		local Y = topY + math.sin(math.rad(i)) *cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {
		x = x + w,
		y = y + h - cornerRadius,
		u =  1, 
		v = (h-cornerRadius) / h,
	}

	topX = x + w-cornerRadius
	topY = y +h - cornerRadius

	for i = 1, 90 do
		local X = topX + math.cos(math.rad(i)) * cornerRadius 
		local Y = topY + math.sin(math.rad(i)) *cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {
		x = x +cornerRadius,
		y = y + h,
		u =  cornerRadius/w, 
		v = 1,
	}

	topX = x +cornerRadius
	topY = y +h - cornerRadius


	for _i = 180, 270 do
		i = _i - 90
		local X = topX + math.cos(math.rad(i)) * cornerRadius 
		local Y = topY + math.sin(math.rad(i)) *cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {
		x = x,
		y = y + cornerRadius,
		u = 0,
		v = cornerRadius/h,
	}

	topX = x + cornerRadius
	topY = y + cornerRadius

	for _i = 270, 360 do
		i = _i - 90
		local X = topX + math.cos(math.rad(i)) * cornerRadius 
		local Y = topY + math.sin(math.rad(i)) *cornerRadius
		poly[#poly + 1] = {
			x = X,
			y = Y,
			u = (X - x )/w,
			v = (Y - y) /h,
		}
	end

	poly[#poly + 1] = {x = x + w/2, y = y, u = 0.5, v = 0}

	surface.DrawPoly(poly)
end
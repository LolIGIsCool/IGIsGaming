-- Arc lib
-- credits to Bob Blackmon aka Bobblehead, Bobbleheadbob, Luabee
-- https://github.com/Luabee

local arc = {}

function arc.Draw(cx, cy, radius, thickness, startang, endang, roughness, color)
	surface.SetDrawColor(color)
	arc.DrawPrecached(arc.Precache(cx, cy, radius, thickness, startang, endang, roughness))
end

function arc.DrawPrecached(arc)
	for k, v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end

function arc.Precache(cx, cy, radius, thickness, startang, endang, roughness)
	local triarc = {}
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	local startang, endang = startang or 0, endang or 0
	local inner = {}
	local r = radius - thickness
	local outer = {}

	if startang > endang then
		step = math.abs(step) * -1
	end

	for deg = startang, endang, step do
		local rad = math.rad(deg)
		local ox, oy = cx + math.cos(rad) * r, cy + -math.sin(rad) * r

		table.insert(inner, {
			x = ox,
			y = oy,
			u = (ox - cx) / radius + 0.5,
			v = (oy - cy) / radius + 0.5,
		})
	end

	for deg = startang, endang, step do
		local rad = math.rad(deg)
		local ox, oy = cx + math.cos(rad) * radius, cy + -math.sin(rad) * radius

		table.insert(outer, {
			x = ox,
			y = oy,
			u = (ox - cx) / radius + 0.5,
			v = (oy - cy) / radius + 0.5,
		})
	end

	for tri = 1, #inner * 2 do
		local p1, p2, p3
		p1 = outer[math.floor(tri * 0.5) + 1]
		p3 = inner[math.floor((tri + 1) * 0.5) + 1]

		if tri % 2 == 0 then
			p2 = outer[math.floor((tri + 1) * 0.5)]
		else
			p2 = inner[math.floor((tri + 1) * 0.5)]
		end

		table.insert(triarc, {p1, p2, p3})
	end

	return triarc
end

return arc
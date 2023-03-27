-- developed for gmod.store
-- from incredible-gmod.ru with love <3
-- https://www.gmodstore.com/market/view/gestures

local PLAYER = FindMetaTable("Player")

function INC_GESTURES:GetGestures(ply, is_vendor)
	local sections, sections_count, id, by_ids = {}, 0, 0, {}
	is_vendor = is_vendor or false

	for i, sec in ipairs(self.Sections) do
		id = id + 1

		sec.isJTab = false

		if sec.Price and not is_vendor then
			if not INC_GESTURES:IsPurchased(ply, sec.id) then continue end
		end

		if sec.CustomCheck == nil then
			sections_count = sections_count + 1
			sections[sections_count] = sec
		elseif sec.CustomCheck(ply) ~= false then
			sections_count = sections_count + 1
			sections[sections_count] = sec
		end

		by_ids[sec.id] = sec
	end

	if ply.getJobTable == nil then return sections, sections_count, by_ids end

	for i, sec in ipairs(ply:getJobTable().gestures or {}) do
		id = id + 1

		sec.isJTab = true
		sec.id = id

		if sec.Price and not is_vendor then
			if not INC_GESTURES:IsPurchased(ply, sec.id) then continue end
		end

		sections_count = sections_count + 1
		sections[sections_count] = sec

		by_ids[sec.id] = sec
	end

	return sections, sections_count, by_ids
end
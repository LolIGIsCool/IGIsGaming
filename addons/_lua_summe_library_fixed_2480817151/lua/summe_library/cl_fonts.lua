function SummeLibrary:CreateFont(name, size, weight, italic)
    local tbl = {
		font = "Roboto",
		size = size + 2,
		weight = weight or 500,
		extended = true,
		italic = italic or false,
	}

    surface.CreateFont(name, tbl)

	return name
end
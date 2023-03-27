SummeLibrary.Colors = {
    ["grey"] = Color(33, 33, 33),
    ["greyDark"] = Color(18, 18, 18),
    ["greyLight"] = Color(212, 212, 212),
    ["white"] = Color(221, 221, 2213),
    ["red"] = Color(255, 61, 61),
    ["green"] = Color(103, 255, 82),
    ["greenDark"] = Color(64, 173, 0),
    ["yellow"] = Color(255, 196, 0),
    ["orange"] = Color(255, 102, 0),
    ["blue"] = Color(0, 174, 255),
    ["cyan"] = Color(81, 243, 255),
}

function SummeLibrary:GetColor(name)
    return SummeLibrary.Colors[name] or SummeLibrary.Colors[1]
end

function SummeLibrary:RegisterColor(name, color)
    SummeLibrary.Colors[name] = color
end

if CLIENT then
    local Color_ = Color
    local lerp_ = Lerp
    local COLORMeta = FindMetaTable("Color")

    function COLORMeta:Lerp(t, to)
        self.r = lerp_(t, self.r, to.r)
        self.g = lerp_(t, self.g, to.g)
        self.b = lerp_(t, self.b, to.b)
        self.a = lerp_(t, self.a, to.a)
        return self
    end

    function SummeLibrary:LerpColor(t, from, to)
        return Color_(from.r, from.g, from.b, from.a):Lerp(t, to)
    end
end
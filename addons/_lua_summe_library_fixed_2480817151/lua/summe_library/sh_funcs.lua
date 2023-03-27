function SummeLibrary:ShortenString(string, maxChars)
    if #string > maxChars then
        local t = ""

        for _, char in pairs(string.Split(string, "")) do
            if #t < maxChars then
                t = t..char
            end
        end

        return t.."..."

    else
        return string
    end
end
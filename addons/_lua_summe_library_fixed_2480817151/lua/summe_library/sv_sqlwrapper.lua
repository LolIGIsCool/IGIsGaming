SummeLibrary.Queries = {}

SummeLibrary.SQLMeta = {
    GiveParams = function(self, ...)
        local params = {...}

        for key, value in pairs(params) do
            self.string = string.gsub(self.string, "?", value, 1)
        end
    end,
    ExecuteQuery = function(self, callback, shouldWait)
        SummeLibrary:Query(self.string, callback, shouldWait)
        SummeLibrary.Queries[self.index] = nil
    end
}

SummeLibrary.SQLMeta.__index = SummeLibrary.SQLMeta

function SummeLibrary:QuerifyString(input)
    local newString = string.gsub(input, "|", "'")

    return newString
end

function SummeLibrary:Query(queryString, callback, shouldWait, useLocalDB)
    if SummeLibrary.SQL.Config.UseMySQL and not useLocalDB then
        local query = PermaPropsSystem.MySQL:query(queryString)
        query.onSuccess = function(_, data)
            if(callback) then
                callback(data)
            end
        end
        query.onError = function(q, err, sql)
            print(err)
        end
        query:start()

        if shouldWait then
            query:wait()
        end

    else
        local data = sql.Query(queryString)
        if(callback) then
            callback(data)
        end
    end
end

function SummeLibrary:PreparedQuery(queryString)
    local queryData = {}
    queryData.string = SummeLibrary:QuerifyString(queryString)
    local index = table.insert(SummeLibrary.Queries, queryData)
    setmetatable(SummeLibrary.Queries[index], SummeLibrary.SQLMeta)
    SummeLibrary.Queries[index].index = index
    return SummeLibrary.Queries[index]
end

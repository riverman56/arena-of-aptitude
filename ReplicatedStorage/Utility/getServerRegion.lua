--[[
    Outputs the game server's location in format [City, Region, Country]
]]

local HttpService = game:GetService("HttpService")

local retry = require(script.Parent.retry)

local ENDPOINT = "http://ip-api.com/json/"
local MAX_RETRY_TIMES = 5

local function getServerRegion()
    local success, result = retry(function()
        return HttpService:RequestAsync({
            Url = ENDPOINT,
            Method = "GET",
        })
    end, MAX_RETRY_TIMES)

    if success and result.Success == true then
        local data = HttpService:JSONDecode(result.Body)

        if data["country"] and data["region"] and data["city"] then
            return string.format("%s, %s, %s", data.city, data.region, data.country)
        else
            return "Unknown"
        end
    else
        return "Unknown"
    end
end

return getServerRegion
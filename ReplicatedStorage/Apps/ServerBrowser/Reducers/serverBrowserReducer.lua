local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local ServerBrowser = require(script.Parent.ServerBrowser)
local Servers = require(script.Parent.Servers)

local serverBrowserReducer = Rodux.combineReducers({
    ServerBrowser = ServerBrowser,
    Servers = Servers,
})

return serverBrowserReducer
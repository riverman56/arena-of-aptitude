local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local Servers = require(script.Parent.Servers)

local serverBrowserReducer = Rodux.combineReducers({
    Servers = Servers,
})

return serverBrowserReducer
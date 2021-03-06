local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)
local Cryo = require(ReplicatedStorage.Modules.Cryo)

local UpdateServers = require(script.Parent.Parent.Actions.UpdateServers)

local Servers = Rodux.createReducer(nil, {
    [UpdateServers.name] = function(state, action)
        return action.Servers
    end
})

return Servers
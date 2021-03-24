local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)
local Cryo = require(ReplicatedStorage.Modules.Cryo)

local SetIsOpen = require(script.Parent.Parent.Actions.SetIsOpen)

local initialServerBrowser = {
    open = false,
}

local ServerBrowser = Rodux.createReducer(initialServerBrowser, {
    [SetIsOpen.name] = function(state, action)
        return Cryo.Dictionary.join(state, action)
    end
})

return ServerBrowser
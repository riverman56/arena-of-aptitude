local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local Health = require(script.Parent.Health)
local Visibility = require(script.Parent.Visibility)

local overheadDisplayReducer = Rodux.combineReducers({
    Health = Health,
    Visibility = Visibility,
})

return overheadDisplayReducer
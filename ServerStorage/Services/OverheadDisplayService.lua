local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Knit)

local Roact = require(ReplicatedStorage.Modules.Roact)
local Rodux = require(ReplicatedStorage.Modules.Rodux)

local OverheadDisplay = ReplicatedStorage.Apps.OverheadDisplay

local app = require(OverheadDisplay.Components.App)
local reducer = require(OverheadDisplay.Reducers.overheadDisplayReducer)

local UpdateHealth = require(OverheadDisplay.Actions.UpdateHealth)
local UpdateVisibility = require(OverheadDisplay.Actions.UpdateVisibility)

local OverheadDisplayService = Knit.CreateService({
    Name = "OverheadDisplayService",
    Client = {},
})

function OverheadDisplayService:KnitInit()
    Players.PlayerAdded:Connect(function(player)
        local handle = nil
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")

            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff

            character:WaitForChild("HumanoidRootPart")

            local store = Rodux.Store.new(reducer)

            local root = Roact.createElement(app, {
                store = store,
                character = character,
            })

            handle = Roact.mount(root, character, "OverheadDisplay")

            store:dispatch(UpdateHealth(humanoid.Health, humanoid.MaxHealth))
            store:dispatch(UpdateVisibility(true))

            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                store:dispatch(UpdateHealth(humanoid.Health, humanoid.MaxHealth))

                if humanoid.Health == 0 then
                    store:dispatch(UpdateVisibility(false))
                end
            end)

            humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
                store:dispatch(UpdateHealth(humanoid.Health, humanoid.MaxHealth))
            end)
        end)
        
        player.CharacterRemoving:Connect(function()
            Roact.unmount(handle)
        end)
    end)
end

return OverheadDisplayService
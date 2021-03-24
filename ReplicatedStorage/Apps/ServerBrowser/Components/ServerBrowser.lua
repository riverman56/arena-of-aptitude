local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Background = require(script.Parent.Background)

local ServerBrowser = Roact.Component:extend("ServerBrowser")

function ServerBrowser:render()
    return Roact.createElement("ScreenGui", {
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    }, {
        Background = Roact.createElement(Background),
    })
end

function mapStateToProps(state)
    return {
        servers = state.Servers,
    }
end

return RoactRodux.connect(mapStateToProps)(ServerBrowser)
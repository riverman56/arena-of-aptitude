local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local ServerBrowser = require(script.Parent.ServerBrowser)

local App = Roact.Component:extend("App")

function App:render()
    return Roact.createElement(RoactRodux.StoreProvider, {
        store = self.props.store,
    }, {
        ServerBrowser = Roact.createElement(ServerBrowser)
    })
end

return App
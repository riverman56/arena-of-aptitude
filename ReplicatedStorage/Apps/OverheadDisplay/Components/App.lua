local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Billboard = require(script.Parent.Billboard)

local App = Roact.Component:extend("App")

function App:render()
    return Roact.createElement(RoactRodux.StoreProvider, {
        store = self.props.store,
    }, {
        Billboard = Roact.createElement(Billboard, {
            character = self.props.character,
        })
    })
end

return App
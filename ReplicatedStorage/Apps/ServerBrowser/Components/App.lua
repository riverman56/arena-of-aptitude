local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local ServerBrowser = require(script.Parent.ServerBrowser)
local Background = require(script.Parent.Background)

local App = Roact.Component:extend("App")

function App:render()
    local children = {}

    if self.props.isStory then
        -- for Hoarcekat stories we don't want to render the ScreenGui so we
        -- cut directly to the background
        children["ServerBrowser"] = Roact.createElement(Background)
    else
        children["ServerBrowser"] = Roact.createElement(ServerBrowser)
    end
    return Roact.createElement(RoactRodux.StoreProvider, {
        store = self.props.store,
    }, children)
end

return App
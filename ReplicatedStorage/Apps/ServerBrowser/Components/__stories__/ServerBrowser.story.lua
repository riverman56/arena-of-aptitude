local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local Rodux = require(ReplicatedStorage.Modules.Rodux)

local UpdateServers = require(script.Parent.Parent.Parent.Actions.UpdateServers)
local SetIsOpen = require(script.Parent.Parent.Parent.Actions.SetIsOpen)

local reducer = require(script.Parent.Parent.Parent.Reducers.serverBrowserReducer)
local stub = require(script.Parent["ServerBrowser.stub"])

local app = require(script.Parent.Parent.Parent.Components.App)

return function(target)
    Roact.setGlobalConfig({
        elementTracing = true,
    })

    local store = Rodux.Store.new(reducer, nil, {
        Rodux.loggerMiddleware,
    })

    local root = Roact.createElement(app, {
        store = store,
        isStory = true,
    })

    store:dispatch(SetIsOpen(false))
    store:dispatch(UpdateServers(stub.storyState))

    local handle = Roact.mount(root, target, "ServerBrowser")
    store:dispatch(SetIsOpen(true))

    return function()
        Roact.unmount(handle)
    end
end
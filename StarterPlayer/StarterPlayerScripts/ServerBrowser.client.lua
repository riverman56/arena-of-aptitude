local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Knit)
local Roact = require(ReplicatedStorage.Modules.Roact)
local Rodux = require(ReplicatedStorage.Modules.Rodux)

local ServerBrowserService = Knit.GetService("ServerBrowserService")

local ServerBrowser = ReplicatedStorage.Apps.ServerBrowser

local UpdateServers = require(ServerBrowser.Actions.UpdateServers)
local SetIsOpen = require(ServerBrowser.Actions.SetIsOpen)

local reducer = require(ServerBrowser.Reducers.serverBrowserReducer)

local app = require(ServerBrowser.Components.App)
local store = Rodux.Store.new(reducer)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local REFRESH_RATE = 3

function heartbeatWait(seconds)
	while seconds > 0 do
		seconds -= RunService.Heartbeat:Wait()
	end
end

store:dispatch(SetIsOpen(false))
store:dispatch(UpdateServers(ServerBrowserService.servers:Get()))

local root = Roact.createElement(app, {
    store = store,
})

Roact.mount(root, playerGui, "ServerBrowser")

coroutine.wrap(function()
    while true do
        local state = store:getState()
        if state.ServerBrowser.isOpen == true then
            store:dispatch(UpdateServers(ServerBrowserService.servers:Get()))
        end

        heartbeatWait(REFRESH_RATE)
    end
end)()

player.Chatted:Connect(function(message)
    if string.lower(message) == "!servers" then
        store:dispatch(SetIsOpen(true))
    end
end)
--[[
    Handles MessagingService incoming calls and publishes outgoing requests for
    the server browsing system. It's important to note that delivery isn't
    guaranteed and MessagingService will fail if Roblox is having problems, so
    this codebase's architecture is built around the aspect.

    (server listings will not publish if this is a private server)
    When a player joins the game, a message is sent to all servers with this
    current game's data (job id, player count, server region)

    We want to save as much data in our outgoing calls as possible so we have
    a predetermined order of data that goes as follows:

    data = {
        [1] = "{SERVER_REGION}:{JOB_ID}:{PLAYER_COUNT},
        XXXXXX [2] = {array_of_userids} XXXXXX
    }

    When a server is killed (no players), it is removed from the server browser.
    Content updates are served when players join and leave servers.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Knit)
local RemoteProperty = require(Knit.Util.Remote.RemoteProperty)

local getServerRegion = require(ReplicatedStorage.Utility.getServerRegion)

local ServerBrowserService = Knit.CreateService({
    Name = "ServerBrowserService",
    Client = {},
})

ServerBrowserService.servers = {}
ServerBrowserService.Client.servers = RemoteProperty.new(ServerBrowserService.servers)

function getUserIds()
    local players = Players:GetPlayers()
    local userIds = table.create(#players)

    for _, player in pairs(players) do
        table.insert(userIds, player.UserId)
    end

    return userIds
end

function ServerBrowserService:deliverServerContent()
    MessagingService:PublishAsync("ServerBrowserContentDelivery", {
        [1] = string.format("%s:%s:%s", ServerBrowserService.region, game.JobId, tostring(#Players:GetPlayers())),
        [2] = getUserIds(),
    })
end

function ServerBrowserService:deliverRunningServerData()
    MessagingService:PublishAsync("ServerBrowserReceiveRunningServerData", {
        [1] = string.format("%s:%s:%s", ServerBrowserService.region, game.JobId, tostring(#Players:GetPlayers())),
        [2] = getUserIds(),
    })
end

function ServerBrowserService:deliverKilledServer()
    MessagingService:PublishAsync("ServerBrowserKilledServer", {
        [1] = game.JobId,
    })
end

function ServerBrowserService:requestServers()
    --[[
        This is the requesting end and runs when a server first starts up, so
        that it can receive immediate data from other running servers.
    ]]

    MessagingService:PublishAsync("ServerBrowserRequestRunningServers", {
        [1] = game.JobId,
    })
end

function ServerBrowserService:ingestRunningServersRequest()
    --[[
        Upon server spinup, the server will request data from all servers.
        This is the receiving end and this runs on other servers when a
        server first spins up. It will broadcast this server's data to
        every other server, including the brand new server.
    ]]
    local sourceJobId = self.Data[1]

    if sourceJobId == game.JobId then
        -- If receiving end is the requesting end, don't send back data
        -- because it will be our own server.
        return
    end
    
    -- send a response to all servers with this server's information
    ServerBrowserService:deliverRunningServerData()
end

function ServerBrowserService:ingestServerData()
    -- turn our compressed data into something easier to work with
    local userIds = self.Data[2]
    self = string.split(self.Data[1], ":")
    table.insert(self, userIds)

    local jobId = self[2]
    ServerBrowserService.servers[jobId] = {
        region = self[1],
        jobId = self[2],
        playerCount = self[3],
        userIds = self[4]
    }
    ServerBrowserService.Client.servers:Set(ServerBrowserService.servers)
end

function ServerBrowserService:ingestKilledServerData()
    local jobId = self.Data[1]

    if ServerBrowserService.servers[jobId] then
        ServerBrowserService.servers[jobId] = nil
        ServerBrowserService.Client.servers:Set(ServerBrowserService.servers)
    end
end

function ServerBrowserService:KnitInit()
    self.region = getServerRegion()

    MessagingService:SubscribeAsync("ServerBrowserKilledServer", self.ingestKilledServerData)
    MessagingService:SubscribeAsync("ServerBrowserContentDelivery", self.ingestServerData)
    MessagingService:SubscribeAsync("ServerBrowserRequestRunningServers", self.ingestRunningServersRequest)
    MessagingService:SubscribeAsync("ServerBrowserReceiveRunningServerData", self.ingestServerData)

    -- When a player joins the game, tell all servers to add it to their
    -- servers list,
    Players.PlayerAdded:Connect(function()
        self.deliverServerContent()
    end)

    -- When a player leaves the server, send this information to other servers
    -- to update; but if the server now has 0 players, tell all servers
    -- to remove it from their servers list.
    Players.PlayerRemoving:Connect(function()
        if #Players:GetPlayers() == 0 then
            self:deliverKilledServer()
        else
            self:deliverServerContent()
        end
    end)

    -- (server startup) Request all running server data.
    self:requestServers()
end

return ServerBrowserService
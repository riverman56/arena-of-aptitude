local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Server = require(script.Parent.Server)

local ServerList = Roact.Component:extend("ServerList")

function ServerList:init()
    self.canvasSize, self.updateCanvasSize = Roact.createBinding()

    self.canvasSize = self.canvasSize:map(function(size)
        return UDim2.new(0, 0, 0, size)
    end)
end

function ServerList:render()
    local children = {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingLeft = UDim.new(-0.04, 0),
            PaddingTop = UDim.new(0, 6),
        }),
        UIListLayout = Roact.createElement("UIListLayout", {
            Padding = UDim.new(0, 5),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            [Roact.Change.AbsoluteContentSize] = function(instance)
                self.updateCanvasSize(instance.AbsoluteContentSize.Y)
            end,
        }),
    }

    for _, server in pairs(self.props.servers) do
        local serverElement = Roact.createElement(Server, {
            region = server.region,
            playerCount = server.playerCount,
            jobId = server.jobId,
            userIds = server.userIds,
            layoutOrder = Players.MaxPlayers - server.playerCount,
        })

        children[server.jobId] = serverElement
    end

    return Roact.createElement("ScrollingFrame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.515, 0, 0.53, 0),
        Size = UDim2.new(0.895, 0, 0.878, 0),
        ScrollBarImageColor3 = Color3.fromRGB(39, 39, 39),
        ScrollBarThickness = 4,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = self.canvasSize,
    }, {
        Container = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
        }, children)
    })
end

function mapStateToProps(state)
    return {
        servers = state.Servers,
    }
end

return RoactRodux.connect(mapStateToProps)(ServerList)
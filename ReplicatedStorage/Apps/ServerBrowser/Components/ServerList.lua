local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Server = require(script.Parent.Server)

local ServerList = Roact.Component:extend("ServerList")

function ServerList:init()
    self.parentScroller = Roact.createRef()
end

function ServerList:render()
    local children = {
        UIPadding = Roact.createElement("UIPadding", {
            PaddingTop = UDim.new(0.03, 0),
        }),
        UIListLayout = Roact.createElement("UIListLayout", {
            Padding = UDim.new(0.007, 0),
            [Roact.Change.AbsoluteContentSize] = function(value)
                if self.parentScroller:getValue() then
                    self.parentScroller:getValue().CanvasSize = UDim2.new(0, 0, 0, value.Y)
                end
            end,
        }),
    }

    for _, server in pairs(self.props.servers) do
        local serverElement = Roact.createElement(Server, {
            region = server.region,
            playerCount = server.playerCount,
            jobId = server.jobId,
            userIds = server.userIds,
        })

        children[tostring(Players.MaxPlayers - server.playerCount)] = serverElement
    end
    
    return Roact.createElement("ScrollingFrame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.515, 0, 0.53, 0),
        Size = UDim2.new(0.895, 0, 0.878, 0),
        ScrollBarImageColor3 = Color3.fromRGB(39, 39, 39),
        ScrollBarThickness = 4,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        [Roact.Ref] = self.parentScroller,

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
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Username = require(script.Parent.Username)
local HealthDisplay = require(script.Parent.HealthDisplay)

local getStudsOffset = require(script.Parent.Parent.Helpers.getStudsOffset)

local Billboard = Roact.Component:extend("Billboard")

function Billboard:init()
    self.attachment = Roact.createRef()
end

function Billboard:render()
    local username

    if self.props.character.Humanoid.DisplayName == "" or self.props.character.Humanoid.DisplayName == self.props.character.Name then
        username = self.props.character.Name
    else
        username = string.format("%s (%s)", self.props.character.Humanoid.DisplayName, self.props.character.Name)
    end

    local billboardSizeY = 1

    return Roact.createElement("BillboardGui", {
        Adornee = self.attachment,
        LightInfluence = 0,
        MaxDistance = 50,
        Size = UDim2.new(5, 0, 1, 0),
    }, {
        attachment = Roact.createElement(Roact.Portal, {
            target = self.props.character.HumanoidRootPart,
        }, {
            attachment = Roact.createElement("Attachment", {
                Position = getStudsOffset(billboardSizeY, self.props.character),
                [Roact.Ref] = self.attachment,
            })
        }),
        Username = Roact.createElement(Username, {
            username = username,
        }),
        HealthDisplay = Roact.createElement(HealthDisplay),
    })
end

local function mapStateToProps(state)
    return state
end

return RoactRodux.connect(mapStateToProps)(Billboard)
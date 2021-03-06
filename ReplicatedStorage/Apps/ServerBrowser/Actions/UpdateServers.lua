local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local UpdateServers = Rodux.makeActionCreator(script.Name, function(servers: table)
    return {
        Servers = servers,
    }
end)

return UpdateServers
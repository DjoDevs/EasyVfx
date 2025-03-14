--!strict
--!native
--!optimize 2

export type ServerBridgeImpl = {
    UpdatePlayers: () -> (),
}

export type InitalizedPlayers = {[Player]:boolean}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ServerBridge = {} :: ServerBridgeImpl

local InitalizedPlayers = {} :: InitalizedPlayers

local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)
local Indexer = require(ReplicatedStorage.Source.ClientVFX.Indexer)

local RequestPlayers = BridgeNet2.ServerBridge("PlayerBridge")
local ReturnPlayers = BridgeNet2.ServerBridge("ReturnPlayers")

--listens for new players and sends them the indexed players
RequestPlayers:Connect(function(player: Player)
    if InitalizedPlayers[player] == true then
        return
    end
    InitalizedPlayers[player] = true
    ReturnPlayers:Fire(player, Indexer.Players)
end)

-- updates specific all players
function ServerBridge.UpdatePlayers() : ()
    ReturnPlayers:Fire(BridgeNet2.AllPlayers(), Indexer.Players)
end

-- registers every player on runtime
for _,Player:Player in ipairs(Players:GetPlayers()) do
    Indexer.RegisterPlayer(Player)
    ServerBridge.UpdatePlayers()
end

-- registers new players
Players.PlayerAdded:Connect(function(a0: Player)
    if RunService:IsClient() then
        return
    end
    Indexer.RegisterPlayer(a0)
    ServerBridge.UpdatePlayers()
    InitalizedPlayers[a0] = false
end)

-- removes uneccesary players
Players.PlayerRemoving:Connect(function(a0: Player)
    if RunService:IsClient() then
        return
    end
    Indexer.UnRegisterPlayer(a0)
    ServerBridge.UpdatePlayers()
    InitalizedPlayers[a0] = nil
end)

ServerBridge.UpdatePlayers()

return ServerBridge
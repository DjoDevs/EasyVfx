--!strict
--!native
--!optimize 2
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BridgeNet2 = require(ReplicatedStorage.Packages.BridgeNet2)

export type PlayersImpl = {Player}
export type ClientBridgeImpl = {
    Players: PlayersImpl,
    GetPlayerById: (Id:number) -> Player
}

local ClientBridge = {} :: ClientBridgeImpl

ClientBridge.Players = {} :: PlayersImpl

local RequestPlayers = BridgeNet2.ReferenceBridge("PlayerBridge")
local ReturnPlayers = BridgeNet2.ReferenceBridge("ReturnPlayers")

--listens to player updates
ReturnPlayers:Connect(function(NewIndexes: PlayersImpl)
    ClientBridge.Players = NewIndexes
end)

--requests player indexes from the server
local function InitalStartUp() : ()
    repeat     
        task.wait()
    until game:IsLoaded()
    RequestPlayers:Fire()
end

InitalStartUp()

function ClientBridge.GetPlayerById(id:number) : Player
    return ClientBridge.Players[id]
end


return ClientBridge
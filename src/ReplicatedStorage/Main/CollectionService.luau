--!strict

type CollectionServiceMethods = {
    Register: (player: Player) -> (),
    GetPlayerByIndex: (index: number) -> Player?,
    Remove: (player: Player) -> (),
    GetPlayerByName: (playername: string) -> number?,
    GetVfxByIndex: (index: number) -> BasePart?,
    GetVfxByName: (name: string) -> number?,
    GetPartByIndex: (index: number) -> string,
    GetPartByName: (name: string) -> number?,
}

type PlayerType = {
    player: Player,
    index: number
}

type VfxData = {
    Index: number,
    VfxPath: BasePart,
    Name: string
}

type ImpactFrameStruct = {
    Index: number,
    Name: string
}

local rs = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local parts = {
    [1] = "HumanoidRootPart",
    [2] = "Torso",
    [3] = "Right Arm",
    [4] = "Left Arm",
    [5] = "Right Leg",
    [6] = "Left Leg",
    [7] = "Head"
} :: {[number]: string}

local Vfxs = { 
--    {
--        Index = 1, -- i just added this to make it cleaner
--        VfxPath = rs.ClientEffects.Effects.NormalHit, -- VERY IMPORTANT THIS IS THE PATH OF THE VFX (THE PART THATS GETTING USED)
--        Name = "NormalHit" -- this is used to get the part by name
--    },
{
 Index = 1,
 VfxPath = rs.FirstAttempt,
 Name = "FirstAttempt"
},
} :: VfxData

local PlayersStored = {} :: {PlayerType}

local CollectionService = {} :: CollectionServiceMethods

local function sortPlayersAlphabetically()
    table.sort(PlayersStored, function(a, b)
        return a.player.Name < b.player.Name
    end)
    for i, player in ipairs(PlayersStored) do
        player.index = i
    end
end

function CollectionService.Register(player: Player)
    for _, v in ipairs(PlayersStored) do
        if v.player == player then
            return
        end
    end
    table.insert(PlayersStored, {
        player = player,
        index = 0
    })
    sortPlayersAlphabetically()
end

function CollectionService.GetPlayerByIndex(index: number): Player?
    if PlayersStored[index] then
        return PlayersStored[index].player
    end
    return nil
end

function CollectionService.Remove(player: Player)
    for i = #PlayersStored, 1, -1 do
        if PlayersStored[i].player == player then
            table.remove(PlayersStored, i)
            break
        end
    end
    sortPlayersAlphabetically()
end

function CollectionService.GetPlayerByName(name: string): number?
    for i, v in ipairs(PlayersStored) do
        if v.player.Name == name then
            return i
        end
    end
    return nil
end

function CollectionService.GetVfxByIndex(index: number): BasePart?
    return Vfxs[index].VfxPath
end

function CollectionService.GetVfxByName(name: string): number?
    for i, v in ipairs(Vfxs) do
        if v.Name == name then
            return i
        end
    end
    return nil
end

function CollectionService.GetPartByIndex(index: number): string
    return parts[index]
end

function CollectionService.GetPartByName(name: string): number?
    for i, v in ipairs(parts) do
        if v == name then
            return i
        end
    end
    return nil
end

for _, v in ipairs(players:GetPlayers()) do
    CollectionService.Register(v)
end

players.PlayerAdded:Connect(function(player: Player)
    CollectionService.Register(player)
end)

players.PlayerRemoving:Connect(function(player: Player)
    CollectionService.Remove(player)
end)

return CollectionService
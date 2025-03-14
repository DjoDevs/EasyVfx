--!native
--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Indexer = require(ReplicatedStorage.Source.ClientVFX.Indexer)
local Server = require(ReplicatedStorage.Source.ClientVFX.Networking.Server)
local ServerBridge = require(ReplicatedStorage.Source.ClientVFX.Networking.ServerBridge)

export type ServerVfxImpl = {
    ClientVFX: (Player:Player, Vfx:string, Duration:number,Part:string) -> (),
    ClientVFXRotation: (Player:Player, Vfx:string, Duration:number,Part:string, Orientation:{X:number,Y:number,Z:number}) -> (),
    ClientVFXRotationAndPosition: (Player:Player, Vfx:string, Duration:number,Part:string, Orientation:{X:number,Y:number,Z:number}, Position:{X:number,Y:number,Z:number}) -> (),
    ClientVFXPosition: (Player:Player, Vfx:string, Duration:number,Part:string, Position:{X:number,Y:number,Z:number}) -> (),
}

local ServerVFX = {} :: ServerVfxImpl

-- tells all clients to play the vfx
function ServerVFX.ClientVFX(Player:Player, Vfx:string, Duration:number,Part:string) : ()
    if not Indexer.Loaded then
        warn("Server not loaded yet!")
        return
    end
    Server.ClientVFX.FireAll({
        plr = Indexer.GetIndexByPlayer(Player),
        Vfx = Indexer.GetVfxIdByName(Vfx),
        Duration = Duration,
        Part = Indexer.GetPartByName(Part),
    })
end

-- tells all clients to play the vfx with rotation
function ServerVFX.ClientVFXRotation(Player:Player, Vfx:string, Duration:number,Part:string, Orientation:{X:number,Y:number,Z:number}): ()
    if not Indexer.Loaded then
        warn("Server not loaded yet!")
        return
    end
    Server.ClientVFXRotation.FireAll({
        plr = Indexer.GetIndexByPlayer(Player),
        Vfx = Indexer.GetVfxIdByName(Vfx),
        Duration = Duration,
        Part = Indexer.GetPartByName(Part),
        Orientation = {X = math.deg(Orientation.X) * 10000, Y = math.deg(Orientation.Y)* 10000, Z = math.deg(Orientation.Z)* 10000}
    })
end

-- tells all clients to play the vfx with rotation and position
function ServerVFX.ClientVFXRotationAndPosition(Player:Player, Vfx:string, Duration:number,Part:string, Orientation:{X:number,Y:number,Z:number}, Position:{X:number,Y:number,Z:number}): ()
    if not Indexer.Loaded then
        warn("Server not loaded yet!")
        return
    end
    Server.ClientVFXRotationAndPosition.FireAll({
        plr = Indexer.GetIndexByPlayer(Player),
        Vfx = Indexer.GetVfxIdByName(Vfx),
        Duration = Duration,
        Part = Indexer.GetPartByName(Part),
        Orientation = {X = math.deg(Orientation.X) * 10000, Y = math.deg(Orientation.Y)* 10000, Z = math.deg(Orientation.Z)* 10000},
        Position = {X = Position.X, Y = Position.Y, Z = Position.Z}
    })
end

-- tells all clients to play the vfx with position
function ServerVFX.ClientVFXPosition(Player:Player, Vfx:string, Duration:number,Part:string, Position:{X:number,Y:number,Z:number}): ()
    if not Indexer.Loaded then
        warn("Server not loaded yet!")
        return
    end
    Server.ClientVFXPosition.FireAll({
        plr = Indexer.GetIndexByPlayer(Player),
        Vfx = Indexer.GetVfxIdByName(Vfx),
        Duration = Duration,
        Part = Indexer.GetPartByName(Part),
        Position = {X = Position.X, Y = Position.Y, Z = Position.Z}
    })
end

return ServerVFX

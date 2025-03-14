--!strict

type ServerEffectsMethods = {
    NoCFrameEffect:(playername:string,Effect:string,Duration:number,Part:string ) -> (),
    CFrameEffect:(playername:string,effect:string,Duration:number,part:string, Position: {X:number, Y:number, Z:number} ) -> (),
    CFrameEffectWithOrientation:(playername:string,effect:string,Duration:number,part:string,Position: {X:number, Y:number, Z:number}, Orientation:number ) -> (),
    NoCFrameWithOrientation:(playername:string,effect:string,Duration:number,part:string,Orientation:number ) -> (),
}
local rs = game:GetService("ReplicatedStorage")
local CollectionService = require(rs.Source.Main.CollectionService)
local BlinkServer = require(script.Parent.Server)

local ServerEffects = {} :: ServerEffectsMethods

function ServerEffects:NoCFrameEffect(Plr: string, Vfx: string, Duration: number, part:string)
	local vfxData = {
		Plr = CollectionService.GetPlayerByName(Plr),
		Vfx = CollectionService.GetVfxByName(Vfx),
		Duration = Duration,
		part = CollectionService.GetPartByName(part),
	}
	BlinkServer.ClientVfx.FireAll(vfxData)
end

function ServerEffects:CFrameEffect(Plr: string, Vfx: string, Duration: number, part: string, Position: Vector3)
	local vfxData = {
		Plr = CollectionService.GetPlayerByName(Plr),
		Vfx = CollectionService.GetVfxByName(Vfx),
		Duration = Duration,
		part = CollectionService.GetPartByName(part),
		Position = {X = Position.X, Y = Position.Y, Z = Position.Z}
	}
	BlinkServer.ClientVfxCFrame.FireAll(vfxData)
end

function ServerEffects:CFrameEffectWithOrientation(Plr: string, Vfx: string, Duration: number, part: string, Position: Vector3, Orientation: number)
	local vfxData = {
		Plr = CollectionService.GetPlayerByName(Plr),
		Vfx = CollectionService.GetVfxByName(Vfx),
		Duration = Duration,
		part = CollectionService.GetPartByName(part),
		Position = {X = Position.X, Y = Position.Y, Z = Position.Z},
		Orientation = math.rad(Orientation) * 10000
	}
	BlinkServer.ClientVfxCFrameAndOrientation.FireAll(vfxData)
end

function ServerEffects:NoCFrameWithOrientation(Plr: string, Vfx: string, Duration: number, part: string, Orientation: number)
	local vfxData = {
		Plr = CollectionService.GetPlayerByName(Plr),
		Vfx = CollectionService.GetVfxByName(Vfx),
		Duration = Duration,
		part = CollectionService.GetPartByName(part),
		Orientation = math.rad(Orientation) * 10000
	}
	BlinkServer.ClientVfxNoCFrameWithOrientation.FireAll(vfxData)
end

return ServerEffects
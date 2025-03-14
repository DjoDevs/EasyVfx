--!strict
--!native
--!optimize 2
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

export type IndexerImpl = {
	RegisterPlayer: (Player: Player) -> (),
	UnRegisterPlayer: (Player: Player) -> (),
	GetPlayerByIndex: (Id: number) -> Player,
	GetIndexByPlayer: (Player: Player) -> number,
	RegisterVFX: (Name: string, Index: number, Path: Instance) -> (),
	GetVfxByName: (Name: string) -> BasePart,
	GetVfxByIndex: (Id: number) -> BasePart,
	GetVfxIdByName: (Name: string) -> number,
	GetVfxNameById: (Id: number) -> string,
	GetPartByName: (Name: string) -> number,
	GetPartById: (Id: number) -> string,
	RunTimeRegister: () -> (),
	Players: PlayersImpl,
	Loaded: boolean,
}

export type PlayersImpl = { Player }
export type VFXMapByName = { [string]: {Part:Instance, Index:number} }
export type VFXMapByIndex = { [number]: {Part:Instance, Name:string} }

local VFXByName = {} :: VFXMapByName
local VFXByIndex = {} :: VFXMapByIndex

local IndexedParts = {
	[1] = "HumanoidRootPart",
	[2] = "Torso",
	[3] = "Right Arm",
	[4] = "Left Arm",
	[5] = "Right Leg",
	[6] = "Left Leg",
	[7] = "Head",
} :: { [number]: string }

local NamedParts = {
	["HumanoidRootPart"] = 1,
	["Torso"] = 2,
	["Right Arm"] = 3,
	["Left Arm"] = 4,
	["Right Leg"] = 5,
	["Left Leg"] = 6,
	["Head"] = 7,
} :: { [string]: number }

local Indexer = {} :: IndexerImpl

Indexer.Players = {} :: PlayersImpl
Indexer.Loaded = false :: boolean

-- registers the player to the player table
function Indexer.RegisterPlayer(Player: Player)
	if RunService:IsClient() then
		return
	end
	if table.find(Indexer.Players, Player) then
		return
	end
	table.insert(Indexer.Players, Player)
end

-- unregisters the player from the player table
function Indexer.UnRegisterPlayer(Player: Player)
	if RunService:IsClient() then
		return
	end
	local index = Indexer.GetIndexByPlayer(Player)
	if index then
		table.remove(Indexer.Players, index)
	end
end

--gets the player by their index
function Indexer.GetPlayerByIndex(Id: number): Player
	return Indexer.Players[Id]
end

-- gets index by the player
function Indexer.GetIndexByPlayer(Player: Player): number?
	for index, plr in ipairs(Indexer.Players) do
		if plr == Player then
			return index
		end
	end
	return nil
end

--gets the part by the id
function Indexer.GetPartById(Id: number): string?
	return IndexedParts[Id]
end

--gets the part by its name
function Indexer.GetPartByName(Name: string): number?
	return NamedParts[Name]
end

function Indexer.GetVfxIdByName(Name:string) : number
	return VFXByName[Name].Index
end


function Indexer.GetVfxNameById(Index:number) : string
	return VFXByIndex[Index].Name
end

-- registers ur vfx to the table
function Indexer.RegisterVFX(Name: string, Index: number, Path: Instance): ()
	VFXByName[Name] = {Part = Path, Index = Index}
	VFXByIndex[Index] = {Part = Path, Name = Name}
end

-- gets the vfx by name
function Indexer.GetVfxByName(Name: string): Instance?
	return VFXByName[Name].Part
end

-- gets the vfx by index
function Indexer.GetVfxByIndex(Id: number): Instance?
	return VFXByIndex[Id].Part
end

function Indexer.RunTimeRegister(): ()
--	Indexer.RegisterVFX("FirstAttempt", 1, ReplicatedStorage.FirstAttempt) THIS IS AN EXAMPLE
	Indexer.Loaded = true
end

Indexer.RunTimeRegister()

return Indexer

--!strict
--!native
--!optimize 2

repeat
    task.wait()
until game:IsLoaded()

-- module loader client

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Source.ClientVFX)
require(ReplicatedStorage.Source.ClientVFX.Indexer)
require(ReplicatedStorage.Source.ClientVFX.Networking.Client)
require(ReplicatedStorage.Source.ClientVFX.Networking.ClientBridge)
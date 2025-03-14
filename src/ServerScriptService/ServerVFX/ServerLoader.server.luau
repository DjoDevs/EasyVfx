--!strict
--!native
--!optimize 2

--this loads the modules
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Source.ClientVFX.Indexer)
require(ReplicatedStorage.Source.ClientVFX.Networking.Server)
require(ReplicatedStorage.Source.ClientVFX.Networking.ServerBridge)
local a = require(script.Parent)

task.wait(3)
local rotation = {
    X = 50,
    Y = 90,
    Z = 10
}
local position = {
    X = 5,
    Y = 5,
    Z = 5
}
a.ClientVFX(Players:WaitForChild("djolefuull2", 100), "FirstAttempt", 10, "HumanoidRootPart")
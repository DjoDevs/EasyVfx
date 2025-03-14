--!strict
--!native
--!optimize 2

--this loads the modules
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Source.ClientVFX.Indexer)
require(ReplicatedStorage.Source.ClientVFX.Networking.Server)
require(ReplicatedStorage.Source.ClientVFX.Networking.ServerBridge)
local ServerVfx = require(script.Parent)

--[[
EXAMPLE USAGE!!!

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
ServerVfx.ClientVFX(Players:WaitForChild("djolefuull2", 100), "FirstAttempt", 10, "HumanoidRootPart")

ServerVfx.ClientVFXPosition(Players:WaitForChild("djolefuull2", 100), "FirstAttempt", 10, "HumanoidRootPart", position)

ServerVfx.ClientVFXPosition(Players:WaitForChild("djolefuull2", 100), "FirstAttempt", 10, "HumanoidRootPart", rotation)

ServerVfx.ClientVFXPosition(Players:WaitForChild("djolefuull2", 100), "FirstAttempt", 10, "HumanoidRootPart", rotation, position)
]]

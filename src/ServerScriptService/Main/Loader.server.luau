local z = require(script.Parent.ServerEffects)
local rs = game:GetService("ReplicatedStorage")
local a = require(rs.Source.Main.CollectionService)

task.wait(5)

z:NoCFrameWithOrientation("djolefuull2", "FirstAttempt", 10000, "HumanoidRootPart",game.Players.djolefuull2.Character.HumanoidRootPart.Orientation.Y)
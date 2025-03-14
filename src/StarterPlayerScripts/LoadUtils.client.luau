repeat
    task.wait()
until game:IsLoaded()
local rs = game:GetService("ReplicatedStorage")

require(rs.Source.Main.Loader)
--!strict
--!native
--!optimize 2
local VisualizationModeService = game:GetService("VisualizationModeService")
local Indexer = require(script.Indexer)
local Client = require(script.Networking.Client)
local ClientBridge = require(script.Networking.ClientBridge)

export type ClientVfxImpl = {
    PlayEffect: (Player:number, Vfx:number, Duration:number,Part:number) -> (),
    PlayEffectRotation: (Player:number, Vfx:number, Duration:number,Part:number, Orientation:{X:number,Y:number,Z:number}) -> (),
    PlayEffectRotationAndPosition: (Player:number, Vfx:number, Duration:number,Part:number, Orientation:{X:number,Y:number,Z:number}, Position:{X:number,Y:number,Z:number}) -> (),
    PlayEffectPosition: (Player:number, Vfx:number, Duration:number,Part:number, Position:{X:number,Y:number,Z:number}) -> (),
}

local ClientVFX = {} :: ClientVfxImpl

--function that plays the effect normally
function ClientVFX.PlayEffect(Player:number, Vfx:number, Duration:number,Part:number) : ()
    if not Indexer.Loaded then
        error("Tried to play vfx before client was loaded")
        return 
    end
    local Plr = ClientBridge.GetPlayerById(Player)
    if not Plr then
        error("Player doesnt exist?!!?")
        return 
    end
    local VfxPart = Indexer.GetVfxByIndex(Vfx):Clone()
    local PartName = Indexer.GetPartById(Part)
    local Character =  Plr.Character
    if not Character then
        error("Player doesnt have a character at the moment.")
        return
    end
    local AttachPart = Character:FindFirstChild(PartName) :: BasePart
    local Weld = Instance.new("Motor6D")
    Weld.Name = "EffectWeld"
    Weld.Part0 = AttachPart
    Weld.Part1 = VfxPart

    Weld.Parent = VfxPart
    VfxPart.Parent = AttachPart
    for _, Child in ipairs(VfxPart:GetDescendants()) do
        if Child:IsA("ParticleEmitter") then
            task.spawn(function()
                --CAUSES A WEIRD ERROR IF I DONT DEFINE EMITDELAY/COUNT/EMIT DURATION LIKE THIS
                local EmitDelay = (Child:GetAttribute("EmitDelay") :: number) or 0
                local EmitCount = (Child:GetAttribute("EmitCount") :: number) or 0
                local EmitDuration = (Child:GetAttribute("EmitDuration") :: number) or 0

                task.delay(EmitDelay, function()
                    Child:Emit(EmitCount)
                    if EmitDuration > 0 then
                        Child.Enabled = true
                        task.delay(EmitDuration, function()
                            Child.Enabled = false
                        end)
                    end
                end)
            end)
        end
    end
    task.delay(Duration, function()
        VfxPart:Destroy()
    end)
end

--function that plays the effect with only rotation
function ClientVFX.PlayEffectRotation(Player:number, Vfx:number, Duration:number,Part:number, Orientation:{X:number,Y:number,Z:number}) : ()
    if not Indexer.Loaded then
        error("Tried to play vfx before client was loaded")
        return 
    end
    local Plr = ClientBridge.GetPlayerById(Player)
    if not Plr then
        error("Player doesnt exist?!!?")
        return 
    end
    local VfxPart = Indexer.GetVfxByIndex(Vfx):Clone()
    local PartName = Indexer.GetPartById(Part)
    local Character =  Plr.Character
    if not Character then
        error("Player doesnt have a character at the moment.")
        return
    end
    local AttachPart = Character:FindFirstChild(PartName) :: BasePart
    local Weld = Instance.new("Motor6D")
    Weld.Name = "EffectWeld"
    Weld.Part0 = AttachPart
    Weld.Part1 = VfxPart

    Weld.Parent = VfxPart
    VfxPart.Parent = AttachPart
    VfxPart.Orientation = vector.create(math.deg(Orientation.X /10000),math.deg(Orientation.Y /10000),math.deg(Orientation.Z /10000))
    for _, Child in ipairs(VfxPart:GetDescendants()) do
        if Child:IsA("ParticleEmitter") then
            task.spawn(function()
                --CAUSES A WEIRD ERROR IF I DONT DEFINE EMITDELAY/COUNT/EMIT DURATION LIKE THIS
                local EmitDelay = (Child:GetAttribute("EmitDelay") :: number) or 0
                local EmitCount = (Child:GetAttribute("EmitCount") :: number) or 0
                local EmitDuration = (Child:GetAttribute("EmitDuration") :: number) or 0

                task.delay(EmitDelay, function()
                    Child:Emit(EmitCount)
                    if EmitDuration > 0 then
                        Child.Enabled = true
                        task.delay(EmitDuration, function()
                            Child.Enabled = false
                        end)
                    end
                end)
            end)
        end
    end
    task.delay(Duration, function()
        VfxPart:Destroy()
    end)
end

--function that plays the effect with position and rotation
function ClientVFX.PlayEffectRotationAndPosition(Player:number, Vfx:number, Duration:number,Part:number, Orientation:{X:number,Y:number,Z:number}, Position:{X:number,Y:number,Z:number}) : ()
    if not Indexer.Loaded then
        error("Tried to play vfx before client was loaded")
        return 
    end
    local Plr = ClientBridge.GetPlayerById(Player)
    if not Plr then
        error("Player doesnt exist?!!?")
        return 
    end
    local VfxPart = Indexer.GetVfxByIndex(Vfx):Clone()
    local PartName = Indexer.GetPartById(Part)
    local Character =  Plr.Character
    if not Character then
        error("Player doesnt have a character at the moment.")
        return
    end
    local AttachPart = Character:FindFirstChild(PartName) :: BasePart
    local Weld = Instance.new("Motor6D")
    Weld.Name = "EffectWeld"
    Weld.Part0 = AttachPart
    Weld.Part1 = VfxPart
    Weld.C0 = CFrame.new(Position.X, Position.Y, Position.Z)

    Weld.Parent = VfxPart
    VfxPart.Parent = AttachPart
    VfxPart.Orientation = vector.create(math.deg(Orientation.X /10000),math.deg(Orientation.Y /10000),math.deg(Orientation.Z /10000))
    for _, Child in ipairs(VfxPart:GetDescendants()) do
        if Child:IsA("ParticleEmitter") then
            task.spawn(function()
                --CAUSES A WEIRD ERROR IF I DONT DEFINE EMITDELAY/COUNT/EMIT DURATION LIKE THIS
                local EmitDelay = (Child:GetAttribute("EmitDelay") :: number) or 0
                local EmitCount = (Child:GetAttribute("EmitCount") :: number) or 0
                local EmitDuration = (Child:GetAttribute("EmitDuration") :: number) or 0

                task.delay(EmitDelay, function()
                    Child:Emit(EmitCount)
                    if EmitDuration > 0 then
                        Child.Enabled = true
                        task.delay(EmitDuration, function()
                            Child.Enabled = false
                        end)
                    end
                end)
            end)
        end
    end
    task.delay(Duration, function()
        VfxPart:Destroy()
    end)
end

--function that plays the effect with only position
function ClientVFX.PlayEffectPosition(Player:number, Vfx:number, Duration:number,Part:number, Position:{X:number,Y:number,Z:number}) : ()
    if not Indexer.Loaded then
        error("Tried to play vfx before client was loaded")
        return 
    end
    local Plr = ClientBridge.GetPlayerById(Player)
    if not Plr then
        error("Player doesnt exist?!!?")
        return 
    end
    local VfxPart = Indexer.GetVfxByIndex(Vfx):Clone()
    local PartName = Indexer.GetPartById(Part)
    local Character =  Plr.Character
    if not Character then
        error("Player doesnt have a character at the moment.")
        return
    end
    local AttachPart = Character:FindFirstChild(PartName) :: BasePart
    local Weld = Instance.new("Motor6D")
    Weld.Name = "EffectWeld"
    Weld.Part0 = AttachPart
    Weld.Part1 = VfxPart
    Weld.C0 = CFrame.new(Position.X, Position.Y, Position.Z)

    Weld.Parent = VfxPart
    VfxPart.Parent = AttachPart
    for _, Child in ipairs(VfxPart:GetDescendants()) do
        if Child:IsA("ParticleEmitter") then
            task.spawn(function()
                --CAUSES A WEIRD ERROR IF I DONT DEFINE EMITDELAY/COUNT/EMIT DURATION LIKE THIS
                local EmitDelay = (Child:GetAttribute("EmitDelay") :: number) or 0
                local EmitCount = (Child:GetAttribute("EmitCount") :: number) or 0
                local EmitDuration = (Child:GetAttribute("EmitDuration") :: number) or 0

                task.delay(EmitDelay, function()
                    Child:Emit(EmitCount)
                    if EmitDuration > 0 then
                        Child.Enabled = true
                        task.delay(EmitDuration, function()
                            Child.Enabled = false
                        end)
                    end
                end)
            end)
        end
    end
    task.delay(Duration, function()
        VfxPart:Destroy()
    end)
end

Client.ClientVFX.On(function(Value)
    ClientVFX.PlayEffect(Value.plr, Value.Vfx, Value.Duration, Value.Part)
end)

Client.ClientVFXPosition.On(function(Value)
    ClientVFX.PlayEffectPosition(Value.plr, Value.Vfx, Value.Duration, Value.Part, Value.Position)
end)

Client.ClientVFXRotation.On(function(Value)
    ClientVFX.PlayEffectRotation(Value.plr, Value.Vfx, Value.Duration, Value.Part, Value.Orientation)
end)

Client.ClientVFXRotationAndPosition.On(function(Value)
    ClientVFX.PlayEffectRotationAndPosition(Value.plr, Value.Vfx, Value.Duration, Value.Part, Value.Orientation, Value.Position)
end)

return ClientVFX
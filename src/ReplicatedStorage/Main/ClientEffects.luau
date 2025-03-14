local rs = game:GetService("ReplicatedStorage")
local blinkclient = require(script.Parent.Client)
local collectionservice = require(script.Parent.CollectionService)
local ClientEffects = {}

function ClientEffects:PlayEffect(plr1: number, vfx1: number, EffectDuration: number, part12: number)
	local player = collectionservice.GetPlayerByIndex(plr1)
	local effectParent = collectionservice.GetVfxByIndex(vfx1):Clone()
	local part1 = collectionservice.GetPartByIndex(part12)
	local character = player.Character
	local targetPart = character[part1]:: BasePart

	local weld = Instance.new("Motor6D")
	weld.Name = "EffectWeld"
	weld.Part0 = targetPart
	weld.Part1 = effectParent

	weld.Parent = effectParent
	effectParent.Parent = targetPart

	if effectParent:GetAttribute("Enabled") == true then
		task.delay(EffectDuration, function()
			effectParent:Destroy()
		end)
		return
	end
	for _, child in ipairs(effectParent:GetDescendants()) do
		if child:IsA("ParticleEmitter") then
			task.spawn(function()
				local emitDelay = child:GetAttribute("EmitDelay") or 0
				local emitCount = child:GetAttribute("EmitCount") or 0
				local emitDuration = child:GetAttribute("EmitDuration") or 0

				task.delay(emitDelay, function()
					child:Emit(emitCount)
					if emitDuration > 0 then
						child.Enabled = true
						task.delay(emitDuration, function()
							child.Enabled = false
						end)
					end
				end)
			end)
		end
	end
	task.delay(EffectDuration, function()
		effectParent:Destroy()
	end)
end

function ClientEffects:PlayEffectWithCFrame(plr1: number, vfx1: number, EffectDuration: number, part12: number, cf:CFrame)
	local player = collectionservice.GetPlayerByIndex(plr1)
	local effectParent = collectionservice.GetVfxByIndex(vfx1):Clone()
	local part1 = collectionservice.GetPartByIndex(part12)
	local character = player.Character
	local targetPart = character[part1]:: BasePart

	local weld = Instance.new("Motor6D")
	weld.Name = "EffectWeld"
	weld.Part0 = targetPart
	weld.Part1 = effectParent
	weld.C0 = cf
    

	weld.Parent = effectParent
	effectParent.Parent = targetPart

	if effectParent:GetAttribute("Enabled") then
		task.delay(EffectDuration, function()
			effectParent:Destroy()
		end)
		return
	end
	for _, child in ipairs(effectParent:GetDescendants()) do
		if child:IsA("ParticleEmitter") then
			task.spawn(function()
				local emitDelay = child:GetAttribute("EmitDelay") or 0
				local emitCount = child:GetAttribute("EmitCount") or 0
				local emitDuration = child:GetAttribute("EmitDuration") or 0

				task.delay(emitDelay, function()
					child:Emit(emitCount)
					if emitDuration > 0 then
						child.Enabled = true
						task.delay(emitDuration, function()
							child.Enabled = false
						end)
					end
				end)
			end)
		end
	end
	task.delay(EffectDuration, function()
		effectParent:Destroy()
	end)
end

function ClientEffects:PlayEffectWithCFrameAndOrientation(plr1: number, vfx1: number, EffectDuration: number, part12: number, cf:CFrame, Orientat:number)
	local player = collectionservice.GetPlayerByIndex(plr1)
	local effectParent = collectionservice.GetVfxByIndex(vfx1):Clone()
	local part1 = collectionservice.GetPartByIndex(part12)
	local character = player.Character
	local targetPart = character[part1]:: BasePart
	local orient = effectParent.Orientation

	local weld = Instance.new("Motor6D")
	weld.Name = "EffectWeld"
	weld.Part0 = targetPart
	weld.Part1 = effectParent
	weld.C0 = cf
	effectParent.Orientation = vector.create(orient.X, math.deg(Orientat), orient.Z)
	for _,v : Attachment in ipairs(effectParent:GetChildren()) do
		if v:IsA("Attachment") then
			v.Orientation = vector.create(v.Orientation.X,Orientat, v.Orientation.Z)
		end
	end
	weld.Parent = effectParent
	effectParent.Parent = targetPart

	if effectParent:GetAttribute("Enabled") then
		task.delay(EffectDuration, function()
			effectParent:Destroy()
		end)
		return
	end
	for _, child in ipairs(effectParent:GetDescendants()) do
		if child:IsA("ParticleEmitter") then
			task.spawn(function()
				local emitDelay = child:GetAttribute("EmitDelay") or 0
				local emitCount = child:GetAttribute("EmitCount") or 0
				local emitDuration = child:GetAttribute("EmitDuration") or 0

				task.delay(emitDelay, function()
					child:Emit(emitCount)
					if emitDuration > 0 then
						child.Enabled = true
						task.delay(emitDuration, function()
							child.Enabled = false
						end)
					end
				end)
			end)
		end
	end
	task.delay(EffectDuration, function()
		effectParent:Destroy()
	end)
end

function ClientEffects:PlayEffectWithOrientation(plr1: number, vfx1: number, EffectDuration: number, part12: number, Orientat:number)
	local player = collectionservice.GetPlayerByIndex(plr1)
	local effectParent = collectionservice.GetVfxByIndex(vfx1):Clone()
	local part1 = collectionservice.GetPartByIndex(part12)
	local character = player.Character
	local targetPart = character[part1]:: BasePart

	effectParent.Orientation = vector.create(effectParent.Orientation.X, math.deg(Orientat), effectParent.Orientation.Z)
	local weld = Instance.new("Motor6D")
	weld.Name = "EffectWeld"
	weld.Part0 = targetPart
	weld.Part1 = effectParent

    for _,v :Attachment in ipairs(effectParent:GetChildren()) do
        if v:IsA("Attachment") then
            v.Orientation = vector.create(v.Orientation.X, math.deg(Orientat), v.Orientation.Z)
        end
    end

	weld.Parent = effectParent
	effectParent.Parent = targetPart

	if effectParent:GetAttribute("Enabled") then
		task.delay(EffectDuration, function()
			effectParent:Destroy()
		end)
		return
	end
	for _, child in ipairs(effectParent:GetDescendants()) do
		if child:IsA("ParticleEmitter") then
			task.spawn(function()
				local emitDelay = child:GetAttribute("EmitDelay") or 0
				local emitCount = child:GetAttribute("EmitCount") or 0
				local emitDuration = child:GetAttribute("EmitDuration") or 0

				task.delay(emitDelay, function()
					child:Emit(emitCount)
					if emitDuration > 0 then
						child.Enabled = true
						task.delay(emitDuration, function()
							child.Enabled = false
						end)
					end
				end)
			end)
		end
	end
	task.delay(EffectDuration, function()
		effectParent:Destroy()
	end)
end

blinkclient.ClientVfx.On(function(Value: { Duration: number, Plr: number, Vfx: number, part: number })
    ClientEffects:PlayEffect(Value.Plr, Value.Vfx, Value.Duration, Value.part)
end)

blinkclient.ClientVfxCFrame.On(function(value)
    ClientEffects:PlayEffectWithCFrame(value.Plr, value.Vfx, value.Duration, value.part, CFrame.new(value.Position.X, value.Position.Y, value.Position.Z))
end)

blinkclient.ClientVfxCFrameAndOrientation.On(function(value)
    ClientEffects:PlayEffectWithCFrameAndOrientation(value.Plr, value.Vfx, value.Duration, value.part, CFrame.new(value.Position.X, value.Position.Y, value.Position.Z), value.Orientation / 10000)
end)

blinkclient.ClientVfxNoCFrameWithOrientation.On(function(value)
    ClientEffects:PlayEffectWithOrientation(value.Plr, value.Vfx, value.Duration, value.part, value.Orientation / 10000)
end)


return ClientEffects
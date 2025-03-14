--!strict
--!native
--!optimize 2
--!nolint LocalShadow
--#selene: allow(shadowing)
-- File generated by Blink v0.15.6 (https://github.com/1Axen/Blink)
-- This file is not meant to be edited

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local BASE_EVENT_NAME = "BLINK"
local Invocations = 0

local SendSize = 64
local SendOffset = 0
local SendCursor = 0
local SendBuffer = buffer.create(64)
local SendInstances = {}

local RecieveCursor = 0
local RecieveBuffer = buffer.create(64)

local RecieveInstances = {}
local RecieveInstanceCursor = 0

local Null = newproxy()

type Entry = {
    value: any,
    next: Entry?
}

type Queue = {
    head: Entry?,
    tail: Entry?
}

type BufferSave = {
    Size: number, 
    Cursor: number, 
    Buffer: buffer, 
    Instances: {Instance}
}

local function Read(Bytes: number)
    local Offset = RecieveCursor
    RecieveCursor += Bytes
    return Offset
end

local function Save(): BufferSave
    return {
        Size = SendSize,
        Cursor = SendCursor,
        Buffer = SendBuffer,
        Instances = SendInstances
    }
end

local function Load(Save: BufferSave?)
    if Save then
        SendSize = Save.Size
        SendCursor = Save.Cursor
        SendOffset = Save.Cursor
        SendBuffer = Save.Buffer
        SendInstances = Save.Instances
        return
    end

    SendSize = 64
    SendCursor = 0
    SendOffset = 0
    SendBuffer = buffer.create(64)
    SendInstances = {}
end

local function Invoke()
    if Invocations == 255 then
        Invocations = 0
    end

    local Invocation = Invocations
    Invocations += 1
    return Invocation
end

local function Allocate(Bytes: number)
    local InUse = (SendCursor + Bytes)
    if InUse > SendSize then
        --> Avoid resizing the buffer for every write
        while InUse > SendSize do
            SendSize *= 1.5
        end

        local Buffer = buffer.create(SendSize)
        buffer.copy(Buffer, 0, SendBuffer, 0, SendCursor)
        SendBuffer = Buffer
    end

    SendOffset = SendCursor
    SendCursor += Bytes
    
    return SendOffset
end

local function CreateQueue(): Queue
    return {
        head = nil,
        tail = nil
    }
end

local function Pop(queue: Queue): any
    local head = queue.head
    if head == nil then
        return
    end

    queue.head = head.next
    return head.value
end

local function Push(queue: Queue, value: any)
    local entry: Entry = {
        value = value,
        next = nil
    }

    if queue.tail ~= nil then
        queue.tail.next = entry
    end

    queue.tail = entry

    if queue.head == nil then
        queue.head = entry
    end
end

local Calls = table.create(256)

local Events: any = {
    Reliable = table.create(256),
    Unreliable = table.create(256)
}

local Queue: any = {
    Reliable = table.create(256),
    Unreliable = table.create(256)
}

Queue.Unreliable[0] = table.create(256)
Queue.Unreliable[1] = table.create(256)
Queue.Unreliable[2] = table.create(256)
Queue.Unreliable[3] = table.create(256)
export type PositionOffset = { X: number, Y: number, Z: number }
export type Orientation = { X: number, Y: number, Z: number }
export type VfxData = { plr: number, Vfx: number, Duration: number, Part: number }
export type OrientationData = { plr: number, Vfx: number, Duration: number, Part: number, Orientation: { X: number, Y: number, Z: number } }
export type OrientationAndPositionData = { plr: number, Vfx: number, Duration: number, Part: number, Orientation: { X: number, Y: number, Z: number }, Position: { X: number, Y: number, Z: number } }
export type PositionData = { plr: number, Vfx: number, Duration: number, Part: number, Position: { X: number, Y: number, Z: number } }
local function ReadEVENT_ClientVFX(): ({ plr: number, Vfx: number, Duration: number, Part: number })
	-- Read BLOCK: 6 bytes
	local BLOCK_START = Read(6)
	local Value = {} :: any
	Value.plr = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
	Value.Vfx = buffer.readu16(RecieveBuffer, BLOCK_START + 1)
	local Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 3)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Duration = -math.huge
		else
			Value.Duration = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Duration = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Duration = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Duration = if Encoded // 0x8000 == 1 then -Result else Result
	end
	Value.Part = buffer.readu8(RecieveBuffer, BLOCK_START + 5)
	return Value
end

local function ReadEVENT_ClientVFXRotation(): ({ plr: number, Vfx: number, Duration: number, Part: number, Orientation: { X: number, Y: number, Z: number } })
	-- Read BLOCK: 12 bytes
	local BLOCK_START = Read(12)
	local Value = {} :: any
	Value.plr = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
	Value.Vfx = buffer.readu16(RecieveBuffer, BLOCK_START + 1)
	local Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 3)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Duration = -math.huge
		else
			Value.Duration = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Duration = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Duration = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Duration = if Encoded // 0x8000 == 1 then -Result else Result
	end
	Value.Part = buffer.readu8(RecieveBuffer, BLOCK_START + 5)
	Value.Orientation = {} :: any
	Value.Orientation.X = buffer.readi16(RecieveBuffer, BLOCK_START + 6)
	Value.Orientation.Y = buffer.readi16(RecieveBuffer, BLOCK_START + 8)
	Value.Orientation.Z = buffer.readi16(RecieveBuffer, BLOCK_START + 10)
	return Value
end

local function ReadEVENT_ClientVFXRotationAndPosition(): ({ plr: number, Vfx: number, Duration: number, Part: number, Orientation: { X: number, Y: number, Z: number }, Position: { X: number, Y: number, Z: number } })
	-- Read BLOCK: 18 bytes
	local BLOCK_START = Read(18)
	local Value = {} :: any
	Value.plr = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
	Value.Vfx = buffer.readu16(RecieveBuffer, BLOCK_START + 1)
	local Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 3)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Duration = -math.huge
		else
			Value.Duration = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Duration = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Duration = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Duration = if Encoded // 0x8000 == 1 then -Result else Result
	end
	Value.Part = buffer.readu8(RecieveBuffer, BLOCK_START + 5)
	Value.Orientation = {} :: any
	Value.Orientation.X = buffer.readi16(RecieveBuffer, BLOCK_START + 6)
	Value.Orientation.Y = buffer.readi16(RecieveBuffer, BLOCK_START + 8)
	Value.Orientation.Z = buffer.readi16(RecieveBuffer, BLOCK_START + 10)
	Value.Position = {} :: any
	Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 12)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Position.X = -math.huge
		else
			Value.Position.X = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Position.X = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Position.X = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Position.X = if Encoded // 0x8000 == 1 then -Result else Result
	end
	Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 14)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Position.Y = -math.huge
		else
			Value.Position.Y = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Position.Y = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Position.Y = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Position.Y = if Encoded // 0x8000 == 1 then -Result else Result
	end
	Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 16)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Position.Z = -math.huge
		else
			Value.Position.Z = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Position.Z = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Position.Z = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Position.Z = if Encoded // 0x8000 == 1 then -Result else Result
	end
	return Value
end

local function ReadEVENT_ClientVFXPosition(): ({ plr: number, Vfx: number, Duration: number, Part: number, Position: { X: number, Y: number, Z: number } })
	-- Read BLOCK: 12 bytes
	local BLOCK_START = Read(12)
	local Value = {} :: any
	Value.plr = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
	Value.Vfx = buffer.readu16(RecieveBuffer, BLOCK_START + 1)
	local Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 3)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Duration = -math.huge
		else
			Value.Duration = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Duration = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Duration = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Duration = if Encoded // 0x8000 == 1 then -Result else Result
	end
	Value.Part = buffer.readu8(RecieveBuffer, BLOCK_START + 5)
	Value.Position = {} :: any
	Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 6)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Position.X = -math.huge
		else
			Value.Position.X = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Position.X = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Position.X = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Position.X = if Encoded // 0x8000 == 1 then -Result else Result
	end
	Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 8)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Position.Y = -math.huge
		else
			Value.Position.Y = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Position.Y = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Position.Y = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Position.Y = if Encoded // 0x8000 == 1 then -Result else Result
	end
	Encoded = buffer.readu16(RecieveBuffer, BLOCK_START + 10)
	local MantissaExponent = Encoded % 0x8000
	if MantissaExponent == 0b0_11111_0000000000  then
		if Encoded // 0x8000 == 1 then
			Value.Position.Z = -math.huge
		else
			Value.Position.Z = math.huge
		end
	elseif MantissaExponent == 0b1_11111_0000000000   then
		Value.Position.Z = 0 / 0
	elseif MantissaExponent == 0b0_00000_0000000000   then
		Value.Position.Z = 0
	else
		local Mantissa = MantissaExponent % 0x400
		local Exponent = MantissaExponent // 0x400
		local Fraction;
		if Exponent == 0 then
			Fraction = Mantissa / 0x400
		else
			Fraction = Mantissa / 0x800 + 0.5
		end
		local Result = math.ldexp(Fraction, Exponent - 14)
		Value.Position.Z = if Encoded // 0x8000 == 1 then -Result else Result
	end
	return Value
end

if not RunService:IsRunning() then
	local NOOP = function() end
	local Returns = table.freeze({
	ClientVFX = {
		On = NOOP
	},
	ClientVFXRotation = {
		On = NOOP
	},
	ClientVFXRotationAndPosition = {
		On = NOOP
	},
	ClientVFXPosition = {
		On = NOOP
	},
	})
	return Returns :: BLINK_EVENTS_SYMBOL
end

if not RunService:IsClient() then
    error("Client network module can only be required from the client.")
end

local Reliable: RemoteEvent = ReplicatedStorage:WaitForChild(BASE_EVENT_NAME .. "_RELIABLE_REMOTE") :: RemoteEvent
local Unreliable: UnreliableRemoteEvent = ReplicatedStorage:WaitForChild(BASE_EVENT_NAME .. "_UNRELIABLE_REMOTE") :: UnreliableRemoteEvent

local function StepReplication()
    if SendCursor <= 0 then
        return
    end

    local Buffer = buffer.create(SendCursor)
    buffer.copy(Buffer, 0, SendBuffer, 0, SendCursor)
    Reliable:FireServer(Buffer, SendInstances)

    SendSize = 64
    SendCursor = 0
    SendOffset = 0
    SendBuffer = buffer.create(64)
    table.clear(SendInstances)
end
local Elapsed = 0
RunService.Heartbeat:Connect(function(DeltaTime: number)
	Elapsed += DeltaTime
	if Elapsed >= (1 / 61) then
		Elapsed -= (1 / 61)
		StepReplication()
	end
end)
Reliable.OnClientEvent:Connect(function(Buffer: buffer, Instances: {Instance})
	RecieveCursor = 0
	RecieveBuffer = Buffer
	RecieveInstances = Instances
	RecieveInstanceCursor = 0
	local Size = buffer.len(RecieveBuffer)
	while (RecieveCursor < Size) do
		-- Read BLOCK: 1 bytes
		local BLOCK_START = Read(1)
		local Index = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
	end
end)
Unreliable.OnClientEvent:Connect(function(Buffer: buffer, Instances: {Instance})
	RecieveCursor = 0
	RecieveBuffer = Buffer
	RecieveInstances = Instances
	RecieveInstanceCursor = 0
	local Size = buffer.len(RecieveBuffer)
	while (RecieveCursor < Size) do
		-- Read BLOCK: 1 bytes
		local BLOCK_START = Read(1)
		local Index = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
		if Index == 0 then
			local Value: { plr: number, Vfx: number, Duration: number, Part: number } = ReadEVENT_ClientVFX()
			if Events.Unreliable[0] ~= nil then
				task.spawn(Events.Unreliable[0], Value)
			end
		elseif Index == 1 then
			local Value: { plr: number, Vfx: number, Duration: number, Part: number, Orientation: { X: number, Y: number, Z: number } } = ReadEVENT_ClientVFXRotation()
			if Events.Unreliable[1] ~= nil then
				task.spawn(Events.Unreliable[1], Value)
			end
		elseif Index == 2 then
			local Value: { plr: number, Vfx: number, Duration: number, Part: number, Orientation: { X: number, Y: number, Z: number }, Position: { X: number, Y: number, Z: number } } = ReadEVENT_ClientVFXRotationAndPosition()
			if Events.Unreliable[2] ~= nil then
				task.spawn(Events.Unreliable[2], Value)
			end
		elseif Index == 3 then
			local Value: { plr: number, Vfx: number, Duration: number, Part: number, Position: { X: number, Y: number, Z: number } } = ReadEVENT_ClientVFXPosition()
			if Events.Unreliable[3] ~= nil then
				task.spawn(Events.Unreliable[3], Value)
			end
		end
	end
end)


local Returns = table.freeze({
	StepReplication = StepReplication,

	ClientVFX = {
		On = function(Listener: (Value: { plr: number, Vfx: number, Duration: number, Part: number }) -> ()): () -> ()
			Events.Unreliable[0] = Listener
			return function (): ()
				Events.Unreliable[0] = nil
			end
		end
	},
	ClientVFXRotation = {
		On = function(Listener: (Value: { plr: number, Vfx: number, Duration: number, Part: number, Orientation: { X: number, Y: number, Z: number } }) -> ()): () -> ()
			Events.Unreliable[1] = Listener
			return function (): ()
				Events.Unreliable[1] = nil
			end
		end
	},
	ClientVFXRotationAndPosition = {
		On = function(Listener: (Value: { plr: number, Vfx: number, Duration: number, Part: number, Orientation: { X: number, Y: number, Z: number }, Position: { X: number, Y: number, Z: number } }) -> ()): () -> ()
			Events.Unreliable[2] = Listener
			return function (): ()
				Events.Unreliable[2] = nil
			end
		end
	},
	ClientVFXPosition = {
		On = function(Listener: (Value: { plr: number, Vfx: number, Duration: number, Part: number, Position: { X: number, Y: number, Z: number } }) -> ()): () -> ()
			Events.Unreliable[3] = Listener
			return function (): ()
				Events.Unreliable[3] = nil
			end
		end
	},
})
type BLINK_EVENTS_SYMBOL = typeof(Returns)
return Returns :: BLINK_EVENTS_SYMBOL
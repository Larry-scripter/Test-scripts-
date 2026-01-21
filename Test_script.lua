-- LocalScript (WALK + JUMP)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- CONFIG
local WALK_SPEED = 16
local WALK_ID = "rbxassetid://COLOQUE_O_ID_DO_WALK"
local JUMP_ID = "rbxassetid://COLOQUE_O_ID_DO_JUMP"

local FADE_TIME = 0.25

local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	-- WALK
	local walkAnim = Instance.new("Animation")
	walkAnim.AnimationId = WALK_ID
	local walkTrack = animator:LoadAnimation(walkAnim)
	walkTrack.Priority = Enum.AnimationPriority.Movement
	walkTrack.Looped = true

	-- JUMP
	local jumpAnim = Instance.new("Animation")
	jumpAnim.AnimationId = JUMP_ID
	local jumpTrack = animator:LoadAnimation(jumpAnim)
	jumpTrack.Priority = Enum.AnimationPriority.Action
	jumpTrack.Looped = false

	-- CONTROLE
	RunService.RenderStepped:Connect(function()
		local moving = humanoid.MoveDirection.Magnitude > 0
		local speed = humanoid.WalkSpeed
		local state = humanoid:GetState()

		-- JUMP / FALL
		if state == Enum.HumanoidStateType.Jumping
		or state == Enum.HumanoidStateType.Freefall then
			if walkTrack.IsPlaying then
				walkTrack:Stop(FADE_TIME)
			end
			if not jumpTrack.IsPlaying then
				jumpTrack:Play(FADE_TIME)
			end
			return
		else
			if jumpTrack.IsPlaying then
				jumpTrack:Stop(FADE_TIME)
			end
		end

		-- WALK
		if speed == WALK_SPEED and moving then
			if not walkTrack.IsPlaying then
				walkTrack:Play(FADE_TIME)
			end
		else
			if walkTrack.IsPlaying then
				walkTrack:Stop(FADE_TIME)
			end
		end
	end)
end

if player.Character then
	onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)

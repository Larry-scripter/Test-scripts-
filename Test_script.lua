-- LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- CONFIG
local RUN_SPEED = 24
local ANIMATION_ID = "rbxassetid://127429124578905"

local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")

	-- Criar animação
	local animation = Instance.new("Animation")
	animation.AnimationId = ANIMATION_ID

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	local runAnim = animator:LoadAnimation(animation)
	runAnim.Priority = Enum.AnimationPriority.Movement
	runAnim.Looped = true

	-- Atualiza todo frame (movimento real)
	RunService.RenderStepped:Connect(function()
		if humanoid.WalkSpeed == RUN_SPEED and humanoid.MoveDirection.Magnitude > 0 then
			if not runAnim.IsPlaying then
				runAnim:Play()
			end
		else
			if runAnim.IsPlaying then
				runAnim:Stop()
			end
		end
	end)
end

if player.Character then
	onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

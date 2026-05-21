--// LOW END FPS BOOST HUB FIXED
--// Mobile + PC Supported

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

pcall(function()
	game.CoreGui.LowEndHub:Destroy()
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LowEndHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- MAIN
local main = Instance.new("Frame")
main.Size = UDim2.new(0,340,0,250)
main.Position = UDim2.new(0.35,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

Instance.new("UICorner",main).CornerRadius = UDim.new(0,18)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 2
stroke.Parent = main

-- TOP BAR
local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,45)
top.BackgroundTransparency = 1
top.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "⚡ FPS BOOST HUB"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

-- MINIMIZE BUTTON
local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0,30,0,30)
mini.Position = UDim2.new(1,-40,0,8)
mini.Text = "-"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 22
mini.TextColor3 = Color3.fromRGB(255,255,255)
mini.BackgroundColor3 = Color3.fromRGB(45,45,45)
mini.Parent = top

Instance.new("UICorner",mini).CornerRadius = UDim.new(1,0)

-- DRAG SYSTEM FIXED (PC + MOBILE)

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)

	local delta = input.Position - dragStart

	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

top.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

top.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)

	if input == dragInput and dragging then
		update(input)
	end
end)

-- BUTTON FUNCTION

local function createButton(text,y,callback)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.82,0,0,42)
	btn.Position = UDim2.new(0.09,0,0,y)
	btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.TextSize = 18
	btn.Parent = main

	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,10)

	btn.MouseEnter:Connect(function()

		TweenService:Create(btn,TweenInfo.new(0.15),{
			BackgroundColor3 = Color3.fromRGB(0,200,255)
		}):Play()
	end)

	btn.MouseLeave:Connect(function()

		TweenService:Create(btn,TweenInfo.new(0.15),{
			BackgroundColor3 = Color3.fromRGB(0,170,255)
		}):Play()
	end)

	btn.MouseButton1Click:Connect(callback)
end

-- FPS BOOST

createButton("ENABLE FPS BOOST",60,function()

	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)

	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100000
	Lighting.Brightness = 1

	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Smoke")
		or v:IsA("Fire")
		or v:IsA("Sparkles") then

			v.Enabled = false
		end

		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
		end
	end
end)

-- ANTI LAG

createButton("ANTI LAG",115,function()

	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Explosion")
		or v:IsA("Smoke") then

			pcall(function()
				v:Destroy()
			end)
		end
	end
end)

-- LOW GRAPHICS

createButton("LOW GRAPHICS",170,function()

	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("Texture")
		or v:IsA("Decal") then

			pcall(function()
				v:Destroy()
			end)
		end
	end
end)

-- MINIMIZE

local minimized = false

mini.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		TweenService:Create(main,TweenInfo.new(0.25),{
			Size = UDim2.new(0,340,0,45)
		}):Play()

	else

		TweenService:Create(main,TweenInfo.new(0.25),{
			Size = UDim2.new(0,340,0,250)
		}):Play()
	end
end)

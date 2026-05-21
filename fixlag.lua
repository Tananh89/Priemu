--// LOW END FPS BOOST HUB + ANTI KICK
--// Drag + Anti Lag + Anti Kick + Beautiful UI
--// Roblox LocalScript

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

-- MAIN (Tăng chiều cao từ 250 lên 305 để vừa nút mới)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 305)
main.Position = UDim2.new(0.35,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

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
title.Text = "⚡ LOW END BOOST HUB"
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
mini.TextSize = 24
mini.TextColor3 = Color3.fromRGB(255,255,255)
mini.BackgroundColor3 = Color3.fromRGB(40,40,40)
mini.Parent = top

Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

-- DRAG SYSTEM
local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		
		local delta = input.Position - dragStart
		
		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- BUTTON CREATOR
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
	
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
	
	btn.MouseEnter:Connect(function()
		if btn.BackgroundColor3 ~= Color3.fromRGB(46, 204, 113) then -- Nếu chưa bật AntiKick thì mới hover màu xanh dương sáng
			TweenService:Create(btn,TweenInfo.new(0.15),{
				BackgroundColor3 = Color3.fromRGB(0,200,255)
			}):Play()
		end
	end)
	
	btn.MouseLeave:Connect(function()
		if btn.BackgroundColor3 ~= Color3.fromRGB(46, 204, 113) then
			TweenService:Create(btn,TweenInfo.new(0.15),{
				BackgroundColor3 = Color3.fromRGB(0,170,255)
			}):Play()
		end
	end)
	
	btn.MouseButton1Click:Connect(function()
		callback(btn)
	end)
end

-- FPS BOOST
createButton("ENABLE FPS BOOST", 60, function()

	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	
	Lighting.GlobalShadows = false
	Lighting.Brightness = 1
	Lighting.FogEnd = 100000
	
	for _,v in pairs(workspace:GetDescendants()) do
		
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
		end
		
		if v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 0.8
		end
		
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Smoke")
		or v:IsA("Fire")
		or v:IsA("Sparkles") then
			v.Enabled = false
		end
	end
	
end)

-- ANTI LAG
createButton("ANTI LAG", 115, function()

	for _,v in pairs(workspace:GetDescendants()) do
		
		if v:IsA("ParticleEmitter")
		or v:IsA("Explosion")
		or v:IsA("Trail")
		or v:IsA("Smoke") then
			v:Destroy()
		end
	end
	
end)

-- LOW GRAPHICS
createButton("LOW GRAPHICS MODE", 170, function()

	for _,v in pairs(workspace:GetDescendants()) do
		
		if v:IsA("BasePart") then
			v.Material = Enum.Material.SmoothPlastic
		end
		
		if v:IsA("Texture")
		or v:IsA("Decal") then
			v:Destroy()
		end
	end
	
end)

-- CHỨC NĂNG MỚI: ANTI KICK (Bảo mật nâng cao cho Executor)
local antikickEnabled = false
createButton("ENABLE ANTI-KICK", 225, function(button)
	if antikickEnabled then return end -- Tránh bấm kích hoạt nhiều lần
	antikickEnabled = true
	
	-- Đổi màu nút thành màu xanh lá cây báo hiệu đã bật thành công
	button.Text = "ANTI-KICK ACTIVE"
	button.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
	
	local mt = getrawmetatable(game)
	local oldNamecall = mt.__namecall
	local oldIndex = mt.__index
	
	setreadonly(mt, false)
	
	-- Hook phương thức __namecall (Chặn lệnh player:Kick())
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		local args = {...}
		
		if tostring(method):lower() == "kick" and self == player then
			warn("🛡️ Chặn thành công một yêu cầu Kick từ Server! Lý do: " .. tostring(args[1] or "Không có lý do"))
			return nil -- Trả về rỗng, bẻ gãy lệnh kick
		end
		
		return oldNamecall(self, ...)
	end)
	
	-- Hook phương thức __index (Chặn trường hợp gọi dạng player.Kick(player))
	mt.__index = newcclosure(function(self, key)
		if tostring(key):lower() == "kick" and self == player then
			return newcclosure(function()
				warn("🛡️ Chặn thành công lệnh Kick dạng gán thuộc tính!")
				return nil
			end)
		end
		
		return oldIndex(self, key)
	end)
	
	setreadonly(mt, true)
end)


-- MINIMIZE SYSTEM
local minimized = false

mini.MouseButton1Click:Connect(function()

	minimized = not minimized
	
	if minimized then
		
		TweenService:Create(main,TweenInfo.new(0.25),{
			Size = UDim2.new(0,340,0,45)
		}):Play()
		
	else
		
		TweenService:Create(main,TweenInfo.new(0.25),{
			Size = UDim2.new(0,340,0,305) -- Đồng bộ kích thước mới khi phóng to
		}):Play()
		
	end
end)
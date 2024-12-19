local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Конфигурация
local config = {
    AimbotEnabled = false,
    TeamCheck = false, -- Если включено, аимбот будет нацеливаться только на вражеские команды.
    AimPart = "Head", -- Часть тела, на которую будет нацеливаться аимбот.
    Sensitivity = 0, -- Время, за которое аимбот будет фиксировать цель.
    CircleSides = 64, -- Количество сторон у круга FOV.
    CircleColor = Color3.fromRGB(255, 255, 255), -- Цвет круга FOV.
    CircleTransparency = 1, -- Прозрачность круга FOV.
    CircleRadius = 100, -- Радиус круга FOV.
    CircleFilled = false, -- Заполнять ли круг.
    CircleVisible = false, -- Видимость круга.
    CircleThickness = 2 -- Толщина круга.
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = config.CircleRadius
FOVCircle.Filled = config.CircleFilled
FOVCircle.Color = config.CircleColor
FOVCircle.Visible = config.CircleVisible
FOVCircle.Transparency = config.CircleTransparency
FOVCircle.NumSides = config.CircleSides
FOVCircle.Thickness = config.CircleThickness

local function GetClosestPlayer()
    local MaximumDistance = config.CircleRadius
    local Target = nil

    for _, v in next, Players:GetPlayers() do
        if v.Name ~= LocalPlayer.Name then
            if config.TeamCheck == true then
                if v.Team ~= LocalPlayer.Team then
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                        if v.Character.Humanoid.Health ~= 0 then
                            local ScreenPoint = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                            local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                            
                            if VectorDistance < MaximumDistance then
                                Target = v
                            end
                        end
                    end
                end
            else
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                    if v.Character.Humanoid.Health ~= 0 then
                        local ScreenPoint = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                        local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                        
                        if VectorDistance < MaximumDistance then
                            Target = v
                        end
                    end
                end
            end
        end
    end

    return Target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = config.CircleRadius
    FOVCircle.Filled = config.CircleFilled
    FOVCircle.Color = config.CircleColor
    FOVCircle.Visible = config.CircleVisible
    FOVCircle.Transparency = config.CircleTransparency
    FOVCircle.NumSides = config.CircleSides
    FOVCircle.Thickness = config.CircleThickness

    if config.AimbotEnabled == true then
        local target = GetClosestPlayer()
        if target then
            TweenService:Create(Camera, TweenInfo.new(config.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, target.Character[config.AimPart].Position)}):Play()
        end
    end
end)

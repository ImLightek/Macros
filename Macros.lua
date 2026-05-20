--[[
    Created by Light
    ⚡ ADVANCED MACRO SLOTS
--]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local pgui = CoreGui:FindFirstChild("RobloxGui") or CoreGui

if pgui:FindFirstChild("AdvancedMacroSlotsGui") then
    pgui.AdvancedMacroSlotsGui:Destroy()
end

local slots = {
    [1] = {},
    [2] = {},
    [3] = {}
}
local currentSlot = 1

local isRecording = false
local isPlaying = false
local loopEnabled = false

local fileNames = {
    [1] = "macro_slot_1.txt",
    [2] = "macro_slot_2.txt",
    [3] = "macro_slot_3.txt"
}

local function saveSlotToPC(slotNum)
    local rawData = slots[slotNum]
    local convertedData = {}
    
    for _, cf in ipairs(rawData) do
        table.insert(convertedData, {cf:GetComponents()})
    end
    
    local success, jsonString = pcall(function() return HttpService:JSONEncode(convertedData) end)
    if success and writefile then
        writefile(fileNames[slotNum], jsonString)
    end
end

local function loadSlotsFromPC()
    for i = 1, 3 do
        if readfile and isfile and isfile(fileNames[i]) then
            local jsonString = readfile(fileNames[i])
            local success, decodedData = pcall(function() return HttpService:JSONDecode(jsonString) end)
            
            if success and decodedData then
                slots[i] = {}
                for _, cfComponents in ipairs(decodedData) do
                    table.insert(slots[i], CFrame.new(unpack(cfComponents)))
                end
            end
        end
    end
end

loadSlotsFromPC()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedMacroSlotsGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = pgui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 240)
mainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ MACRO BY LIGHT"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
closeBtn.TextSize = 24
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
closeBtn.Activated:Connect(function() 
    isRecording = false
    isPlaying = false
    screenGui:Destroy() 
end)

local slotFrame = Instance.new("Frame")
slotFrame.Size = UDim2.new(1, -24, 0, 30)
slotFrame.Position = UDim2.new(0, 12, 0, 40)
slotFrame.BackgroundTransparency = 1
slotFrame.Parent = mainFrame

local slotButtons = {}
for i = 1, 3 do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.31, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.34, 0, 0, 0)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 120, 180) or Color3.fromRGB(45, 45, 50)
    btn.Text = "Слот " .. i
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Parent = slotFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    slotButtons[i] = btn
    
    btn.Activated:Connect(function()
        if isRecording or isPlaying then return end
        currentSlot = i
        for idx, b in ipairs(slotButtons) do
            b.BackgroundColor3 = (idx == currentSlot) and Color3.fromRGB(0, 120, 180) or Color3.fromRGB(45, 45, 50)
        end
        infoLabel.Text = "Слот " .. i .. " выбран. Кадров на ПК: " .. #slots[currentSlot]
    end)
end

local recBtn = Instance.new("TextButton")
recBtn.Size = UDim2.new(1, -24, 0, 35)
recBtn.Position = UDim2.new(0, 12, 0, 80)
recBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
recBtn.Text = "● Записать маршрут"
recBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
recBtn.Font = Enum.Font.GothamMedium
recBtn.TextSize = 12
recBtn.Parent = mainFrame
Instance.new("UICorner", recBtn).CornerRadius = UDim.new(0, 4)

local playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.new(1, -24, 0, 35)
playBtn.Position = UDim2.new(0, 12, 0, 125)
playBtn.BackgroundColor3 = Color3.fromRGB(35, 130, 70)
playBtn.Text = "► Воспроизвести макрос"
playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = 13
playBtn.Parent = mainFrame
Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 4)

local loopBtn = Instance.new("TextButton")
loopBtn.Size = UDim2.new(1, -24, 0, 35)
loopBtn.Position = UDim2.new(0, 12, 0, 170)
loopBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
loopBtn.Text = "Автоповтор (Цикл): ВЫКЛ"
loopBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
loopBtn.Font = Enum.Font.GothamMedium
loopBtn.TextSize = 12
loopBtn.Parent = mainFrame
Instance.new("UICorner", loopBtn).CornerRadius = UDim.new(0, 4)

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -24, 0, 20)
infoLabel.Position = UDim2.new(0, 12, 0, 212)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Статус: Загружено файлов слотов: " .. #slots[currentSlot]
infoLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.GothamMedium
infoLabel.Parent = mainFrame

RunService.Heartbeat:Connect(function()
    if isRecording then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            table.insert(slots[currentSlot], root.CFrame)
        end
    end
end)

local function playMacroData()
    local activeRoute = slots[currentSlot]
    if #activeRoute == 0 then 
        infoLabel.Text = "Статус: Слот " .. currentSlot .. " пуст!"
        isPlaying = false
        return 
    end

    isPlaying = true
    playBtn.Text = "🛑 Остановить макрос"
    playBtn.BackgroundColor3 = Color3.fromRGB(180, 80, 20)
    
    repeat
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            infoLabel.Text = "Статус: Слот " .. currentSlot .. " | Бежим..."
            
            for i = 1, #activeRoute do
                if not isPlaying then break end
                root.CFrame = activeRoute[i]
                RunService.Heartbeat:Wait()
            end
        end
        
        if loopEnabled and isPlaying then
            infoLabel.Text = "Статус: Цикл! Возврат на старт..."
            task.wait(1) 
        end
    until not loopEnabled or not isPlaying

    isPlaying = false
    playBtn.Text = "► Воспроизвести макрос"
    playBtn.BackgroundColor3 = Color3.fromRGB(35, 130, 70)
    infoLabel.Text = "Статус: Закончили."
end

recBtn.Activated:Connect(function()
    if isPlaying then return end
    
    if isRecording then
        isRecording = false
        recBtn.Text = "● Записать маршрут"
        recBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
        infoLabel.Text = "Сохраняем файл на ПК..."
        
        saveSlotToPC(currentSlot)
        
        infoLabel.Text = "Статус: Записано и СОХРАНЕНО на ПК! Кадров: " .. #slots[currentSlot]
    else
        slots[currentSlot] = {} 
        isRecording = true
        recBtn.Text = "🛑 ИДЕТ ЗАПИСЬ СЛОТА " .. currentSlot .. "..."
        recBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
        infoLabel.Text = "Статус: Беги по маршруту..."
    end
end)

playBtn.Activated:Connect(function()
    if isRecording then return end
    if isPlaying then
        isPlaying = false
    else
        task.spawn(playMacroData)
    end
end)

loopBtn.Activated:Connect(function()
    if loopEnabled then
        loopEnabled = false
        loopBtn.Text = "Автоповтор (Цикл): ВЫКЛ"
        loopBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        loopBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        loopEnabled = true
        loopBtn.Text = "АВТОПОВТОР (ЦИКЛ): ВКЛ"
        loopBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 0)
        loopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

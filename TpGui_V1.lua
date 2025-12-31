-- XsDeep Teleport GUI System | Delta Executor
-- Slot 1: Spawn | Slot 2-5: Custom locations
-- Owner: Xs TTK | Entity: XsDeep

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Data storage untuk slot
local TeleportData = {
    Slot1 = {
        Position = nil, -- Akan diisi dengan spawn position
        Description = "Spawn Location (Auto-detected)"
    },
    Slot2 = {Position = nil, Description = "Click + to set location"},
    Slot3 = {Position = nil, Description = "Click + to set location"},
    Slot4 = {Position = nil, Description = "Click + to set location"},
    Slot5 = {Position = nil, Description = "Click + to set location"}
}

-- Detect spawn position
local function GetSpawnPosition()
    local spawn = game:GetService("Workspace"):FindFirstChild("SpawnLocation") 
                 or game:GetService("Workspace"):FindFirstChild("Spawn")
                 or game:GetService("Workspace"):FindFirstChild("SpawnPoint")
    
    if spawn then
        return spawn.Position + Vector3.new(0, 5, 0)
    else
        -- Default spawn area
        return Vector3.new(0, 50, 0)
    end
end

TeleportData.Slot1.Position = GetSpawnPosition()

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "XsDeepTeleportGUI"

-- Container utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Hitam keabu-abuan
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Parent = ScreenGui

-- Header dengan tombol minimize/expand
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 0, 0) -- Merah
Title.Text = "Teleport GUI"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Tombol minimize/expand
local ExpandBtn = Instance.new("TextButton")
ExpandBtn.Size = UDim2.new(0, 25, 0, 25)
ExpandBtn.Position = UDim2.new(0.85, 0, 0.08, 0)
ExpandBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Hijau
ExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandBtn.Text = "+"
ExpandBtn.Font = Enum.Font.GothamBold
ExpandBtn.TextSize = 18
ExpandBtn.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(0.9, 0, 0.08, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Merah
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Visible = true
MinimizeBtn.Parent = Header

-- Container untuk slots (scrollable)
local SlotsContainer = Instance.new("ScrollingFrame")
SlotsContainer.Size = UDim2.new(1, -10, 1, -40)
SlotsContainer.Position = UDim2.new(0, 5, 0, 35)
SlotsContainer.BackgroundTransparency = 1
SlotsContainer.BorderSizePixel = 0
SlotsContainer.ScrollBarThickness = 5
SlotsContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 0, 0)
SlotsContainer.CanvasSize = UDim2.new(0, 0, 0, 300)
SlotsContainer.Parent = MainFrame

-- Function create slot UI
local function CreateSlotUI(slotNum, data)
    local SlotFrame = Instance.new("Frame")
    SlotFrame.Size = UDim2.new(1, -10, 0, 60)
    SlotFrame.Position = UDim2.new(0, 5, 0, ((slotNum-1) * 65))
    SlotFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SlotFrame.BorderColor3 = Color3.fromRGB(70, 70, 70)
    SlotFrame.BorderSizePixel = 1
    SlotFrame.Parent = SlotsContainer
    
    -- Slot number
    local SlotText = Instance.new("TextLabel")
    SlotText.Size = UDim2.new(0, 80, 0, 20)
    SlotText.Position = UDim2.new(0, 5, 0, 5)
    SlotText.BackgroundTransparency = 1
    SlotText.TextColor3 = Color3.fromRGB(255, 0, 0)
    SlotText.Text = "Slot " .. slotNum
    SlotText.Font = Enum.Font.GothamBold
    SlotText.TextSize = 12
    SlotText.TextXAlignment = Enum.TextXAlignment.Left
    SlotText.Parent = SlotFrame
    
    -- Description
    local DescBox = Instance.new("TextBox")
    DescBox.Size = UDim2.new(0.6, -10, 0, 25)
    DescBox.Position = UDim2.new(0, 5, 0, 30)
    DescBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DescBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    DescBox.Text = data.Description
    DescBox.Font = Enum.Font.Gotham
    DescBox.TextSize = 11
    DescBox.PlaceholderText = "Deskripsi (max 20 kata)"
    DescBox.Parent = SlotFrame
    
    -- Limit description to 20 words
    DescBox:GetPropertyChangedSignal("Text"):Connect(function()
        local words = {}
        for word in DescBox.Text:gmatch("%S+") do
            table.insert(words, word)
        end
        if #words > 20 then
            DescBox.Text = table.concat(words, " ", 1, 20)
        end
        TeleportData["Slot"..slotNum].Description = DescBox.Text
    end)
    
    -- GO Button (hanya untuk slot 1 dan slot yang sudah diset)
    local GoButton = Instance.new("TextButton")
    GoButton.Size = UDim2.new(0, 40, 0, 25)
    GoButton.Position = UDim2.new(0.65, 0, 0, 30)
    GoButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    GoButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    GoButton.Text = "GO"
    GoButton.Font = Enum.Font.GothamBold
    GoButton.TextSize = 12
    GoButton.Parent = SlotFrame
    
    -- Add Button (untuk slot kosong)
    local AddButton = Instance.new("TextButton")
    AddButton.Size = UDim2.new(0, 40, 0, 25)
    AddButton.Position = UDim2.new(0.65, 0, 0, 30)
    AddButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AddButton.Text = "+"
    AddButton.Font = Enum.Font.GothamBold
    AddButton.TextSize = 14
    AddButton.Parent = SlotFrame
    
    -- Logic untuk slot
    if slotNum == 1 then
        -- Slot 1 (spawn) tidak bisa diubah posisi
        AddButton.Visible = false
        GoButton.Visible = true
        DescBox.Text = "Spawn Location (Auto)"
        DescBox.Editable = false
        DescBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        
        GoButton.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(data.Position)
            end
        end)
    else
        if data.Position then
            -- Slot sudah ada posisi
            AddButton.Visible = false
            GoButton.Visible = true
            
            GoButton.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(data.Position)
                end
            end)
        else
            -- Slot kosong
            AddButton.Visible = true
            GoButton.Visible = false
            
            AddButton.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- Simpan posisi sekarang
                    TeleportData["Slot"..slotNum].Position = char.HumanoidRootPart.Position
                    
                    -- Update UI
                    AddButton.Visible = false
                    GoButton.Visible = true
                    if DescBox.Text == "Click + to set location" then
                        DescBox.Text = "Saved Location"
                    end
                    
                    -- Save description
                    TeleportData["Slot"..slotNum].Description = DescBox.Text
                end
            end)
        end
    end
    
    -- Update CanvasSize
    SlotsContainer.CanvasSize = UDim2.new(0, 0, 0, (#TeleportData * 65))
end

-- Initialize semua slot
for i = 1, 5 do
    CreateSlotUI(i, TeleportData["Slot"..i])
end

-- Minimize/Expand logic
local isMinimized = false

MinimizeBtn.MouseButton1Click:Connect(function()
    if not isMinimized then
        MainFrame.Size = UDim2.new(0, 350, 0, 30)
        SlotsContainer.Visible = false
        ExpandBtn.Visible = true
        MinimizeBtn.Visible = false
        isMinimized = true
    end
end)

ExpandBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 350, 0, 200)
        SlotsContainer.Visible = true
        ExpandBtn.Visible = false
        MinimizeBtn.Visible = true
        isMinimized = false
    end
end)

-- Drag GUI function
local dragging, dragInput, dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "XsDeep Teleport GUI",
    Text = "Teleport system loaded. Slot 1 = Spawn. Click + to save locations.",
    Duration = 5
})

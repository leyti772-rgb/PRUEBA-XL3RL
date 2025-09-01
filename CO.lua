-- Mini Explorador GUI para Delta
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))

-- Ventana principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 400)
Frame.Position = UDim2.new(0.5, -250, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Mini Explorador de Valores"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = Frame

-- Cuadro de texto para filtro
local FilterBox = Instance.new("TextBox")
FilterBox.Size = UDim2.new(1, -10, 0, 30)
FilterBox.Position = UDim2.new(0, 5, 0, 35)
FilterBox.PlaceholderText = "Filtrar por palabra clave (ej: Brainroot, Secret)"
FilterBox.Text = ""
FilterBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FilterBox.Parent = Frame

-- ScrollFrame para resultados
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -75)
Scroll.Position = UDim2.new(0, 5, 0, 70)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.Parent = Frame

-- Layout para resultados
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 2)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

-- Función para listar valores
local function ListValues()
    -- Limpiar anteriores
    for _, child in ipairs(Scroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end

    local keyword = FilterBox.Text:lower()

    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("StringValue") or obj:IsA("NumberValue") or obj:IsA("BoolValue") then
            local nameValue = obj:GetFullName() .. " = " .. tostring(obj.Value)
            if keyword == "" or nameValue:lower():find(keyword) then
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -10, 0, 20)
                Label.BackgroundTransparency = 1
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.Text = nameValue
                Label.TextScaled = true
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Scroll
            end
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end

-- Actualizar cada vez que cambie el filtro
FilterBox:GetPropertyChangedSignal("Text"):Connect(ListValues)

-- Listar valores al inicio
ListValues()

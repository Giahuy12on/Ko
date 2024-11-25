loadstring(game:HttpGet("https://pastefy.app/996bmTX2/raw"))()
do
local getinfo = getinfo or debug.getinfo
local DEBUG = false
local Hooked = {}

local Detected, Kill

setthreadidentity(2)
--LPH_NO_VIRTUALIZE(function()
for i, v in getgc(true) do
    if typeof(v) == "table" then
        local DetectFunc = rawget(v, "Detected")
        local KillFunc = rawget(v, "Kill")
    
        if typeof(DetectFunc) == "function" and not Detected then
            Detected = DetectFunc
            
            local Old; Old = hookfunction(Detected, function(Action, Info, NoCrash)
                if Action ~= "_" then
                    if DEBUG then
                        warn(`Adonis AntiCheat flagged\nMethod: {Action}\nInfo: {Info}`)
                    end
                end
                
                return true
            end)

            table.insert(Hooked, Detected)
        end

        if rawget(v, "Variables") and rawget(v, "Process") and typeof(KillFunc) == "function" and not Kill then
            Kill = KillFunc
            local Old; Old = hookfunction(Kill, function(Info)
                if DEBUG then
                    warn(`Adonis AntiCheat tried to kill (fallback): {Info}`)
                end
            end)

            table.insert(Hooked, Kill)
        end
    end
end

local Old; Old = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local LevelOrFunc, Info = ...

    if Detected and LevelOrFunc == Detected then
        if DEBUG then
            warn(`Adonis Bypassed!`)
        end

        return coroutine.yield(coroutine.running())
    end
    
    return Old(...)
end))
--end)()
-- setthreadidentity(9)
setthreadidentity(7)
end

    --// Services
    local Debris = game:GetService('Debris')
    local EtherealParts = Instance.new('Folder', workspace)
    EtherealParts.Name  = 'EtherealParts'
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CC = Workspace.CurrentCamera
    --// Variables
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace:FindFirstChildWhichIsA("Camera")
    local Hitsounds = {}



    --// PhoboTables Table
    local PhoboTables = {
        Functions = {},
        Folders = {},
        Parts = {},
        Locals = {
            Target = nil,
            IsTargetting = false,
            Resolver = {
                OldTick = os.clock(),
                OldPos = Vector3.new(0, 0, 0),
                ResolvedVelocity = Vector3.new(0, 0, 0)
            },
            AutoSelectTick = tick(),
            AntiAimViewer = {
                MouseRemoteFound = false,
                MouseRemote = nil,
                MouseRemoteArgs = nil,
                MouseRemotePositionIndex = nil
            },

            SavedCFrame = nil,
            NetworkPreviousTick = tick(),
            NetworkShouldSleep = false,
            FFlags = {
      }
            ,OriginalVelocity = {},
            RotationAngle = 0
        },
        Utility = {
            Drawings = {},
            EspCache = {}
        },
        Connections = {
            GunConnections = {}
        },
        AuraIgnoreFolder = Instance.new("Folder", game:GetService("Workspace"))
    }

    --// Xrge Table
    local Settings = {
        Combat = {
            Enabled = false,
            Skibidi = false,
            AimPart = "HumanoidRootPart",
            Silent = false,
            BetaAirshot = false,
            TriggerBot = {
                Enabled = false,
                Delay = 0,
                TargeyOnly = false,
                FOV = {
                    Show = true,
                    Size = 80
                }
            },
            TargetInfo = false,
            Camera = false,
            EasingStyle = "Sine",
            EasingDirection = "Out",
            Alerts = true,
            LookAt = false,
            Spectate = false,
            PingBased = false,
            UseIndex = false,
            AntiAimViewer = false,
            AutoSelect = {
                Enabled = false,
                Cooldown = {
                    Enabled = false,
                    Amount = 0.5
                }
            },
            Checks = {
                Enabled = false,
                Knocked = false,
                Crew = false,
                Wall = false,
                Grabbed = false,
                Vehicle = false
            },
            Smoothing = {
                Horizontal = 1,
                Vertical = 1
            },
            Prediction = {
                Horizontal = 0.134,
                Vertical = 0.134
            },
            Resolver = {
                Enabled = false,
                Smoothness = 0.5
            },
            Fov = {
                Visualize = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1)
                },
                Radius = 80
            },
            Visuals = {
                Enabled = true,
                Tracer = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1),
                    Thickness = 2
                },
                Dot = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1),
                    Filled = true,
                    Size = 6
                },
                Chams = {
                    Enabled = false,
                    Fill = {
                        Color = Color3.fromRGB(255,209,220),
                        Transparency = 0.5
                    },
                    Outline = {
                        Color = Color3.new(255,255,255),
                        Transparency = 0
                    }
                }
            },
            Air = {
                Enabled = true,
                AirAimPart = {
                    Enabled = false,
                    HitPart = "LowerTorso"
                },
                JumpOffset = {
                    Enabled = false,
                    Offset = 0
                }
            }
        },
        Visuals = {
            Backtrack = {
                Enabled = true,
                Color = Color3.fromRGB(255,255,255),
                Method = "Folllow",
                Transparency = 0.5,
                Material = "Plastic",
            },
            BulletTracers = {
                Enabled = false,
                Color = {
                    Gradient1 = Color3.new(1, 1, 1),
                    Gradient2 = Color3.new(0, 0, 0)
                },
                Duration = 1,
                Fade = {
                    Enabled = false,
                    Duration = 0.5
                }
            },
            BulletImpacts = {
                Enabled = false,
                Color = Color3.new(1, 1, 1),
                Duration = 1,
                Size = 1,
                Material = "SmoothPlastic",
                Fade = {
                    Enabled = false,
                    Duration = 0.5
                }
            },
            OnHit = {
                Enabled = false,
                Effect = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1)
                },
                Sound = {
                    Enabled = false,
                    Volume = 5,
                    Value = "hentai4.wav"
                },
                Chams = {
                    Enabled = false,
                    Color = Color3.fromRGB(255,209,220),
                    Material = "ForceField",
                    Duration = 1
                }
            },
            World = {
                Enabled = false,
                Fog = {
                    Enabled = false,
                    Color = Color3.fromRGB(255,209,220),
                    End = 1000,
                    Start = 10000
                },
                Ambient = {
                    Enabled = false,
                    Color = Color3.fromRGB(255,209,220)
                },
                Brightness = {
                    Enabled = false,
                    Value = 0
                },
                ClockTime = {
                    Enabled = false,
                    Value = 24
                },
                WorldExposure = {
                    Enabled = false,
                    Value = -0.1
                }
            },
            Crosshair = {
                Enabled = false,
                StickToTarget = false,
                Color = Color3.new(1, 1, 1),
                Size = 10,
                Gap = 2,
                Rotation = {
                    Enabled = false,
                    Speed = 1
                }
            }
        },
        AntiAim = {
            XHAHAHAHA = false,
            XHAHAHAHA2 = false,
            XHAHAHAHA3 = false,
            VelocitySpoofer = {
                Enabled = false,
                Visualize = {
                    Enabled = false,
                    Color = Color3.fromRGB(255,209,220),
                    Prediction = 0.134
                },
                Type = "Underground",
                Roll = 0,
                Pitch = 0,
                Yaw = 0
            },
            CSync = {
                Enabled = false,
                Spoof = false,
                Type = "Target Strafe",
                Visualize = {
                    Enabled = false,
                    Color = Color3.fromRGB(255,209,220)
                },
                RandomDistance = 10,
                Custom = {
                    X = 0,
                    Y = 0,
                    Z = 0
                },
                TargetStrafe = {
                    Speed = 1,
                    Distance = 1,
                    Height = 1
                }
            },
            Network = {
                Enabled = false,
                WalkingCheck = false,
                Amount = 0.05
            },
            VelocityDesync = {
                Enabled = false,
                Range = 1
            },
            FFlagDesync = {
                Enabled = false,
                SetNew = false,
                FFlags = {"S2PhysicsSenderRate"}, 
                SetNewAmount = 1,
                Amount = 1
            },
        },
        Misc = {
            Movement = {
                Macro = {
                    Enabled = false,
                    Speed = 0.1,
                },
                Speed = {
                    Enabled = false,
                    Amount = 1
                },
            },
            Exploits = {
                Enabled = false,
                NoRecoil = false,
                NoJumpCooldown = false,
                NoSlowDown = false
            }
        }
    }


local NEINIGGANEINEI
local WOAHHH
do
local TriggerBotTarget
local TriggerBotFovCircle = Drawing.new("Circle")
TriggerBotFovCircle.Color = Color3.fromRGB(0,245,0)
TriggerBotFovCircle.Visible = Settings.Combat.TriggerBot.FOV.Show and Settings.Combat.TriggerBot.Enabled
TriggerBotFovCircle.Filled = false
TriggerBotFovCircle.Radius = Settings.Combat.TriggerBot.FOV.Size*3
TriggerBotFovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

function UpdateFOVCuh()
TriggerBotFovCircle.Color = Color3.fromRGB(100,0,0)
TriggerBotFovCircle.Visible = Settings.Combat.TriggerBot.FOV.Show and Settings.Combat.TriggerBot.Enabled
TriggerBotFovCircle.Filled = false
TriggerBotFovCircle.Radius = Settings.Combat.TriggerBot.FOV.Size*3
TriggerBotFovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
end
local IgnoreList = {LocalPlayer.Character, Camera}
local function PartTrigguhVisible(Part)
    if Part and Part.Head then
        local Hit = workspace:FindPartOnRayWithIgnoreList(
            Ray.new(Camera.CFrame.Position, Part.Head.Position - Camera.CFrame.Position), IgnoreList)
        if Hit and Hit:IsDescendantOf(Part) then
            return true
        end
        return false
    else
        return true
    end
end
local function LocateTheseNiggas()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local closestPlayer
    local closestDistance = math.huge
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not Settings.Combat.TriggerBot.TargetOnly or player == PhoboTables.Locals.Target and PhoboTables.Locals.IsTargetting then
            local part = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local distanceToCenter = (TriggerBotFovCircle.Position - Vector2.new(screenPos.X, screenPos.Y)).Magnitude

                if PartTrigguhVisible(player.Character) and distanceToCenter < closestDistance and distanceToCenter <= TriggerBotFovCircle.Radius then
                    closestPlayer = player
                    closestDistance = distanceToCenter
                end
            end
        end
        end
    end
    return closestPlayer
end

game:GetService("RunService").RenderStepped:Connect(function()
    TriggerBotTarget = LocateTheseNiggas()
    UpdateFOVCuh()
    if Settings.Combat.TriggerBot.Enabled then
    if TriggerBotTarget and LocalPlayer.Character:FindFirstChildWhichIsA("Tool") ~= nil then
    task.wait(Settings.Combat.TriggerBot.Delay)
    LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
    end
    end
end)
end

    --// Functions
    do
        --// Utility Functions
        do
            PhoboTables.Functions.WorldToScreen = function(Position: Vector3)
                if not Position then return end

                local ViewportPointPosition, OnScreen = Camera:WorldToViewportPoint(Position)
                local ScreenPosition = Vector2.new(ViewportPointPosition.X, ViewportPointPosition.Y)
                return {
                    Position = ScreenPosition,
                    OnScreen = OnScreen
                }
            end

            PhoboTables.Functions.Connection = function(ConnectionType: any, Function: any)
                local Connection = ConnectionType:Connect(Function)
                return Connection
            end

            PhoboTables.Functions.MoveMouse = function(Position: Vector2, SmoothingX: number, SmoothingY: number)
                local MousePosition = UserInputService:GetMouseLocation()

                mousemoverel((Position.X - MousePosition.X) / SmoothingX, (Position.Y - MousePosition.Y) / SmoothingY)
            end

            PhoboTables.Functions.CreateDrawing = function(DrawingType: string, Properties: any)
                local DrawingObject = Drawing.new(DrawingType)

                for Property, Value in pairs(Properties) do
                    DrawingObject[Property] = Value
                end
                return DrawingObject
            end



            PhoboTables.Functions.GetClosestPlayerDamage = function(Position: Vector3, MaxRadius: number)
                local Radius = MaxRadius
                local ClosestPlayer

                for PlayerName, Health in pairs(PhoboTables.Locals.PlayerHealth) do
                    local Player = Players:FindFirstChild(PlayerName)
                    if Player and Player.Character then
                        local PlayerPosition = Player.Character.PrimaryPart.Position
                        local Distance = (Position - PlayerPosition).Magnitude
                        local CurrentHealth = Player.Character.Humanoid.Health
                        if (Distance < Radius) and (CurrentHealth < Health) then
                            Radius = Distance
                            ClosestPlayer = Player
                        end
                    end
                end
                return ClosestPlayer
            end

            PhoboTables.Functions.Rotate = function(Vector, Origin, Angle)
                local CosA = math.cos(Angle)
                local SinA = math.sin(Angle)
                local X = Vector.X - Origin.X
                local Y = Vector.Y - Origin.Y
                local NewX = X * CosA - Y * SinA
                local NewY = X * SinA + Y * CosA
                return Vector2.new(NewX + Origin.x, NewY + Origin.y)
            end
        end
        --// General Functions
        do
            PhoboTables.Functions.GetClosestPlayerNumbah = function()
                local Radius = Settings.Combat.AutoSelect.Enabled and Settings.Combat.Fov.Radius or math.huge
                local ClosestPlayer
                local Mouse = UserInputService:GetMouseLocation()

                for _, Player in pairs(Players:GetPlayers()) do
                    if Player ~= LocalPlayer then
                        --// Variables
                        local ScreenPosition = PhoboTables.Functions.WorldToScreen(Player.Character.HumanoidRootPart.Position)
                        local Distance = ((workspace.CurrentCamera.ViewportSize * 0.5) - ScreenPosition.Position).Magnitude

                        --// OnScreen Check
                        if not ScreenPosition.OnScreen then continue end

                        --// Checks
                        if (Settings.Combat.Checks.Enabled and (Settings.Combat.Checks.Vehicle and Player.Character:FindFirstChild("[CarHitBox]")) or (Settings.Combat.Checks.Knocked and Player.Character.BodyEffects["K.O"].Value == true) or (Settings.Combat.Checks.Grabbed and Player.Character:FindFirstChild("GRABBING_CONSTRAINT")) or (Settings.Combat.Checks.Crew and Player.DataFolder.Information.Crew.Value == LocalPlayer.DataFolder.Information.Crew.Value) or (Settings.Combat.Checks.Wall and PhoboTables.Functions.WallCheck(Player.Character.PrimaryPart))) then continue end

                        if (Distance <= Radius) then
                            Radius = Distance
                            ClosestPlayer = Player
                        end
                    end
                end

                return ClosestPlayer
            end
            PhoboTables.Functions.GetClosestPlayer = function()
                local Radius = Settings.Combat.AutoSelect.Enabled and Settings.Combat.Fov.Radius or math.huge
                local ClosestPlayer
                local Mouse = UserInputService:GetMouseLocation()

                for _, Player in pairs(Players:GetPlayers()) do
                    if Player ~= LocalPlayer then
                        --// Variables
                        local ScreenPosition = PhoboTables.Functions.WorldToScreen(Player.Character.HumanoidRootPart.Position)
                        local Distance = (Mouse - ScreenPosition.Position).Magnitude

                        --// OnScreen Check
                        if not ScreenPosition.OnScreen then continue end

                        --// Checks
                        if (Settings.Combat.Checks.Enabled and (Settings.Combat.Checks.Vehicle and Player.Character:FindFirstChild("[CarHitBox]")) or (Settings.Combat.Checks.Knocked and Player.Character.BodyEffects["K.O"].Value == true) or (Settings.Combat.Checks.Grabbed and Player.Character:FindFirstChild("GRABBING_CONSTRAINT")) or (Settings.Combat.Checks.Crew and Player.DataFolder.Information.Crew.Value == LocalPlayer.DataFolder.Information.Crew.Value) or (Settings.Combat.Checks.Wall and PhoboTables.Functions.WallCheck(Player.Character.PrimaryPart))) then continue end

                        if (Distance < Radius) then
                            Radius = Distance
                            ClosestPlayer = Player
                        end
                    end
                end

                return ClosestPlayer
            end

            PhoboTables.Functions.GetTargetPredictedPosition = function()
                local BodyPart = PhoboTables.Locals.Target.Character[Settings.Combat.AimPart]
                local Velocity = Settings.Combat.Resolver.Enabled and Vector3.new(PhoboTables.Locals.Resolver.ResolvedVelocity.X*Settings.Combat.Prediction.Horizontal, math.clamp(PhoboTables.Locals.Resolver.ResolvedVelocity.Y,-10,50)*Settings.Combat.Prediction.Vertical,PhoboTables.Locals.Resolver.ResolvedVelocity.Z*ZPred) or Vector3.new(PhoboTables.Locals.Target.Character.HumanoidRootPart.AssemblyLinearVelocity.X*Settings.Combat.Prediction.Horizontal,math.clamp(PhoboTables.Locals.Target.Character.HumanoidRootPart.AssemblyLinearVelocity.Y,-10,50)*Settings.Combat.Prediction.Vertical,PhoboTables.Locals.Target.Character.HumanoidRootPart.AssemblyLinearVelocity.Z*ZPred)
                local Position = BodyPart.CFrame + Velocity

                if Settings.Combat.Air.Enabled and Settings.Combat.Air.JumpOffset.Enabled then
                    Position = Position + Vector3.new(0, PhoboTables.Locals.JumpOffset, 0)
                end
                return Position
            end

            PhoboTables.Functions.Resolve = function()
                if Settings.Combat.Enabled and Settings.Combat.Resolver.Enabled and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target then
                    local function lerp(a, b, t)
                        return a + (b - a) * t
                    end

                    PhoboTables.Locals.Resolver.OldPos = PhoboTables.Locals.Resolver.OldPos
                    PhoboTables.Locals.Resolver.OldTick = PhoboTables.Locals.Resolver.OldTick or os.clock()

                    local CurrentTime = os.clock()
                    task.wait(0.055)
                    local CurrentPosition = PhoboTables.Locals.Target.Character.HumanoidRootPart.Position
                    local NewTime = os.clock()

                    local TimeDifference = NewTime - PhoboTables.Locals.Resolver.OldTick
                    if TimeDifference == 0 then return end

                    local RawVelocity = (CurrentPosition - PhoboTables.Locals.Resolver.OldPos) / TimeDifference

                    PhoboTables.Locals.Resolver.ResolvedVelocity = PhoboTables.Locals.Resolver.ResolvedVelocity or RawVelocity
                    PhoboTables.Locals.Resolver.ResolvedVelocity = lerp(PhoboTables.Locals.Resolver.ResolvedVelocity, RawVelocity, Settings.Combat.Resolver.Smoothness)
                    PhoboTables.Locals.Resolver.OldPos = CurrentPosition
                    PhoboTables.Locals.Resolver.OldTick = NewTime
                end
            end

            PhoboTables.Functions.MouseAim = function()
                if Settings.Combat.Enabled and Settings.Combat.Camera and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target then
                    local LalaPosition = (PhoboTables.Functions.GetTargetPredictedPosition().Position)
                    Smoothness = tonumber(Settings.Combat.Smoothing.Horizontal)
                    LookPosition = CFrame.new(CC.CFrame.p, LalaPosition)
                    CC.CFrame = CC.CFrame:Lerp(LookPosition, Smoothness, Enum.EasingStyle[Settings.Combat.EasingStyle], Enum.EasingDirection[Settings.Combat.EasingDirection])
                end
            end




            PhoboTables.Functions.UpdateTargetVisuals = function()
                --// ScreenPosition, Will be changed later
                local Position

                --// Variable to indicate if you"re targetting or not with a check if the target visuals are enabled
                local IsTargetting = Settings.Combat.Enabled and Settings.Combat.Visuals.Enabled and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target or false

                --// Change the position
                if IsTargetting then
                    local PredictedPosition = (PhoboTables.Functions.GetTargetPredictedPosition().Position)
                    Position = PhoboTables.Functions.WorldToScreen(PredictedPosition)
                end

                --// Variable to indicate if the drawing elements should show
                local TracerShow = IsTargetting and Settings.Combat.Visuals.Tracer.Enabled and Position.OnScreen or false
                local DotShow = IsTargetting and crosshair.sticky or false
                local ChamsShow = IsTargetting and Settings.Combat.Visuals.Chams.Enabled and PhoboTables.Locals.Target and PhoboTables.Locals.Target.Character or nil


                --// Set the drawing elements visibility
                PhoboTables.Utility.Drawings["TargetTracer"].Visible = TracerShow
                PhoboTables.Utility.Drawings["TargetDot"].Visible = DotShow
                PhoboTables.Utility.Drawings["TargetChams"].Parent = ChamsShow


                --// Update the drawing elements
                if TracerShow then
                    PhoboTables.Utility.Drawings["TargetTracer"].From = UserInputService:GetMouseLocation()
                    PhoboTables.Utility.Drawings["TargetTracer"].To = Position.Position
                    PhoboTables.Utility.Drawings["TargetTracer"].Color = Settings.Combat.Visuals.Tracer.Color
                    PhoboTables.Utility.Drawings["TargetTracer"].Thickness = Settings.Combat.Visuals.Tracer.Thickness
                end

                if DotShow then
                    crosshair.mode = 'custom'
                    crosshair.position = Position.Position
                else
                    crosshair.mode = "Middle"
                end

                if ChamsShow then
                    PhoboTables.Utility.Drawings["TargetChams"].FillColor = Settings.Combat.Visuals.Chams.Fill.Color
                    PhoboTables.Utility.Drawings["TargetChams"].FillTransparency = Settings.Combat.Visuals.Chams.Fill.Transparency
                    PhoboTables.Utility.Drawings["TargetChams"].OutlineTransparency = Settings.Combat.Visuals.Chams.Outline.Transparency
                    PhoboTables.Utility.Drawings["TargetChams"].OutlineColor = Settings.Combat.Visuals.Chams.Outline.Color
                end
            end

            PhoboTables.Functions.AutoSelect = function()
                if (Settings.Combat.Enabled and Settings.Combat.AutoSelect.Enabled) and (tick() - PhoboTables.Locals.AutoSelectTick >= Settings.Combat.AutoSelect.Cooldown.Amount and Settings.Combat.AutoSelect.Cooldown.Enabled or true) then
                    local NewTarget = PhoboTables.Functions.GetClosestPlayerNumbah()
                    PhoboTables.Locals.Target = NewTarget or nil
                    PhoboTables.Locals.IsTargetting =  NewTarget and true or false
                    PhoboTables.Locals.AutoSelectTick = tick()
                end
            end

            PhoboTables.Functions.GunEvents = function()
                local CurrentGun = PhoboTables.Functions.GetGun(LocalPlayer)
                if CurrentGun and CurrentGun.IsGunEquipped and CurrentGun.Tool then
                    if CurrentGun.Tool ~= PhoboTables.Locals.Gun.PreviousGun then
                        PhoboTables.Locals.Gun.PreviousGun = CurrentGun.Tool
                        PhoboTables.Locals.Gun.PreviousAmmo = 999
                        --// Connections
                        for _, Connection in pairs(PhoboTables.Connections.GunConnections) do
                            Connection:Disconnect()
                        end
                        PhoboTables.Connections.GunConnections = {}
                    end

                    if not PhoboTables.Connections.GunConnections["GunActivated"] and Settings.Combat.Enabled and Settings.Combat.Silent and PhoboTables.Locals.AntiAimViewer.MouseRemoteFound then
                        PhoboTables.Connections.GunConnections["GunActivated"] = PhoboTables.Functions.Connection(CurrentGun.Tool.Activated, function()
                            if PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target then
                                if Settings.Combat.AntiAimViewer then
                                    local Arguments = PhoboTables.Locals.AntiAimViewer.MouseRemoteArgs

                                    Arguments[PhoboTables.Locals.AntiAimViewer.MouseRemotePositionIndex] = (PhoboTables.Functions.GetTargetPredictedPosition().Position)
                                    PhoboTables.Locals.AntiAimViewer.MouseRemote:FireServer(unpack(Arguments))
                                end
                            end
                        end)
                    end
                end
            end

            PhoboTables.Functions.HitShit = function()
            if WOAHHH and NEINIGGANEINEI then
                local NIGGAAA = WOAHHH
                if Settings.Visuals.OnHit.Enabled then
                    local GRAHGRAHGRAHKEEPITASTACK = PhoboTables.Functions.GetClosestPlayerDamage(NIGGAAA[NEINIGGANEINEI], 20)
                    if GRAHGRAHGRAHKEEPITASTACK then
                        if Settings.Visuals.OnHit.Sound.Enabled then
                            local Sound = string.format("hitsounds_stuff/%s", Settings.Visuals.OnHit.Sound.Value)
                            PhoboTables.Functions.PlaySound(getcustomasset(Sound), Settings.Visuals.OnHit.Sound.Volume)
                        end
                        
                        if Settings.Visuals.OnHit.Effect.Enabled then
                            PhoboTables.Functions.Effect(GRAHGRAHGRAHKEEPITASTACK.Character.HumanoidRootPart)
                        end
                        if Settings.Visuals.OnHit.Chams.Enabled then
                            PhoboTables.Functions.Hitcham(GRAHGRAHGRAHKEEPITASTACK, Settings.Visuals.OnHit.Chams.Color)
                        end
                    end
                end
              end
           end

            PhoboTables.Functions.Air = function()
                if Settings.Combat.Enabled and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target and Settings.Combat.Air.Enabled then
                    local Humanoid = PhoboTables.Locals.Target.Character.Humanoid

                    if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                        if Settings.Combat.BetaAirshot then
                        ZPred = 0
                    end
                        PhoboTables.Locals.JumpOffset = Settings.Combat.Air.JumpOffset.Offset
                    else
                        ZPred = Settings.Combat.Prediction.Horizontal
                        PhoboTables.Locals.JumpOffset = 0
                    end
                end
            end

            PhoboTables.Functions.VisualizeMovement = function()
                if Settings.Combat.Skibidi then
                  local Character = LocalPlayer and (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
                  local RootPart = Character and Character.HumanoidRootPart
                  local Ball = Instance.new('Part') do
                      Ball.Anchored = true
                      Ball.Size = Vector3.new(0.5, 0.5, 0.5)
                      Ball.Transparency = -0.5
                      Ball.Shape = Enum.PartType.Ball
                      Ball.Color = Color3.fromRGB(255,209,220)
                      Ball.Material = Enum.Material.ForceField
                      Ball.Parent = Workspace
                      Ball.CFrame = RootPart.CFrame
                      Ball.CanCollide = false
                      local highlight = Instance.new("Highlight")
                      highlight.Adornee = Ball
                      highlight.FillColor = Color3.fromRGB(255,209,220)
                      highlight.OutlineColor = Color3.fromRGB(255,255,255)
                      highlight.Parent = Ball
                  end;
                  Debris:AddItem(Ball, 2)
                end
            end

            PhoboTables.Functions.UpdateHealth = function()
                if Settings.Visuals.OnHit.Enabled then
                    for _, Player in pairs(Players:GetPlayers()) do
                        if Player.Character and Player.Character.Humanoid then
                            PhoboTables.Locals.PlayerHealth[Player.Name] = Player.Character.Humanoid.Health
                        end
                    end
                end
            end



            PhoboTables.Functions.VelocitySpoof = function()
                local ShowVisualizerDot = Settings.AntiAim.VelocitySpoofer.Enabled and Settings.AntiAim.VelocitySpoofer.Visualize.Enabled

                PhoboTables.Utility.Drawings["VelocityDot"].Visible = ShowVisualizerDot


                if Settings.AntiAim.VelocitySpoofer.Enabled then
                    --// Variables
                    local Type = Settings.AntiAim.VelocitySpoofer.Type
                    local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                    local Velocity = HumanoidRootPart.Velocity

                    --// Main
                    if Type == "Underground" then
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, -Settings.AntiAim.VelocitySpoofer.Yaw, 0)
                    elseif Type == "Sky" then
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, Settings.AntiAim.VelocitySpoofer.Yaw, 0)
                    elseif Type == "Multiplier" then
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(Settings.AntiAim.VelocitySpoofer.Yaw, Settings.AntiAim.VelocitySpoofer.Pitch, Settings.AntiAim.VelocitySpoofer.Roll)
                    elseif Type == "Custom" then
                        HumanoidRootPart.Velocity = Vector3.new(Settings.AntiAim.VelocitySpoofer.Yaw, Settings.AntiAim.VelocitySpoofer.Pitch, Settings.AntiAim.VelocitySpoofer.Roll)
                    elseif Type == "Prediction Breaker" then
                        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end

                    if ShowVisualizerDot then
                        local ScreenPosition = PhoboTables.Functions.WorldToScreen(LocalPlayer.Character.HumanoidRootPart.Position + LocalPlayer.Character.HumanoidRootPart.Velocity * Settings.AntiAim.VelocitySpoofer.Visualize.Prediction)

                        PhoboTables.Utility.Drawings["VelocityDot"].Position = ScreenPosition.Position
                        PhoboTables.Utility.Drawings["VelocityDot"].Color = Settings.AntiAim.VelocitySpoofer.Visualize.Color
                    end

                    RunService.RenderStepped:Wait()
                    HumanoidRootPart.Velocity = Velocity
                end
            end

            PhoboTables.Functions.CSync = function()
                PhoboTables.Utility.Drawings["CFrameVisualize"].Parent = Settings.AntiAim.CSync.Visualize.Enabled and Settings.AntiAim.CSync.Enabled and PhoboTables.AuraIgnoreFolder or nil

                if Settings.AntiAim.CSync.Enabled then
                    local Type = Settings.AntiAim.CSync.Type
                    local FakeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    PhoboTables.Locals.SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    if Type == "Target Strafe" and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target and Settings.Combat.Enabled then
                        local CurrentTime = tick()
                        FakeCFrame = CFrame.new(PhoboTables.Locals.Target.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * CurrentTime * Settings.AntiAim.CSync.TargetStrafe.Speed % (2 * math.pi), 0) * CFrame.new(0, Settings.AntiAim.CSync.TargetStrafe.Height, Settings.AntiAim.CSync.TargetStrafe.Distance)
                    elseif Type == "Random Target" and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target and Settings.Combat.Enabled then
                        FakeCFrame = CFrame.new(PhoboTables.Locals.Target.Character.HumanoidRootPart.Position + Vector3.new(math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-0, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance))) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
                    end

                    PhoboTables.Utility.Drawings["CFrameVisualize"]:SetPrimaryPartCFrame(FakeCFrame)

                    for _, Part in pairs(PhoboTables.Utility.Drawings["CFrameVisualize"]:GetChildren()) do
                        Part.Color = Settings.AntiAim.CSync.Visualize.Color
                    end
                    LocalPlayer.Character.HumanoidRootPart.CFrame = FakeCFrame
                    RunService.RenderStepped:Wait()
                    if Settings.AntiAim.CSync.Spoof  then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = PhoboTables.Locals.SavedCFrame
                    end
                end
            end


            PhoboTables.Functions.UpdateLookAt = function()
                if Settings.Combat.Enabled and Settings.Combat.Silent and Settings.Combat.LookAt and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target and LocalPlayer then
                    LocalPlayer.Character.Humanoid.AutoRotate = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position, Vector3.new(PhoboTables.Locals.Target.Character.HumanoidRootPart.CFrame.X, LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Y, PhoboTables.Locals.Target.Character.HumanoidRootPart.CFrame.Z))
                else
                    LocalPlayer.Character.Humanoid.AutoRotate = true
                end
            end

            PhoboTables.Functions.UpdateSpectate = function()
                if Settings.Combat.Enabled and Settings.Combat.Silent and Settings.Combat.Spectate and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target then
                    Camera.CameraSubject = PhoboTables.Locals.Target.Character.Humanoid
                else
                    Camera.CameraSubject = LocalPlayer.Character.Humanoid
                end
            end
        end

        --// Esp Function
        do

        end
    end


    do
        --// Combat Connections
        do
            PhoboTables.Functions.Connection(RunService.Heartbeat, function()
                PhoboTables.Functions.MouseAim()

                PhoboTables.Functions.Resolve()

                PhoboTables.Functions.Air()

                PhoboTables.Functions.UpdateLookAt()
            end)

            PhoboTables.Functions.Connection(RunService.RenderStepped, function()
                PhoboTables.Functions.UpdateFieldOfView()

                PhoboTables.Functions.DotThingYes()

                PhoboTables.Functions.UpdateTargetVisuals()

                PhoboTables.Functions.AutoSelect()

                PhoboTables.Functions.UpdateSpectate()
            end)
        end

        --// Visual Connections
        do
            PhoboTables.Functions.Connection(RunService.RenderStepped, function()
                PhoboTables.Functions.HitShit()

                PhoboTables.Functions.GunEvents()

                PhoboTables.Functions.UpdateAtmosphere()

                PhoboTables.Functions.UpdateHealth()
            end)
        end

        --// Anti Aim Connection
        do
            PhoboTables.Functions.Connection(RunService.Heartbeat, function()
                PhoboTables.Functions.XHAHAHAHA()
                
                PhoboTables.Functions.VisualizeMovement()
                
                PhoboTables.Functions.CSync()

                PhoboTables.Functions.Network()

                PhoboTables.Functions.VelocityDesync()

                PhoboTables.Functions.FFlagDesync()
            end)
        end

        --// Movement Connections
        do
            PhoboTables.Functions.Connection(RunService.Heartbeat, function()
                PhoboTables.Functions.Speed()

                PhoboTables.Functions.NoSlowdown()
            end)
        end
    end
RunService.Stepped:connect(function()
if Settings.Combat.PingBased then
    pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
split = string.split(pingvalue,'(')
ping = tonumber(split[1])
    Settings.Combat.Prediction.Vertical = tonumber(ping/1500)
    if ping <200 then
        Settings.Combat.Prediction.Horizontal = 0.2198343243234332
    elseif ping < 170 then
        Settings.Combat.Prediction.Horizontal = 0.2165713
    elseif ping < 160 then
        Settings.Combat.Prediction.Horizontal = 0.16242
    elseif ping < 150 then
        Settings.Combat.Prediction.Horizontal = 0.158041
    elseif ping < 140 then
        Settings.Combat.Prediction.Horizontal = 0.155313
    elseif ping < 130 then
        Settings.Combat.Prediction.Horizontal = 0.152692
    elseif ping < 120 then
        Settings.Combat.Prediction.Horizontal = 0.153017
    elseif ping < 110 then
        Settings.Combat.Prediction.Horizontal = 0.15165
    elseif ping < 100 then
        Settings.Combat.Prediction.Horizontal = 0.1483987
    elseif ping < 80 then
        Settings.Combat.Prediction.Horizontal = 0.1451340
    elseif ping < 70 then
        Settings.Combat.Prediction.Horizontal = 0.143633
    elseif ping < 65 then
        Settings.Combat.Prediction.Horizontal = 0.1374236
    elseif ping < 50 then
        Settings.Combat.Prediction.Horizontal = 0.13644
    elseif ping < 30 then
        Settings.Combat.Prediction.Horizontal = 0.12452476
    end
end
end)







    --// Hooks
    do
        local __namecall
        local __newindex
        local __index

        __index = hookmetamethod(game, "__index", newcclosure(function(Self, Index)
            if not checkcaller() and Settings.AntiAim.CSync.Enabled and Settings.AntiAim.CSync.Spoof and PhoboTables.Locals.SavedCFrame and Index == "CFrame" and Self == LocalPlayer.Character.HumanoidRootPart then
                return PhoboTables.Locals.SavedCFrame
            end
            return __index(Self, Index)
        end))

        __namecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
            local Arguments = {...}
            local Method = tostring(getnamecallmethod())

            if not checkcaller() and Method == "FireServer" then
                for _, Argument in pairs(Arguments) do
                    if typeof(Argument) == "Vector3" then
                        PhoboTables.Locals.AntiAimViewer.MouseRemote = Self
                        PhoboTables.Locals.AntiAimViewer.MouseRemoteFound = true
                        WOAHHH = Arguments
                        PhoboTables.Locals.AntiAimViewer.MouseRemoteArgs = Arguments
                        PhoboTables.Locals.AntiAimViewer.MouseRemotePositionIndex = _
                        NEINIGGANEINEI = _

                        if Settings.Combat.Enabled and Settings.Combat.Silent and not Settings.Combat.AntiAimViewer and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target and not Settings.Combat.UseIndex then
                            Arguments[_] = (PhoboTables.Functions.GetTargetPredictedPosition().Position)
                        end

                        return __namecall(Self, unpack(Arguments))
                    end
                end
            end
            return __namecall(Self, ...)
        end))

local Sexy = {}
local ClientThinf = game:GetService("Players").LocalPlayer
Sexy[1] = hookmetamethod(ClientThinf:GetMouse(), "__index", newcclosure(function(self, index)
    if index == "Hit" and Settings.Combat.Enabled and Settings.Combat.Silent and not Settings.Combat.AntiAimViewer and PhoboTables.Locals.IsTargetting and PhoboTables.Locals.Target and Settings.Combat.UseIndex then
        
            local position = CFrame.new((PhoboTables.Functions.GetTargetPredictedPosition().Position))
            
            return position
    end
    return Sexy[1](self, index)
end))
    end
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mc4121ban/Linoria-Library-Mobile/refs/heads/main/Gui%20Lib%20%5BLibrary%5D"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mc4121ban/Linoria-Library-Mobile/refs/heads/main/Gui%20Lib%20%5BThemeManager%5D"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mc4121ban/Linoria-Library-Mobile/refs/heads/main/Gui%20Lib%20%5BSaveManager%5D"))()
local Window = Library:CreateWindow({
    Title = 'Phobo.ez | .gg/dNwgY5Cg',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})
local Tabs = {
    Main = Window:AddTab('Main'),
    Misc = Window:AddTab('Misc'),
    Visuals = Window:AddTab('Visuals'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}
local aim = Tabs.Main:AddLeftGroupbox('Main')
local Target = Tabs.Main:AddLeftGroupbox('Target')
local FOVTag = Tabs.Visuals:AddLeftGroupbox("Fov")
local spin = Tabs.Misc:AddLeftGroupbox("Spin Bot")
local Lp = Tabs.Visuals:AddLeftGroupbox("local Player")
local cffly = Tabs.Misc:AddLeftGroupbox("CFrame vs fly")



----------------------------------------------------------------------------------------------------------------------------------------------------------------
--// Button 
local MyButton = aim:AddButton({
    Text = 'Button',
    Func = function()
do
local ScreeenGui = Instance.new("ScreenGui")
local Fraame = Instance.new("Frame")
local TeextButton = Instance.new("ImageButton")
local UIITextSizeConstraint = Instance.new("UITextSizeConstraint")
ScreeenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreeenGui.ResetOnSpawn = false
ScreeenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Fraame.Parent = ScreeenGui
Fraame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Fraame.BackgroundTransparency = 0.8
Fraame.Position = UDim2.new(0.9, -65, 0.8, -25)
Fraame.Size = UDim2.new(0, 90, 0, 90)
Fraame.Draggable = true

TeextButton.Parent = Fraame
TeextButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
TeextButton.BackgroundTransparency = 1
TeextButton.Size = UDim2.new(0, 75, 0, 75)
TeextButton.AnchorPoint = Vector2.new(0.5,0.5)
TeextButton.Position = UDim2.new(0.5, 0, 0.5, 0)
TeextButton.Image = "rbxassetid://10747366027"

local uiiCorner = Instance.new("UICorner", Fraame)
uiiCorner.CornerRadius = UDim.new(0, 9)

TeextButton.MouseButton1Down:Connect(function()
                    if Settings.Combat.Enabled then
                    PhoboTables.Locals.IsTargetting = not PhoboTables.Locals.IsTargetting
                        local NewTarget = PhoboTables.Functions.GetClosestPlayerNumbah()
                    PhoboTables.Locals.Target = PhoboTables.Locals.IsTargetting and NewTarget.Character and NewTarget or nil

                        if Settings.Combat.Alerts and PhoboTables.Locals.Target ~= nil  then
                        end
                    end
--//rbxassetid://10734985247
if PhoboTables.Locals.Target then
  TeextButton.Image = "rbxassetid://10723434711"
else
  TeextButton.Image = "rbxassetid://10747366027"
end
end)
local inputService   = game:GetService("UserInputService")
UIITextSizeConstraint.Parent = TeextButton
UIITextSizeConstraint.MaxTextSize = 30
function draggable(a)local b=inputService;local c;local d;local e;local f;local function g(h)local i=h.Position-e;a.Position=UDim2.new(f.X.Scale,f.X.Offset+i.X,f.Y.Scale,f.Y.Offset+i.Y) end;a.InputBegan:Connect(function(h)if h.UserInputType==Enum.UserInputType.MouseButton1 or h.UserInputType==Enum.UserInputType.Touch then c=true;e=h.Position;f=a.Position;h.Changed:Connect(function()if h.UserInputState==Enum.UserInputState.End then c=false end end)end end)a.InputChanged:Connect(function(h)if h.UserInputType==Enum.UserInputType.MouseMovement or h.UserInputType==Enum.UserInputType.Touch then d=h end end)b.InputChanged:Connect(function(h)if h==d and c then g(h)end end)end
draggable(Fraame)
end
    end,
    DoubleClick = false,
})
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--// aim
aim:AddToggle('MasterSwitchToggle', {
    Text = 'Master Switch',
    Default = false,
    Callback = function(v)
        Settings.Combat.Enabled = v
    end
})
aim:AddToggle('TargetToggle', {
    Text = 'Target',
    Default = false,
    Callback = function(v)
        Settings.Combat.Silent = v
    end
})
aim:AddToggle('CamToggle', {
    Text = 'Cam',
    Default = false,
    Callback = function(v)
        Settings.Combat.Camera = v
    end
})
--// Dropdown
aim:AddDropdown('AimPartDropdown', {
    Values = { 'HumanoidRootPart', 'UpperTorso', 'LowerTorso' },
    Default = 1,
    Multi = false,
    Text = 'Aim Part',
    Callback = function(v)
        Settings.Combat.AimPart = v
    end
})
aim:AddInput("HorizontalInput",{
            Default = "0.15",
            Numeric = false,
            Finished = false,
            Text = "Horizontal",
            Placeholder = "0.15",
            Callback = function(value)
                Settings.Combat.Prediction.Horizontal = tonumber(v)
            end
        }
    )
aim:AddInput("VerticalInput",{
            Default = "0.15",
            Numeric = false,
            Finished = false,
            Text = "Vertical",
            Placeholder = "0.15",
            Callback = function(value)
                Settings.Combat.Prediction.Horizontal = tonumber(v)
            end
        }
    )
aim:AddToggle('PredToggle', {
    Text = 'auto Pred',
    Default = false,
    Callback = function(v)
        Settings.Combat.PingBased = v
    end
})
aim:AddToggle('ResolverToggle', {
    Text = 'Resolver',
    Default = false,
    Callback = function(v)
        Settings.Combat.Resolver.Enabled = v
    end
})
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--// Target
Target:AddToggle('LookAtToggle', {
    Text = 'Look At',
    Default = false,
    Callback = function(v)
        Settings.Combat.LookAt = v
    end
})
Target:AddToggle('ViewAtToggle', {
    Text = 'View At',
    Default = false,
    Callback = function(v)
        Settings.Combat.Spectate = v
    end
})
Target:AddToggle('AntiAimViewerToggle', {
    Text = 'Anti Aim Viewer',
    Default = false,
    Callback = function(v)
        Settings.Combat.AntiAimViewer = v
    end
})




----------------------------------------------------------------------------------------------------------------------------------------------------------------
--// Visuals
FOVTag:AddSlider('FOVSLlider', {
    Text = 'Amount',
    Default = 70,
    Min = 70,
    Max = 120,
    Rounding = 2,
    Compact = false,
})
Options.FOVSLlider:OnChanged(function()
    workspace.CurrentCamera.FieldOfView = Options.FOVSLlider.Value
end)

-- // Tables
local phobo = {
        Visuals = {
            Trail = {
                Enabled = false,
                LifeTime = 0.7,
                Color = MainColor
            },
        }
     }

--// Trail
Lp:AddToggle('TrailToggle', {
    Text = 'Trail',
    Default = phobo.Visuals.Trail.Enabled,
    Callback = function(W)
        phobo:TrailCharacter(W)
    end
})
Lp:AddLabel('Color'):AddColorPicker('trailPicker', {
    Default = Color3.new(0, 1, 0),
    Title = 'color',
    Transparency = 0,
    Callback = function(W)
        phobo.Visuals.Trail.Color = W
    end
})
Lp:AddSlider('trailSlider', {
    Text = 'Life Time',
    Default = phobo.Visuals.Trail.LifeTime,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(W)
        phobo.Visuals.Trail.LifeTime = W
    end
})

--// ForceField
Lp:AddToggle('ForceFieldToggle', {
    Text = 'ForceField Body',
    Default = false,
    Callback = function(state)
        effectEnabled = state
    end
})
Lp:AddLabel('Color'):AddColorPicker('Color', {
    Default = Color3.new(212, 0, 0),
    Title = 'color',
    Transparency = 1,
    Callback = function(color)
        forceFieldColor = color 
    end
})




----------------------------------------------------------------------------------------------------------------------------------------------------------------
--// Misc
-- // Tables

local Script = {
        Rage = {
       CFrameSpeed = {
            Enabled = false,
            Speed = 2
        },
    }
 }
--// CFrame
local MyButton = cffly:AddButton({
    Text = 'Button',
    Func = function()
        local ScreenGui = Instance.new("ScreenGui")

        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

        ScreenGui.ResetOnSpawn = false
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Text = "Button Speed"
        ToggleButton.Parent = ScreenGui
        ToggleButton.BackgroundTransparency = 0.5
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Position = UDim2.new(1, -150, 0, -1)
        ToggleButton.Size = UDim2.new(0, 100, 0, 40)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(248, 255, 252)
        ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        local UICorner = Instance.new("UICorner")
        UICorner.Parent = ToggleButton

        local function onButtonClicked()
            Script.Rage.CFrameSpeed.Enabled = not Script.Rage.CFrameSpeed.Enabled
        end

        ToggleButton.MouseButton1Click:Connect(onButtonClicked)
    end,
    DoubleClick = false,
})
cffly:AddToggle('CFrameSpeed', {
    Text = 'Enabled',
    Default = false,
    Callback = function(W)
        Script.Rage.CFrameSpeed.Enabled = W
    end
})
cffly:AddSlider('SpeedAmount', {
    Text = 'CFrame Slider',
    Default = 2,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(W)
        Script.Rage.CFrameSpeed.Speed = W
    end
})





--// spin
local isToggled = false
spin:AddToggle('spinToggle', {
    Text = 'spin',
    Default = false,
    Callback = function(state)
        isToggled = state
    end
})
spin:AddSlider('SpinBotToggle', {
    Text = 'SpinBot Speed',
    Default = 10,
    Min = 0,
    Max = 700,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        speed = Value  
    end
})
local speedMultiplier = 12  
RunService.RenderStepped:Connect(function(Delta)
    if isToggled then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(speed * speedMultiplier) * Delta, 0)
        LocalPlayer.Character:FindFirstChild("Humanoid").AutoRotate = false
    else
        LocalPlayer.Character:FindFirstChild("Humanoid").AutoRotate = true
    end
end)










local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('MyPhoboTablesHub')
SaveManager:SetFolder('MyPhoboTablesHub/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--// function

--// ForceField
spawn(function()
    while wait() do
        for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("MeshPart") then
                if effectEnabled then
                    part.Material = Enum.Material.ForceField
                    part.Color = forceFieldColor -- Use the dynamically updated color
                else
                    -- Revert to original properties
                    part.Material = Enum.Material.SmoothPlastic -- Change this to the original material you want
                    part.Color = Color3.fromRGB(255, 255, 255) -- Change this to the original color you want (white)
                end
            end
        end
    end
end)

--// CFrameSpeed
     game:GetService("RunService").Stepped:Connect(function()
            if Script.Rage.CFrameSpeed.Enabled then
                local character = game.Players.LocalPlayer.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local moveDirection = character:FindFirstChild("Humanoid") and character.Humanoid.MoveDirection or Vector3.new(0, 0, 0)

                    if humanoidRootPart then
                        humanoidRootPart.CFrame = humanoidRootPart.CFrame + moveDirection * Script.Rage.CFrameSpeed.Speed
                    end
                end
            end
        end)


--// Trail
function phobo:TrailCharacter(Bool)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if Bool then
        local BlaBla = Instance.new("Trail", humanoidRootPart)
        BlaBla.Name = "BlaBla"
        
        humanoidRootPart.Material = Enum.Material.Neon 
        
        local attachment0 = Instance.new("Attachment", humanoidRootPart)
        attachment0.Position = Vector3.new(0, 1, 0)
        local attachment1 = Instance.new("Attachment", humanoidRootPart)
        attachment1.Position = Vector3.new(0, -3, 1)

        BlaBla.Attachment0 = attachment0
        BlaBla.Attachment1 = attachment1
        
        BlaBla.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, phobo.Visuals.Trail.Color), ColorSequenceKeypoint.new(1, phobo.Visuals.Trail.Color)});
        
        BlaBla.Lifetime = phobo.Visuals.Trail.LifeTime
        
        BlaBla.Transparency = NumberSequence.new(0, 0)
        
        BlaBla.LightEmission = 1
        
        BlaBla.WidthScale = NumberSequence.new(0.08)
        
    else
        for _, child in ipairs(humanoidRootPart:GetChildren()) do
            if child:IsA("Trail") and child.Name == 'BlaBla' then
                child:Destroy()
            end
        end
    end
end
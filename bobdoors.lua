local Translations = {
   --["这里填要替换的英文"] = "这里填中文",
    ["Toggle"] = "切换",
    ["Lock"] = "锁定",
    ["Info"] = "信息",
    ["General"] = "常规",
    ["Cheats"] = "作弊",
    ["Visuals"] = "视觉",
    ["Floor"] = "楼层",
    ["Miscellaneous"] = "杂项",
    ["Settings"] = "设置",
    ["Character"] = "角色",
    ["Game"] = "游戏",
    ["LocalPlayer"] = "本地玩家",
    ["Automation"] = "自动化",
    ["Anti Entities"] = "反实体",
    ["Bypass"] = "绕过",
    ["Camera"] = "相机",
    ["Vision"] = "视觉",
    ["Effects"] = "效果",
    ["World"] = "世界",
    ["ESP"] = "额外感知",
    ["Modifiers"] = "修改器",
    ["Death"] = "死亡",
    ["Other"] = "其他",
    ["Walkspeed"] = "移动速度",
    ["Fly Speed"] = "飞行速度",
    ["JumpBoost"] = "跳跃高度",
    ["Enabled Walkspeed"] = "启用移动速度",
    ["Enabled Fly"] = "启用飞行",
    ["Enabled JumpBoost"] = "启用跳跃高度",
    ["No Acceleration"] = "无加速度",
    ["Infinite Jump"] = "无限跳跃",
    ["Fast Closet Exit"] = "快速退出壁橱",
    ["Disable AFK"] = "禁用挂机",
    ["Prompt Multiplier"] = "提示倍数",
    ["Door Reach Range"] = "开门距离范围",
    ["Enabled Prompt Multiplier"] = "启用提示倍数",
    ["Door Reach"] = "开门距离",
    ["Instant Interact"] = "即时交互",
    ["Prompt Clip"] = "提示剪辑",
    ["Auto Solve Breaker Box"] = "自动解决配电箱",
    ["Auto Solve Library Code"] = "自动解决图书馆密码",
    ["Padlock Unlock"] = "挂锁解锁",
    ["Padlock Distance"] = "挂锁距离",
    ["Auto Interact"] = "自动交互",
    ["Entities Alerts"] = "实体警报",
    ["Item Alerts"] = "物品警报",
    ["Oxygen Alerts"] = "氧气警报",
    ["Anti Eyes"] = "防 Eyes",
    ["Anti Screech"] = "防 Screech",
    ["Anti Dread"] = "防 Dread",
    ["Anti Halt"] = "防 Halt",
    ["Anti Dupe"] = "防 Dupe",
    ["Anti Snare"] = "防 Snare",
    ["Speed Bypass"] = "速度绕过",
    ["Crouch Spoof"] = "蹲伏欺骗",
    ["GodMode"] = "上帝模式",
    ["Field of View"] = "视野范围",
    ["Enabled Field of View"] = "启用视野范围",
    ["Offset"] = "偏移量",
    ["Camera Distance"] = "相机距离",
    ["Third Person"] = "第三人称",
    ["No Earthquake Shake"] = "无地震震动",
    ["Brightness"] = "亮度",
    ["Hiding Transparency"] = "隐藏透明度",
    ["FullBright"] = "全亮",
    ["Spot Transparency"] = "斑点透明度",
    ["Anti Lag"] = "防卡顿",
    ["No Glitch"] = "无故障",
    ["No Spider"] = "无蜘蛛",
    ["No Void Effects"] = "无虚空效果",
    ["No Jumpscare"] = "无JumpScare",
    ["Door"] = "门",
    ["Objective"] = "目标",
    ["Item"] = "物品",
    ["Spot"] = "斑点",
    ["Chest"] = "箱子",
    ["Gold"] = "金币",
    ["Stardust"] = "星尘",
    ["Entities"] = "实体",
    ["Player"] = "玩家",
    ["Distance"] = "距离",
    ["Tracer"] = "追踪线",
    ["Rainbow"] = "彩虹",
    ["Arrows"] = "箭头",
    ["Text Size"] = "文字大小",
    ["Tracer Thickness"] = "追踪线粗细",
    ["Enabled Chat"] = "启用聊天",
    ["Ingore Gold"] = "忽略金币",
    ["Ingore Item Notify"] = "忽略物品通知",
    ["Ingore Chat"] = "忽略聊天",
    ["Anti Seek Obstruction"] = "防 Seek 阻碍",
    ["Death Farm"] = "死亡农场",
    ["Stunned"] = "眩晕",
    ["Lobby"] = "大厅",
    ["Revive"] = "复活",
    ["Play Again"] = "再玩一次",
    ["Reset Character"] = "重置角色"
}

local function translateText(text)
    if not text or type(text) ~= "string" then return text end
    
    if Translations[text] then
        return Translations[text]
    end
    
    for en, cn in pairs(Translations) do
        if text:find(en) then
            return text:gsub(en, cn)
        end
    end
    
    return text
end

local function setupTranslationEngine()
    local success, err = pcall(function()
        local oldIndex = getrawmetatable(game).__newindex
        setreadonly(getrawmetatable(game), false)
        
        getrawmetatable(game).__newindex = newcclosure(function(t, k, v)
            if (t:IsA("TextLabel") or t:IsA("TextButton") or t:IsA("TextBox")) and k == "Text" then
                v = translateText(tostring(v))
            end
            return oldIndex(t, k, v)
        end)
        
        setreadonly(getrawmetatable(game), true)
    end)
    
    if not success then
        warn("元表劫持失败:", err)
       
        local translated = {}
        local function scanAndTranslate()
            for _, gui in ipairs(game:GetService("CoreGui"):GetDescendants()) do
                if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) and not translated[gui] then
                    pcall(function()
                        local text = gui.Text
                        if text and text ~= "" then
                            local translatedText = translateText(text)
                            if translatedText ~= text then
                                gui.Text = translatedText
                                translated[gui] = true
                            end
                        end
                    end)
                end
            end
            
            local player = game:GetService("Players").LocalPlayer
            if player and player:FindFirstChild("PlayerGui") then
                for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
                    if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) and not translated[gui] then
                        pcall(function()
                            local text = gui.Text
                            if text and text ~= "" then
                                local translatedText = translateText(text)
                                if translatedText ~= text then
                                    gui.Text = translatedText
                                    translated[gui] = true
                                end
                            end
                        end)
                    end
                end
            end
        end
        
        local function setupDescendantListener(parent)
            parent.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                    task.wait(0.1)
                    pcall(function()
                        local text = descendant.Text
                        if text and text ~= "" then
                            local translatedText = translateText(text)
                            if translatedText ~= text then
                                descendant.Text = translatedText
                            end
                        end
                    end)
                end
            end)
        end
        
        pcall(setupDescendantListener, game:GetService("CoreGui"))
        local player = game:GetService("Players").LocalPlayer
        if player and player:FindFirstChild("PlayerGui") then
            pcall(setupDescendantListener, player.PlayerGui)
        end
        
        while true do
            scanAndTranslate()
            task.wait(3)
        end
    end
end

task.wait(2)

setupTranslationEngine()

local success, err = pcall(function()
--这下面填加载外部脚本
loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/bobdoors/main/main.lua"))()


end)

if not success then
    warn("加载失败:", err)
end

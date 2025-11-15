local Translations = {
    ["Toggle"] = "切换",
    ["Lock"] = "锁定",
    ["Search"] = "搜索",
    ["FPS"] = "帧率",
    ["Teleport"] = "传送",
    ["Player"] = "玩家",
    ["Alone"] = "独自",
    ["Refresh"] = "刷新",
    ["Grind"] = "刷取",
    ["Auto"] = "自动",
    ["Campfire"] = "篝火",
    ["Fuel"] = "燃料",
    ["Log"] = "木头",
    ["Coal"] = "煤炭",
    ["Oil"] = "石油",
    ["Barrel"] = "桶",
    ["Biofuel"] = "生物燃料",
    ["Machine"] = "机器",
    ["Dealer"] = "商人",
    ["Bring"] = "带来",
    ["Pelt"] = "毛皮",
    ["Lost"] = "丢失",
    ["Child"] = "孩子",
    ["Health"] = "生命",
    ["Food"] = "食物",
    ["MedKit"] = "医疗包",
    ["Cooked"] = "熟的",
    ["Steak"] = "牛排",
    ["Morsel"] = "小块",
    ["Berry"] = "浆果",
    ["Carrot"] = "胡萝卜",
    ["Apple"] = "苹果",
    ["Pumpkin"] = "南瓜",
    ["Armor"] = "护甲",
    ["Ammo"] = "弹药",
    ["Revolver"] = "左轮",
    ["Rifle"] = "步枪",
    ["Weapon"] = "武器",
    ["Gear"] = "装备",
    ["Component"] = "组件",
    ["UFO"] = "飞碟",
    ["Engine"] = "引擎",
    ["Fan"] = "风扇",
    ["Microwave"] = "微波炉",
    ["Bolt"] = "螺栓",
    ["Gem"] = "宝石",
    ["Sheet"] = "金属板",
    ["Radio"] = "收音机",
    ["Tyre"] = "轮胎",
    ["Washing"] = "洗衣机",
    ["Cultist"] = "邪教徒",
    ["Experiment"] = "实验",
    ["Fragment"] = "碎片",
    ["Broken"] = "损坏的",
    ["Sack"] = "袋子",
    ["Axe"] = "斧头",
    ["Chainsaw"] = "电锯",
    ["Flashlight"] = "手电筒",
    ["Old"] = "旧的",
    ["Good"] = "好的",
    ["Ice"] = "冰",
    ["Strong"] = "强壮的",
    ["Giant"] = "巨大的",
    ["Infernal"] = "地狱的",
    ["GOD"] = "上帝",
    ["Mode"] = "模式",
    ["Aura"] = "光环",
    ["Range"] = "范围",
    ["Boost"] = "提升",
    ["Studs"] = "螺柱",
    ["Chests"] = "箱子",
    ["Unlock"] = "解锁",
    ["Infinite"] = "无限的",
    ["Saplings"] = "树苗",
    ["Plant"] = "种植",
    ["Chop"] = "砍伐",
    ["Click"] = "点击",
    ["Lobby"] = "大厅",
    ["Text"] = "文本",
    ["Show"] = "展示",
    ["Love"] = "喜欢",
    ["Using"] = "使用",
    ["Nights"] = "夜晚",
    ["Forest"] = "森林",
    ["Version"] = "版本",
    ["Alone"] = "独自",
    ["Haha"] = "哈哈",
    ["Kid"] = "小孩",
    ["Bag"] = "包",
    ["Camp"] = "营地",
    ["Bunny"] = "兔子",
    ["Wolf"] = "狼",
    ["Alpha"] = "首领",
    ["Bear"] = "熊",
    ["Foot"] = "脚",
    ["Body"] = "身体",
    ["Leather"] = "皮革",
    ["Iron"] = "铁",
    ["ALL"] = "全部",
    ["OP"] = "强力"
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
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2c402e038e618d82db3f0cd6afe853e3.lua"))()



end)

if not success then
    warn("加载失败:", err)
end

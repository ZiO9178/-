local Translations = {
   --["这里填要替换的英文"] = "这里填中文",
    ["Main"] = "公告",
    ["Combat"] = "主要",
    ["Kill Aura"] = "杀戮光环",
    ["Chop Aura"] = "砍伐光环",
    ["Aura Radius"] = "光环范围",
    ["Hitbox Size"] = "碰撞箱",
    ["Auto"] = "自动",
    ["Bring"] = "携带",
    ["Teleport"] = "传送",
    ["Player"] = "玩家",
    ["Select Foods"] = "选择食物",
    ["Apple"] = "苹果",
    ["Berry"] = "浆果",
    ["Carrot"] = "胡萝卜",
    ["Cake"] = "蛋糕",
    ["Chili"] = "辣椒",
    ["Cooked Clownfish"] = "熟小丑鱼",
    ["Cooked Swordfish"] = "熟剑鱼",
    ["Cooked Jellyfish"] = "熟水母",
    ["Cooked Char"] = "熟茴鱼",
    ["Cooked Eel"] = "熟鳗鱼",
    ["Cooked Shark"] = "熟鲨鱼",
    ["Cooked Ribs"] = "熟排骨",
    ["Cooked Mackerel"] = "熟鲭鱼",
    ["Cooked Salmon"] = "熟三文鱼",
    ["Cooked Morsel"] = "熟小块食物",
    ["Cooked Steak"] = "熟牛排",
    ["When to eat"] = "何时进食",
    ["Auto Eat"] = "自动进食",
    ["Select ltems To Burn"] = "选择要燃烧的物品",
    ["Auo Upgrade Campfire"] = "自动升级营火",
    ["Log"] = "原木",
    ["Coal"] = "煤炭",
    ["Fuel Canister"] = "燃料罐",
    ["Oil Barrel"] = "油桶",
    ["Biofuel"] = "生物燃料",
    ["ltems To Cook"] = "待烹饪物品",
    ["Morsel"] = "小块食物",
    ["Steak"] = "牛排",
    ["Auto Cook"] = "自动烹饪",
    ["Auto Collect Coins"] = "自动收集金币",
    ["Auto Pick Flower"] = "自动采摘花朵",
    ["ESP ltems"] = "ESP物品",
    ["Bolt"] = "螺栓",
    ["Bandage"] = "绷带",
    ["Broken Fan"] = "破损的风扇",
    ["Broken Microwave"] = "破损的微波炉",
    ["Cake"] = "蛋糕",
    ["Carrot"] = "胡萝卜",
    ["Chair"] = "椅子",
    ["Coal"] = "煤炭",
    ["Coin Stack"] = "金币堆",
    ["Cooked Morsel"] = "熟小块食物",
    ["Cooked Steak"] = "熟牛排",
    ["Fuel Canister"] = "燃料罐",
    ["lron Body"] = "钢铁身躯",
    ["Leather Armor"] = "皮甲",
    ["Log"] = "原木",
    ["MadKit"] = "疯狂工具包",
    ["Metal Chair"] = "金属椅",
    ["MedKit"] = "医疗包",
    ["Old Car Engine"] = "旧汽车引擎",
    ["Old Flashlight"] = "旧手电筒",
    ["Old Radio"] = "旧收音机",
    ["Revolver"] = "左轮手枪",
    ["Revolve Ammo"] = "左轮手枪弹药",
    ["Rifle"] = "步枪",
    ["Rifle Ammo"] = "步枪弹药",
    ["Sheet Metal"] = "金属板材",
    ["Steak"] = "牛排",
    ["Tyre"] = "轮胎",
    ["Washing Machine"] = "洗衣机",
    ["Enable Esp ltems"] = "启用ESP物品",
    ["Esp Entity"] = "ESP实体",
    ["Enable Esp Entity"] = "启用ESP实体",
    ["ESP Players"] = "ESP玩家",
    ["Bunny"] = "兔子",
    ["Wolf"] = "狼",
    ["Alpha Wolf"] = "阿尔法狼",
    ["Bear"] = "熊",
    ["Cultist"] = "邪教徒",
    ["Crossbow Cultist"] = "十字弩邪教徒",
    ["Alien"] = "外星人",
    
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
loadstring(game:HttpGet("https://raw.githubusercontent.com/Filipp947/LightHub/refs/heads/main/99nightsintheforestloader.lua"))()


end)

if not success then
    warn("加载失败:", err)
end

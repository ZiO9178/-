local Translations = {
   --["这里填要替换的英文"] = "这里填中文",
    ["Information"] = "信息",
    ["Voidware"] = "虚空",
    ["discord.gg/voidware"] = "Z某人汉化",
    ["en"] = "英文",
    ["Search"] = "搜索",
    ["Fun"] = "趣味功能",
    ["Automation"] = "自动化",
    ["Bring Stuff"] = "物品传送",
    ["Main"] = "主要功能",
    ["Fishing"] = "钓鱼相关",
    ["Teleport"] = "传送",
    ["Visuals"] = "视觉效果",
    ["Reveal Map"] = "地图全开",
    ["Teleport All Trees"] = "传送所有树木",
    ["Teleport All BIG Trees"] = "传送所有大树",
    ["Teleport All Chests"] = "传送所有宝箱",
    ["Teleport All Children [BETA] "] = "传送所有孩童 [测试版]",
    ["Teleport Entities"] = "传送实体",
    ["Teleport The Entities"] = "传送实体",
    ["Freeze the movement of something :3"] = "冻结某物动物",
    ["Freeze The Thingys"] = "冻结动物",
    ["UnFreeze The Thingys"] = "解冻动物",
    ["Frog"] = "青蛙",
    ["Scorpion"] = "蝎子",
    ["FrogBlue"] = "蓝色青蛙",
    ["FrogPurple"] = "紫色青蛙",
    ["Wolf"] = "狼",
    ["Bear"] = "熊",
    ["Bunny"] = "兔子",
    ["Arctic Fox"] = "北极狐",
    ["Mammoth"] = "猛犸象",
    ["Cultist"] = "信徒",
    ["Crossbow Cultist"] = "十字弓信徒",
    ["Juggernaut Cultist"] = "主宰信徒",
    ["Polar Bear"] = "北极熊",
    ["Alpha Wolf"] = "阿尔法狼",
    ["Alien"] = "外星人",
    ["Elite Alien"] = "外星精英",
    ["Pickup All Flowers"] = "拾取所有花朵",
    ["Collect All Gold Stacks"] = "收集所有金堆",
    ["Auto Crock Pot"] = "自动炖锅",
    ["Food Choice"] = "食材选择",
    ["Bring Food To Cook Pot"] = "将食材送至炖锅",
    ["Auto Campfire"] = "自动营火",
    ["Fuel Type"] = "燃料类型",
    ["Auto Fill Campfire"] = "自动填充营火",
    ["Start Fueling when (Fire HP)"] = "当（营火生命值）为以下数值时开始添加燃料",
    ["Auto Collect"] = "自动收集",
    ["Auto Pickup Flowers"] = "自动拾取花朵",
    ["Auto Collect Coin Stacks"] = "自动收集金币堆",
    ["Auto Open Seed Boxes"] = "自动打开种子箱",
    ["Auto Chest [BETA]"] = "自动宝箱 [测试版]",
    ["Bring Location"] = "传送位置",
    ["Player"] = "玩家",
    ["Enabled"] = "启用",
    ["Plant Stuff"] = "种植相关",
    ["Build Radius"] = "建造半径",
    ["Angle Increment"] = "角度增量",
    ["Plant/Build Limit"] = "种植/建造上限",
    ["Plant Saplings in Circle"] = "环形种植树苗",
    ["Build Log Walls in Circle"] = "环形建造原木墙",
    ["Bring Settings"] = "传送设置",
    ["Use Freecam for Bring Items"] = "为传送物品启用自由视角",
    ["Faster Bring [BETA]"] = "快速传送 [测试版]",
    ["Bring Location"] = "传送位置",
    ["Max Per Item"] = "每件物品最大数量",
    ["Bring Cooldown"] = "传送冷却时间",
    ["No Bring Amount Limit"] = "无传送数量限制",
    ["Workbench"] = "工作台",
    ["Fire"] = "营火",
    ["Fuel"] = "燃料",
    ["Bring Logs [BETA]"] = "传送原木 [测试版]",
    ["Bring Food & Healing"] = "传送食物与医疗物品",
    ["Food & Healing"] = "食物与医疗物品",
    ["Bring Gears"] = "传送齿轮类物品",
    ["Gears"] = "齿轮类物品",
    ["Bring Guns & Armor"] = "传送枪支与护甲",
    ["Bring OthersBring Others"] = "传送其他物品",
    ["Others"] = "其他物品",
    ["Diamond"] = "钻石",
    ["Bring Height"] = "带来高度",
    ["Corpse"] = "尸体",
    ["Guns & Armor"] = "枪支与护甲",
    ["lce Axe"] = "冰斧",
    ["lce Sword"] = "冰剑",
    ["Entity Godmode"] = "实体无敌模式",
    ["Hip Height Changer"] = "臀部高度调整",
    ["Kill Aura"] = "杀戮光环",
    ["Kill Aura Range"] = "杀戮光环范围",
    ["Ice Aura"] = "冰冻光环",
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
loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", true))()


end)

if not success then
    warn("加载失败:", err)
end

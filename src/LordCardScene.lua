--[[
版权信息.
]]--

-------------------------------------------------------------------------------
-- 斗地主场景(局部变量).
-- 作者: Andrew Yuan<br>
-- 时间: 2014-12-06.
-- @module LordCardScene
local LordCardScene = class("LordCardScene",function()
    return cc.Scene:create()
end)

function LordCardScene.create()
    local scene = LordCardScene.new()
    scene:addChild(scene:createlayerTable())
    scene:addChild(scene:createLayerMenu())
    return scene
end


function LordCardScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
end

function LordCardScene:playBgMusic()
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3") 
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
end

function LordCardScene:creatDog()
    local frameWidth = 105
    local frameHeight = 95

    -- create dog animate
    local textureDog = cc.Director:getInstance():getTextureCache():addImage("dog.png")
    local rect = cc.rect(0, 0, frameWidth, frameHeight)
    local frame0 = cc.SpriteFrame:createWithTexture(textureDog, rect)
    rect = cc.rect(frameWidth, 0, frameWidth, frameHeight)
    local frame1 = cc.SpriteFrame:createWithTexture(textureDog, rect)

    local spriteDog = cc.Sprite:createWithSpriteFrame(frame0)
    spriteDog:setPosition(self.origin.x, self.origin.y + self.visibleSize.height / 4 * 3)
    spriteDog.isPaused = false

    local animation = cc.Animation:createWithSpriteFrames({frame0,frame1}, 0.5)
    local animate = cc.Animate:create(animation);
    spriteDog:runAction(cc.RepeatForever:create(animate))

    -- moving dog at every frame
    local function tick()
        if spriteDog.isPaused then return end
        local x, y = spriteDog:getPosition()
        if x > self.origin.x + self.visibleSize.width then
            x = self.origin.x
        else
            x = x + 1
        end

        spriteDog:setPositionX(x)
    end

    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)

    return spriteDog
end

-- create farm
function LordCardScene:createlayerTable()
    local layerTable = cc.Layer:create()
    
    -- 屏幕中心
    local location = {
        x = self.origin.x + self.visibleSize.width / 2,
        y = self.origin.y + self.visibleSize.height / 2
    };
    
    -- 添加牌桌背景
    local bg = cc.Sprite:create("card/pic/bg.png");
    -- 总是放置的中心位置, Cocos总是以左下角为坐标原点
    bg:setPosition(location.x, location.y);
    print("背景宽度: " .. bg:getTexture():getPixelsWide())
    print("背景高度: " .. bg:getTexture():getPixelsHigh())
    layerTable:addChild(bg)
    
    -- 将所有的牌铺在桌面上(1: 梅花, 2: 方片, 3: 红心, 4: 黑桃, 5: 大小王)
    local startX = 60
    local startY = 200
    for i = 1, 5 do
        for j = 3, 17 do
            if (i < 5 and j < 16) or (i >= 5 and j >= 16) then
                local card = cc.Sprite:create("card/pic/a" .. i .. "_" .. j .. ".png")
                card:setPosition(startX + (j - 3) * 60, startY + (i - 1) * 80)
                layerTable:addChild(card)
            end
        end
    end

    return layerTable
end

-- create menu
function LordCardScene:createLayerMenu()

    local layerMenu = cc.Layer:create();
      
    -- 屏幕中心
    local location = {
        x = self.origin.x + self.visibleSize.width / 2,
        y = self.origin.y + self.visibleSize.height / 2
    };
    
    local color = cc.c3b(0xFF,0xFF,0);
    
    
    -- 创建一个文字菜单
    local startMenuItemLocation = {
        x = location.x,
        y = location.y + 280 + 40
    };
    local pauseMenuItemLocation = {
        x = location.x,
        y = location.y + 280
    };
    local endMenuItemLocation = {
        x = location.x,
        y = location.y + 280 - 40
    };
    function startMenuItemCallback(sender)
        print("点击了文字开始");
    end
    function pauseMenuItemCallback(sender)
        print("点击了文字暂停");
    end
    function endMenuItemCallback(sender)
        print("点击了文字结束");
    end

    local startMenuItem = CCMenuUtil.createMenuItemFont(
        "开始", color, startMenuItemLocation, startMenuItemCallback);
    local pauseMenuItem = CCMenuUtil.createMenuItemFont(
        "暂停", color, pauseMenuItemLocation, pauseMenuItemCallback);
    local endMenuItem = CCMenuUtil.createMenuItemFont(
        "结束", color, endMenuItemLocation, endMenuItemCallback);

    layerMenu:addChild(CCMenuUtil.createMenu({x=0,y=0}, startMenuItem, pauseMenuItem, endMenuItem));


    -- 创建一个Sprite菜单
    local startMenuItemLocation1 = {
        x = location.x - 480,
        y = location.y + 280 + 42
    };
    local pauseMenuItemLocation1 = {
        x = location.x - 480,
        y = location.y + 280
    };
    local endMenuItemLocation1 = {
        x = location.x - 480,
        y = location.y + 280 - 42
    };
    function startMenuItemCallback1(sender)
        print("点击了文字开始");
    end
    function pauseMenuItemCallback1(sender)
        print("点击了文字暂停");
    end
    function endMenuItemCallback1(sender)
        print("点击了文字结束");
    end

    local startMenuItem1 = CCMenuUtil.createMenuItemSprite(
        "card/pic/menu/menu_item_start", color, startMenuItemLocation1, startMenuItemCallback1);
    local pauseMenuItem1 = CCMenuUtil.createMenuItemSprite(
        "card/pic/menu/menu_item_pause", color, pauseMenuItemLocation1, pauseMenuItemCallback1);
    local endMenuItem1 = CCMenuUtil.createMenuItemSprite(
        "card/pic/menu/menu_item_end", color, endMenuItemLocation1, endMenuItemCallback1);

    layerMenu:addChild(CCMenuUtil.createMenu({x=0,y=0}, startMenuItem1, pauseMenuItem1, endMenuItem1));


    -- 创建一个Image菜单
    local startMenuItemLocation2 = {
        x = location.x - 280,
        y = location.y + 280 + 42
    };
    local pauseMenuItemLocation2 = {
        x = location.x - 280,
        y = location.y + 280
    };
    local endMenuItemLocation2 = {
        x = location.x - 280,
        y = location.y + 280 - 42
    };
    function startMenuItemCallback2(sender)
        print("点击了文字开始");
    end
    function pauseMenuItemCallback2(sender)
        print("点击了文字暂停");
    end
    function endMenuItemCallback2(sender)
        print("点击了文字结束");
    end

    local startMenuItem2 = CCMenuUtil.createMenuItemSprite(
        "card/pic/menu/menu_item_start", color, startMenuItemLocation2, startMenuItemCallback2);
    local pauseMenuItem2 = CCMenuUtil.createMenuItemSprite(
        "card/pic/menu/menu_item_pause", color, pauseMenuItemLocation2, pauseMenuItemCallback2);
    local endMenuItem2 = CCMenuUtil.createMenuItemSprite(
        "card/pic/menu/menu_item_end", color, endMenuItemLocation2, endMenuItemCallback2);

    layerMenu:addChild(CCMenuUtil.createMenu({x=0,y=0}, startMenuItem2, pauseMenuItem2, endMenuItem2));

    return layerMenu
end

return LordCardScene

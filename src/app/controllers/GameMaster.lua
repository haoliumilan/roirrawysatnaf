--
-- Author: Hao Liu
-- Date: 2016-08-27 17:56:46
--
--[[
	GameMaster
]]

local Archer = require("app.actors.Archer")
local Dragon = require("app.actors.Dragon")
local Knight = require("app.actors.Knight")
local Mage = require("app.actors.Mage")
local Piglet = require("app.actors.Piglet")
local Rat = require("app.actors.Rat")
local Slime = require("app.actors.Slime")


local battleSiteX = {-2800,-1800,-800}
local monsterCount = {dragon=1,slime=7,piglet=2,rat = 0} --rat count must be 0.
local frontDistanceWithHeroX = 600
local backwardDistanceWithHeroX = 800
local distanceWithHeroX = 150
local distanceWithHeroY = 150
local EXIST_MIN_MONSTER = 4

local GameMaster = class("GameMaster")

function GameMaster:ctor()
	self.totaltime = 0
	self.logicFrq = 1.0

	self:addHeros()
	self:addMonsters()
    self.stage = 0
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))

    for i=1,4 do
        self:randomshowMonster(true)
    end
    self.stage = 1

end

function GameMaster:randomshowMonster(isFront)
	local random_var = math.random()
	if random_var<0.15 then
        if List.getSize(DragonPool) ~= 0 then
		    self:showDragon(isFront)
        else
            self:randomshowMonster(isFront)
        end
	elseif random_var<0.3 then
        if List.getSize(RatPool) ~= 0 then
            self:showRat(isFront)
        else
            self:randomshowMonster(isFront)
        end
    elseif random_var<0.6 then
        if List.getSize(PigletPool) ~= 0 then
            self:showPiglet(isFront)
        else
            self:randomshowMonster(isFront)
        end
	else
        self:showSlime(isFront)
	end

end

function GameMaster:addHeros()
	local knight = Knight.new()
   	knight:setPosition(battleSiteX[1], 10)
    currentLayer:addChild(knight)
    knight:idleMode()
    List.pushlast(HeroManager, knight)

	local mage = Mage.new()
   	mage:setPosition(battleSiteX[1], 100)
   	currentLayer:addChild(mage)
   	mage:idleMode()
   	List.pushlast(HeroManager, mage)
   	
    local archer = Archer.new()
    archer:setPosition(battleSiteX[1], -80)
    currentLayer:addChild(archer)
    archer:idleMode()
    List.pushlast(HeroManager, archer)

end

function GameMaster:addMonsters()
	self:addDragon()
	self:addSlime()
	self:addPiglet()
	self:addRat()
end

function GameMaster:addDragon()
    for var=1, monsterCount.dragon do
        local dragon = Dragon.new()
        currentLayer:addChild(dragon)
        dragon:setVisible(false)
        dragon:setAIEnabled(false)
        List.pushlast(DragonPool,dragon)
    end   
end

function GameMaster:addSlime()
    for var=1, monsterCount.slime do
        local slime = Slime.new()
        currentLayer:addChild(slime)
        slime:setVisible(false)
        slime:setAIEnabled(false)
        List.pushlast(SlimePool,slime)
    end 
end

function GameMaster:addPiglet()
    for var=1, monsterCount.piglet do
    	local piglet = Piglet.new()
    	currentLayer:addChild(piglet)
    	piglet:setVisible(false)
    	piglet:setAIEnabled(false)
    	List.pushlast(PigletPool,piglet)
    end   
end

function GameMaster:addRat()
    for var=1, monsterCount.rat do
        local rat = Rat.new()
        currentLayer:addChild(rat)
        rat:setVisible(false)
        rat:setAIEnabled(false)
        List.pushlast(RatPool,rat)
    end  
end

function GameMaster:showDragon(isFront)
    if List.getSize(DragonPool) ~= 0 then
        local dragon = List.popfirst(DragonPool)
        dragon:reset()
        local appearPos = getFocusPointOfHeros()
        local randomvarX = math.random()*0.2+1
        if self.stage == 0 then
            appearPos.x = appearPos.x + frontDistanceWithHeroX*randomvarX
            dragon:setFacing(180)
        else
            if isFront then
                appearPos.x = appearPos.x + frontDistanceWithHeroX*1.8*randomvarX
                dragon:setFacing(180)
            else
                appearPos.x = appearPos.x - backwardDistanceWithHeroX*1.8*randomvarX
                dragon:setFacing(0)
            end
        end
        local randomvarY = 2*math.random()-1
        appearPos.y = appearPos.y + randomvarY*distanceWithHeroY
        dragon:setPosition(appearPos)
        dragon.myPos = appearPos
        dragon:setVisible(true)
        dragon.goRight = false
        dragon:setAIEnabled(true)
        List.pushlast(MonsterManager, dragon)
    end
end

function GameMaster:showPiglet(isFront)
    if List.getSize(PigletPool) ~= 0 then
        local piglet = List.popfirst(PigletPool)
        piglet:reset()
        local appearPos = getFocusPointOfHeros()
        local randomvarX = math.random()*0.2+1
        if self.stage == 0 then
            appearPos.x = appearPos.x + frontDistanceWithHeroX*randomvarX
            piglet:setFacing(180)
        else
            if isFront then
                appearPos.x = appearPos.x + frontDistanceWithHeroX*1.8*randomvarX
                piglet:setFacing(180)
            else
                appearPos.x = appearPos.x - backwardDistanceWithHeroX*1.8*randomvarX
                piglet:setFacing(0)
            end
        end
        local randomvarY = 2*math.random()-1
        appearPos.y = appearPos.y + randomvarY*distanceWithHeroY
        piglet:setPosition(appearPos)
        piglet.myPos = appearPos
        piglet:setVisible(true)
        piglet.goRight = false
        piglet:setAIEnabled(true)
        List.pushlast(MonsterManager, piglet)
    end
end

function GameMaster:showSlime(isFront)
    if List.getSize(SlimePool) ~= 0 then
        local slime = List.popfirst(SlimePool)
        slime:reset()
        slime.goRight = false
        self:jumpInto(slime, isFront)
        List.pushlast(MonsterManager, slime)
    end
end

function GameMaster:showRat(isFront)
    if List.getSize(RatPool) ~= 0 then
        local rat = List.popfirst(RatPool)
        rat:reset()
        rat.goRight = false
        self:jumpInto(rat,isFront)
        List.pushlast(MonsterManager, rat)
    end
end


function GameMaster:update(dt)
    self.totaltime = self.totaltime + dt
	if self.totaltime > self.logicFrq then
		self.totaltime = self.totaltime - self.logicFrq
		self:logicUpdate()
	end

end

function GameMaster:jumpInto(obj, isFront)
    local appearPos = getFocusPointOfHeros()
    local randomvar = 2*math.random()-1
    if isFront then
        appearPos.x = appearPos.x + frontDistanceWithHeroX+randomvar*distanceWithHeroX
    else
        appearPos.x = appearPos.x - backwardDistanceWithHeroX+randomvar*distanceWithHeroX
    end
    appearPos.y = appearPos.y + 1500
    obj:setPosition(appearPos)
    obj.myPos = appearPos

    local function enableAI()
        obj:setAIEnabled(true)
    end

    local function visibleMonster()
        obj:setVisible(true)
    end

    if self.stage == 0 then
        obj:runAction(cc.Sequence:create(cc.DelayTime:create(math.random()),
        	cc.CallFunc:create(visibleMonster),
        	cc.JumpBy3D:create(0.5,cc.vec3(-200*(math.random()*0.6+0.7),-400*(math.random()*0.4+0.8),0),150,1),
        	cc.CallFunc:create(enableAI)))
        obj:setFacing(135)
    else
        if isFront then
            obj:runAction(cc.Sequence:create(cc.DelayTime:create(math.random()),
            	cc.CallFunc:create(visibleMonster),
            	cc.JumpBy3D:create(0.5,cc.vec3(0,-400*(math.random()*0.4+0.8),0),150,1),
            	cc.CallFunc:create(enableAI)))
            obj:setFacing(135)
        else
            obj:runAction(cc.Sequence:create(cc.DelayTime:create(math.random()),
            	cc.CallFunc:create(visibleMonster),
            	cc.JumpBy3D:create(0.5,cc.vec3(200*(math.random()*0.6+0.7),-400*(math.random()*0.4+0.8),0),150,1),
            	cc.CallFunc:create(enableAI)))
            obj:setFacing(45)
        end
    end
end

function GameMaster:logicUpdate()
	if self.stage == 1 then
	    if List.getSize(MonsterManager) < EXIST_MIN_MONSTER then
	        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	        for i=1,4 do
	            self:randomshowMonster(true)
	        end
	        self.stage = 2
	    end
	elseif self.stage == 2 then
	    if List.getSize(MonsterManager) < EXIST_MIN_MONSTER then
	        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	        for i=1,4 do
	            self:randomshowMonster(true)
	        end
	        self.stage = 3
	    end
	elseif self.stage == 3 then
	    if List.getSize(MonsterManager) == 0 then
	        for i = HeroManager.first, HeroManager.last do
	            local hero = HeroManager[i]
	            if hero ~= nil then
	                hero.goRight = true
	            end
	        end
	        self.stage = 4
	    end
	elseif self.stage == 4 then
	    if getFocusPointOfHeros().x > battleSiteX[2] then
	        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	        for i=1,3 do
	            self:randomshowMonster(true)
	        end
	        for i=1,4 do
	            self:randomshowMonster(false)
	        end
	        self.stage = 5
	    end
	elseif self.stage == 5 then
	    if List.getSize(MonsterManager) < EXIST_MIN_MONSTER then
	        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	        for i=1,4 do
	            self:randomshowMonster(true)
	        end
	        self.stage = 6
	    end
	elseif self.stage == 6 then
	    if List.getSize(MonsterManager) < EXIST_MIN_MONSTER then
	        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	        for i=1,4 do
	            self:randomshowMonster(false)
	        end
	        self.stage = 7
	    end
	elseif self.stage == 7 then
	    if List.getSize(MonsterManager) == 0 then
	        for i = HeroManager.first, HeroManager.last do
	            local hero = HeroManager[i]
	            if hero ~= nil then
	                hero.goRight = true
	            end
	        end
	        for i = PigletPool.first, PigletPool.last do
	            local monster = PigletPool[i]
	            if monster ~= nil then
	                monster:removeFromParent()
	            end
	        end
	        for i = SlimePool.first, SlimePool.last do
	            local hero = SlimePool[i]
	            if monster ~= nil then
	                monster:removeFromParent()
	            end
	        end
	        for i = DragonPool.first, DragonPool.last do
	            local hero = DragonPool[i]
	            if monster ~= nil then
	                monster:removeFromParent()
	            end
	        end
	        for i = RatPool.first, RatPool.last do
	            local hero = RatPool[i]
	            if monster ~= nil then
	                monster:removeFromParent()
	            end
	        end
	        self.stage = 8
	    end
	elseif self.stage == 8 then
	    -- if getFocusPointOfHeros().x > battleSiteX[3] then
	        self:showWarning()
	        self.stage = 9
	    -- end
	end
end

function GameMaster:showWarning()
    print("GameMaster:showWarning()")
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_AUTO)
    local warning = cc.Layer:create()
    local warning_logo = cc.Sprite:createWithSpriteFrameName("caution.png")
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565)
    warning_logo:setPosition(display.width*0.5,display.height*0.5)
    warning_logo:setPositionZ(1)
    warning_logo:setGlobalZOrder(UIZorder)
    local function showBigDialog()
        warning:removeFromParent()
        self:showDialog()
        ccexp.AudioEngine:play2d("audios/effects/boss/boss.mp3", false,1)
    end
    warning_logo:runAction(
        cc.Sequence:create(cc.DelayTime:create(0.5),
        cc.EaseSineOut:create(cc.Blink:create(1.5,3)),
        cc.CallFunc:create(showBigDialog)))
    warning:addChild(warning_logo)
    
    warning:setScale(0.5)
    warning:setPositionZ(-cc.Director:getInstance():getZEye()/2)
    warning:setIgnoreAnchorPointForPosition(false)
    warning:setLocalZOrder(999)
    warning:setCameraMask(UserCameraFlagMask)
    camera:addChild(warning,2)
end

function GameMaster:showDialog()
    printInfo("GameMaster:showDialog()")
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_AUTO)
    local colorLayer = cc.LayerColor:create(cc.c4b(10,10,10,150))
    colorLayer:setIgnoreAnchorPointForPosition(false)
    colorLayer:setPositionZ(-cc.Director:getInstance():getZEye()/5)
    colorLayer:setGlobalZOrder(0)
    colorLayer:setCameraMask(UserCameraFlagMask)
    camera:addChild(colorLayer)
    
    --create dialog
    local dialog = cc.Layer:create()
    dialog:setPositionX(-display.width*0.025)

    --add outframe
    local outframe = cc.Sprite:createWithSpriteFrameName("outframe.png")
    outframe:setPosition(display.width*0.55,display.height*0.27)
    outframe:setScale(0.6)
    outframe:setGlobalZOrder(UIZorder)
    dialog:addChild(outframe)

    --add inframe
    local inframe = cc.Sprite:createWithSpriteFrameName("inframe.png")
    inframe:setPosition(display.width*0.67,display.height*0.27)
    inframe:setScale(0.5)
    inframe:setGlobalZOrder(UIZorder)
    dialog:addChild(inframe)

    --add boss icon
    local bossicon = cc.Sprite:createWithSpriteFrameName("bossicon.png")
    bossicon:setPosition(display.width*0.42,display.height*0.46)
    bossicon:setScale(0.75)
    bossicon:setFlippedX(true)
    bossicon:setGlobalZOrder(UIZorder)
    dialog:addChild(bossicon)
    --add boss logo
    local bosslogo = cc.Sprite:createWithSpriteFrameName("bosslogo.png")
    bosslogo:setPosition(display.width*0.417,display.height*0.265)
    bosslogo:setScale(0.74)
    dialog:addChild(bosslogo)

    local text = cc.Label:createWithTTF("How dare you???","fonts/britanic bold.ttf",24)
--    local text = cc.Label:createWithSystemFont(BossTaunt,"arial",24)
    text:setPosition(display.width*0.68,display.height*0.27)
    text:setGlobalZOrder(UIZorder+1)
    dialog:addChild(text)

    --set dialog
    dialog:setScale(0.1)
    dialog:setIgnoreAnchorPointForPosition(false)
    dialog:setPositionZ(-cc.Director:getInstance():getZEye()/3)
    dialog:setGlobalZOrder(UIZorder)
    dialog:setCameraMask(UserCameraFlagMask)
    camera:addChild(dialog)

    local function pausegame()
        for var = HeroManager.first, HeroManager.last do
            HeroManager[var]:idleMode()
            HeroManager[var]:setAIEnabled(false)
        end
    end
    dialog:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5 ,0.5),cc.CallFunc:create(pausegame)))
    uiLayer:setVisible(false)
    local function exitDialog( )
        local function removeDialog()
            dialog:removeFromParent()
            colorLayer:removeFromParent()
            uiLayer:setVisible(true)
            for var = HeroManager.first, HeroManager.last do
                HeroManager[var]:setAIEnabled(true)
            end
            self:showBoss()
        end
        dialog:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5,0.1),cc.CallFunc:create(removeDialog)))
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleid)
    end

    cc.exports.scheduleid = cc.Director:getInstance():getScheduler():scheduleScriptFunc(exitDialog,3,false)

    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565)    
end

function GameMaster:showBoss()
    local boss = Rat.new()
    boss:setCameraMask(UserCameraFlagMask)
    currentLayer:addChild(boss)
    boss:reset()
    local appearPos = cc.vec3(500,200,300)
    boss:setPosition3D(appearPos)
    boss._myPos = {x = appearPos.x,y = appearPos.y}
    boss:setFacing(180)
    boss._goRight = false
    local function enableAI()
        boss:setAIEnabled(true)
    end
    boss:runAction(cc.Sequence:create(cc.EaseBounceOut:create(cc.MoveBy:create(0.5,cc.vec3(0,0,-300))),cc.CallFunc:create(enableAI)))
    List.pushlast(MonsterManager, boss)
end

function GameMaster:showVictoryUI()
    uiLayer:showVictoryUI()
end

return GameMaster
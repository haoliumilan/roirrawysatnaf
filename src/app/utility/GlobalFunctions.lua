--
-- Author: Hao Liu
-- Date: 2016-08-25 18:36:07
--
--[[
	全局使用的方法
]]

local function createAnimation(file, begin, finish, speed)
    local animation3d = cc.Animation3D:create(file)
    local animate3d = cc.Animate3D:create(animation3d, begin/30,(finish-begin)/30)
    animate3d:setSpeed(speed)
    animate3d:retain()
    return animate3d
end

cc.exports.createAnimation = createAnimation

-- change table to enum type
local function CreateEnumTable(tbl, index)
    local enumTable = {}
    local enumIndex = index or -1
    for i, v in ipairs(tbl) do
        enumTable[v] = enumIndex + i
    end
    return enumTable
end

cc.exports.CreateEnumTable = CreateEnumTable

local function getPosTable(obj)
    local posX,posY = obj:getPosition()
    return {x= posX,y=posY} 
end

cc.exports.getPosTable = getPosTable

--radiansNormalizer
local function radNormalize(rad)
    local pi2 = 2*math.pi
    rad = rad % pi2
    rad = (rad + pi2)%pi2
    if rad > math.pi then
        rad = rad - math.pi
    end
    return rad
end

cc.exports.radNormalize = radNormalize

local function copyTable(t1, t2)
    for key, var in pairs(t1) do
        t2[key] = var
    end
end

cc.exports.copyTable = copyTable

local function delayExecute(target, func, delay)
    local wait = cc.DelayTime:create(delay)
    target:runAction(cc.Sequence:create(wait, cc.CallFunc:create(func)))
end

cc.exports.delayExecute = delayExecute







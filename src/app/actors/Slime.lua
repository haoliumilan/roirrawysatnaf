--
-- Author: Hao Liu
-- Date: 2016-08-19 16:36:40
-- 
--[[
	软泥怪
]]

local SlimeValues = {
	shadowSize = 45,
}

local Actor = require("app.actors.Actor")

local modelFile = "model/slime/slime.c3b"
local pngFile = "model/slime/baozi.jpg"
local png2File = "model/slime/baozi2.jpg"

local Slime = class("Slime", Actor)

function Slime:ctor()
	self.super:ctor()

	table.merge(self, SlimeValues)

	self:init3D()
	self:initActions()

end

function Slime:init3D()
	self:initShadow()

	self.sprite3d = cc.Sprite3D:create(modelFile)
	self.sprite3d:setTexture(pngFile)
	self.sprite3d:setScale(17)
	self:addChild(self.sprite3d)
	self.sprite3d:setRotation3D({x = 90, y = 0, z = 0})
	self.sprite3d:setRotation(-90)

end

function Slime:initActions()

end

return Slime
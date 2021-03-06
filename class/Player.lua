-- ToME - Tales of Middle-Earth
-- Copyright (C) 2009, 2010, 2011 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "engine.class"
require "mod.class.Actor"
require "mod.class.Object"
require "engine.interface.PlayerRest"
require "engine.interface.PlayerRun"
require "engine.interface.PlayerMouse"
require "engine.interface.PlayerHotkeys"
local Map = require "engine.Map"
local Dialog = require "engine.Dialog"
local ActorTalents = require "engine.interface.ActorTalents"
local DeathDialog = require "mod.dialogs.DeathDialog"
local Astar = require"engine.Astar"
local DirectPath = require"engine.DirectPath"

--- Defines the player
-- It is a normal actor, with some redefined methods to handle user interaction.<br/>
-- It is also able to run and rest and use hotkeys
module(..., package.seeall, class.inherit(
	mod.class.Actor,
	engine.interface.PlayerRest,
	engine.interface.PlayerRun,
	engine.interface.PlayerMouse,
	engine.interface.PlayerHotkeys
))

function _M:init(t, no_default)
	t.display=t.display or '@'
	t.color_r=t.color_r or 230
	t.color_g=t.color_g or 230
	t.color_b=t.color_b or 230

	t.player = true
	t.type = t.type or "humanoid"
	t.subtype = t.subtype or "player"
	t.faction = t.faction or "players"

	t.lite = t.lite or 0
	t.sight = 10
	t.base_dam = 1
	t.max_dam = 6
	t.defence = 0
	t.shadowcount = 50
	t.shadowed = false
	t.shield = 0
	
	mod.class.Actor.init(self, t, no_default)
	engine.interface.PlayerHotkeys.init(self, t)

	self.descriptor = {}
end

function _M:move(x, y, force)
	local moved = mod.class.Actor.move(self, x, y, force)
	if moved then
		game.level.map:moveViewSurround(self.x, self.y, 8, 8)
	end
	return moved
end

function _M:act()
	if not mod.class.Actor.act(self) then return end

	if self.shield > 0 then
		self.shield = self.shield - 1
		if self.shield == 0 then
			self.defence = self.defence - 10
			--game.flyers:add(game.player.x, game.player.y, 30, (rng.range(0,2)-1) * 0.5, -3, "-shield", {150,150,240})
		end
	end
	
	-- if self.shadowcount > 0 then
	--    self.shadowcount = self.shadowcount - 1
	--    if self.shadowcount == 0 then
	-- 		-- The Shadow will get you!
	-- 		-- Find space
	-- 		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
	-- 		if not x then
	-- 			self.shadowcount = 1
	-- 		else
	-- 			local NPC = require "mod.class.NPC"
	-- 			local m = NPC.new{
	-- 				type = "shadow",
	-- 				display = "@",
	-- 				color=colors.DARK_GREY,
	-- 				name = "Shadow",
	-- 				desc = "A dark shadowy shape who reaches out to snuff you from existence.",
	-- 				ai = "dumb_talented_simple", ai_state = { talent_in=1, ai_move="move_astar", },
	-- 				base_dam = 20 + game.player.level,
	-- 				max_dam = 20 + game.player.level,
	-- 				max_life = game.player.max_life * 2,
	-- 				life = game.player.max_life * 2,
	-- 				life_regen = 1,
	-- 				defence = 10,
	-- 				energy = {mod = 0.5},
	-- 				sight = 10,
	-- 				lite = 5,
	-- 			}
	-- 			m.on_added_to_level = nil
	-- 			local Particles = require "engine.Particles"
	-- 			m.particle = m:addParticles(Particles.new("ultrashield", 1, {rm=0, rM=0, gm=0, gM=0, bm=10, bM=100, am=70, aM=180, radius=0.8, density=40, life=14, instop=20}))
				
	-- 			m:setTarget(game.player)
	-- 			m.energy.value = 0
	-- 			m.forceLevelup = function() end
	-- 			m.on_die = function()
	-- 				self.shadowed = nil
	-- 				self.win = true
	-- 				self.die(self)
	-- 			end
	-- 			game.zone:addEntity(game.level, m, "actor", x, y)
	-- 			game.level.map:particleEmitter(x, y, 1, "teleport")
	-- 			game.log("#ffffff#The Shadow is here! Run, run for your life!")
	-- 			self.shadowed = true
	-- 		end
	--    end
	-- end
	
	local turn_plural = "turns"
	-- if self.shadowcount == 1 then turn_plurals = "turn" end
	-- if self.shadowcount > 0 then game.log("#ffff22#The Shadow is coming in %d %s!",self.shadowcount,turn_plural) end
		
	-- Funky shader things !
	self:updateMainShader()

	self.old_life = self.life
	
	-- Resting ? Running ? Otherwise pause
	if not self:restStep() and not self:runStep() and self.player then
		game.paused = true
	end
end

-- Precompute FOV form, for speed
local fovdist = {}
for i = 0, 30 * 30 do
	fovdist[i] = math.max((20 - math.sqrt(i)) / 14, 0.6)
end

function _M:playerFOV()
	-- Clean FOV before computing it
	game.level.map:cleanFOV()
	-- Compute both the normal and the lite FOV, using cache
	self:computeFOV(self.sight or 10, "block_sight", function(x, y, dx, dy, sqdist)
		game.level.map:apply(x, y, fovdist[sqdist])
	end, true, false, true)
	self:computeFOV(self.lite, "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyLite(x, y) end, true, true, true)
	
	 -- For each entity, generate lite
	local uid, e = next(game.level.entities)
	while uid do
	if e ~= self and e.lite and e.lite > 0 and e.computeFOV then
	e:computeFOV(e.lite, "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyExtraLite(x, y, fovdist[sqdist]) end, true, true)
	end
	uid, e = next(game.level.entities, uid)
	end
	
end

function _M:playerPickup()
    -- If 2 or more objects, display a pickup dialog, otherwise just picks up
    if game.level.map:getObject(self.x, self.y, 2) then
        local d d = self:showPickupFloor("Pickup", nil, function(o, item)
            self:pickupFloor(item, true)
            self.changed = true
            d:used()
        end)
    else
        self:pickupFloor(1, true)
        self:sortInven()
        self:useEnergy()
    self.changed = true
    end
end

function _M:playerDrop()
    local inven = self:getInven(self.INVEN_INVEN)
    local d d = self:showInventory("Drop object", inven, nil, function(o, item)
        self:dropFloor(inven, item, true, true)
        self:sortInven(inven)
        self:useEnergy()
        self.changed = true
        return true
    end)
end

function _M:doWear(inven, item, o)
    self:removeObject(inven, item, true)
    local ro = self:wearObject(o, true, true)
    if ro then
        if type(ro) == "table" then self:addObject(inven, ro) end
    elseif not ro then
        self:addObject(inven, o)
    end
    self:sortInven()
    self:useEnergy()
    self.changed = true
end

function _M:doTakeoff(inven, item, o)
    if self:takeoffObject(inven, item) then
        self:addObject(self.INVEN_INVEN, o)
    end
    self:sortInven()
    self:useEnergy()
    self.changed = true
end

function _M:doDrop(inven, item, on_done)
	
	self:dropFloor(inven, item, true, true)
	self:sortInven(inven)
	self:useEnergy()
	self.changed = true
end

function _M:playerUseItem(object, item, inven)

	local use_fct = function(o, inven, item)
	if not o then return end
	local co = coroutine.create(function()
	self.changed = true

	local ret = o:use(self, nil, inven, item) or {}
	if not ret.used then return end

	if ret.destroy then
		if o.multicharge and o.multicharge > 1 then
			o.multicharge = o.multicharge - 1
		else
			local _, del = self:removeObject(self:getInven(inven), item)
			
			self:sortInven(self:getInven(inven))
		end
	
	return true
	end

    self.changed = true
	end)
	local ok, ret = coroutine.resume(co)
	if not ok and ret then print(debug.traceback(co)) error(ret) end
	return true
	end
	
	if object and item then return use_fct(object, inven, item) end
	
	local titleupdator = self:getEncumberTitleUpdator("Use object")
	self:showEquipInven(titleupdator(),
	function(o)
	return o:canUseObject()
	end,
	use_fct
	)
end

--- Called before taking a hit, overload mod.class.Actor:onTakeHit() to stop resting and running
function _M:onTakeHit(value, src)
	self:runStop("taken damage")
	self:restStop("taken damage")
	local ret = mod.class.Actor.onTakeHit(self, value, src)
	if self.life < self.max_life * 0.3 then
		local sx, sy = game.level.map:getTileToScreen(self.x, self.y)
		game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, 2, "LOW HEALTH!", {255,0,0}, true)
	end
	return ret
end

function _M:die(src)
	if self.game_ender then
		engine.interface.ActorLife.die(self, src)
		game.paused = true
		self.energy.value = game.energy_to_act
		game:registerDialog(DeathDialog.new(self))
	else
		mod.class.Actor.die(self, src)
	end
end

function _M:setName(name)
	self.name = name
	game.save_name = name
end

--- Notify the player of available cooldowns
function _M:onTalentCooledDown(tid)
	local t = self:getTalentFromId(tid)

	local x, y = game.level.map:getTileToScreen(self.x, self.y)
	game.flyers:add(x, y, 30, -0.3, -3.5, ("%s available"):format(t.name:capitalize()), {0,255,00})
	game.log("#00ff00#Talent %s is ready to use.", t.name)
end

function _M:levelup()
	mod.class.Actor.levelup(self)

	local x, y = game.level.map:getTileToScreen(self.x, self.y)
	game.flyers:add(x, y, 80, 0.5, -2, "LEVEL UP!", {0,255,255})
	game.log("#00ffff#Advanced to level %d - health and damage output increased.", self.level)
end

--- Tries to get a target from the user
function _M:getTarget(typ)
	return game:targetGetForPlayer(typ)
end

--- Sets the current target
function _M:setTarget(target)
	return game:targetSetForPlayer(target)
end

local function spotHostiles(self)
	local seen = false
	-- Check for visible monsters, only see LOS actors, so telepathy wont prevent resting
	core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, 20, function(_, x, y) return game.level.map:opaque(x, y) end, function(_, x, y)
		local actor = game.level.map(x, y, game.level.map.ACTOR)
		if actor and self:reactionToward(actor) < 0 and self:canSee(actor) and game.level.map.seens(x, y) then seen = true end
	end, nil)
	return seen
end

--- Can we continue resting ?
-- We can rest if no hostiles are in sight, and if we need life/mana/stamina (and their regen rates allows them to fully regen)
function _M:restCheck()
	if spotHostiles(self) then return false, "hostile spotted" end

	-- Check resources, make sure they CAN go up, otherwise we will never stop
	if self:getPower() < self:getMaxPower() and self.power_regen > 0 then return true end
	if self.life < self.max_life and self.life_regen> 0 then return true end

	return false, "all resources and life at maximum"
end

--- Can we continue running?
-- We can run if no hostiles are in sight, and if we no interesting terrains are next to us
function _M:runCheck()
	if spotHostiles(self) then return false, "hostile spotted" end

	-- Notice any noticeable terrain
	local noticed = false
	self:runScan(function(x, y)
		-- Only notice interesting terrains
		local grid = game.level.map(x, y, Map.TERRAIN)
		if grid and grid.notice then noticed = "interesting terrain" end
	end)
	if noticed then return false, noticed end

	self:playerFOV()

	return engine.interface.PlayerRun.runCheck(self)
end

--- Move with the mouse
-- We just feed our spotHostile to the interface mouseMove
function _M:mouseMove(tmx, tmy)
	return engine.interface.PlayerMouse.mouseMove(self, tmx, tmy, spotHostiles)
end


--- Funky shader stuff
function _M:updateMainShader()
	if game.fbo_shader then
		-- Set shader HP warning
		if self.life ~= self.old_life then
			if self.life < self.max_life / 2 then game.fbo_shader:setUniform("hp_warning", 1 - (self.life / self.max_life))
			else game.fbo_shader:setUniform("hp_warning", 0) end
		end

		-- Colorize shader
		if self.shadowed then game.fbo_shader:setUniform("colorize", {0.1,0.1,0.1,0.75})
		else game.fbo_shader:setUniform("colorize", {0,0,0,0}) -- Disable
		end
		
		-- Blur shader
		if self.shadowed then game.fbo_shader:setUniform("blur", 1)
		else game.fbo_shader:setUniform("blur", 0) -- Disable
		end

	end
end
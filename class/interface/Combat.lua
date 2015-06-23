-- Run from the Shadow!
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
-- Darren Grey
-- http://gruesomegames.com

require "engine.class"
-- local DamageType = require "engine.DamageType"
local Map = require "engine.Map"
local Target = require "engine.Target"
-- local Talents = require "engine.interface.ActorTalents"

--- Interface to add combat system
module(..., package.seeall, class.make)

--- Checks what to do with the target
-- Talk ? attack ? displace ?
function _M:bumpInto(target)
	local reaction = self:reactionToward(target)
	if reaction < 0 then
		return self:attackTarget(target)
	elseif reaction >= 0 then
		if self.move_others then
			-- Displace
			game.level.map:remove(self.x, self.y, Map.ACTOR)
			game.level.map:remove(target.x, target.y, Map.ACTOR)
			game.level.map(self.x, self.y, Map.ACTOR, target)
			game.level.map(target.x, target.y, Map.ACTOR, self)
			self.x, self.y, target.x, target.y = target.x, target.y, self.x, self.y
		end
	end
end

--- Makes the death happen!
function _M:attackTarget(target, mult)
   --if self.combat then
	    local dam = rng.range(self.base_dam,self.max_dam) - target.defence
		if dam < 0 then dam = 0 end
		
		if self == game.player then
            local desc = target.name
            game.log("You hit the %s for %d damage.", target.name,dam)
        elseif target == game.player then
            game.logSeen(target, "The %s hits you for %d damage.", self.name, dam)
        end
      
		local sx, sy = game.level.map:getTileToScreen(target.x, target.y)
		
		if target:takeHit(dam, self) then
			if self == game.player or target == game.player then
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, "Dead!", {255,0,255})
			end
		else
			if self == game.player then
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, tostring(-math.ceil(dam)), {0,255,0})
			elseif target == game.player then
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, tostring(-math.ceil(dam)), {255,0,0})
			end
		end
		
   --end

   -- Time passes when attack attempted
   self:useEnergy(game.energy_to_act)
end

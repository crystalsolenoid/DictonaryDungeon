-- Broken Bottle - 7DRL
-- Copyright (C) 2011 Darren Grey
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


require "engine.class"
require "mod.class.interface.TooltipsData"
local Dialog = require "engine.Dialog"
local DamageType = require "engine.DamageType"
local Talents = require "engine.interface.ActorTalents"

module(..., package.seeall, class.inherit(engine.Dialog, mod.class.interface.TooltipsData))

function _M:init(actor)
	self.actor = actor
	engine.Dialog.init(self, "Character Sheet", 400, 400, nil, nil, nil, core.display.newFont("/data/font/VeraMono.ttf", 14))

	self:keyCommands({
		__TEXTINPUT = function(c)
			if c == 'd' or c == 'D' then
				self:dump()
			end
		end,
	}, {
		ACCEPT = "EXIT",
		EXIT = function()
			game:unregisterDialog(self)
		end,
	})
	self:mouseZones{
	}
end

function _M:mouseTooltip(text, _, _, _, w, h, x, y)
	self:mouseZones({
		{ x=x, y=y, w=w, h=h, fct=function(button) game.tooltip_x, game.tooltip_y = 1, 1; game.tooltip:displayAtMap(nil, nil, game.w, game.h, text) end},
	}, true)
end

function _M:mouseLink(link, text, _, _, _, w, h, x, y)
	self:mouseZones({
		{ x=x, y=y, w=w, h=h, fct=function(button)
			game.tooltip_x, game.tooltip_y = 1, 1; game.tooltip:displayAtMap(nil, nil, game.w, game.h, text)
			if button == "left" then
				util.browserOpenUrl(link)
			end
		end},
	}, true)
end

function _M:drawDialog(s)
	self.mouse:reset()
	self:mouseZones({
		{ x=0, y=0, w=game.w, h=game.h, norestrict=true, fct=function(button, _, _, _, _, _, _, event) game.tooltip_x, game.tooltip_y = nil, nil; if button == "left" and event == "button" then game:unregisterDialog(self) end end},
	}, true)

	local player = self.actor
	local cur_exp, max_exp = player.exp, player:getExpChart(player.level+1)

	local basey = 10
	local h = 10
	local w = 10
	
	h = basey
	w = 0

	s:drawColorStringBlended(self.font, ("Name:  #WHITE#%s"):format(player.name), w, h, 125, 114, 93)
	h = h + 2*self.font_h
	self:mouseTooltip(self.TOOLTIP_LEVEL, s:drawColorStringBlended(self.font, "#44dd44#Level: #LAST#"..player.level, w, h, 255, 255, 255)) h = h + self.font_h
	self:mouseTooltip(self.TOOLTIP_LEVEL, s:drawColorStringBlended(self.font, ("#44dd44#Exp:  #LAST#%2d%%"):format(100 * cur_exp / max_exp), w, h, 255, 255, 255)) h = h + self.font_h

    h = h + self.font_h
   
	self:mouseTooltip(self.TOOLTIP_LIFE, s:drawColorStringBlended(self.font, ("#CRIMSON#Health:    #LAST#%d/%d"):format(player.life, player.max_life), w, h, 255, 255, 255)) h = h + self.font_h
	
	h = h + self.font_h
	self:mouseTooltip(self.TOOLTIP_DAMAGE, s:drawColorStringBlended(self.font, ("Damage: #RED#%d#LAST# to #RED#%d"):format(player.base_dam, player.max_dam), w, h, 255, 255, 255)) h = h + self.font_h
	self:mouseTooltip(self.TOOLTIP_DEFENCE, s:drawColorStringBlended(self.font, ("Defence:   #LIGHT_BLUE#%d"):format(player.defence), w, h, 255, 255, 255)) h = h + self.font_h

	h = h + self.font_h
	
    s:drawStringBlended(self.font, ("Explored to level %d of the Dark Caves"):format(game.level.level),w,h,100, 200, 100)
   
	h = h + 4*self.font_h
   
   --s:drawStringBlended(self.font, "Press 'd' to save to file.",w,h,210, 210, 210)
	
	self.changed = false
end

function _M:dump()
	local player = self.actor

	fs.mkdir("/character-dumps")
	local file = "/character-dumps/"..(player.name:gsub("[^a-zA-Z0-9_-.]", "_")).."-"..os.date("%Y%m%d-%H%M%S")..".txt"
	local fff = fs.open(file, "w")
	local labelwidth = 17
	local nl = function(s) s = s or "" fff:write(s:removeColorCodes()) fff:write("\n") end
	local nnl = function(s) s = s or "" fff:write(s:removeColorCodes()) end
	--prepare label and value
	local makelabel = function(s,r) while s:len() < labelwidth do s = s.." " end return ("%s: %s"):format(s, r) end

	local cur_exp, max_exp = player.exp, player:getExpChart(player.level+1)
	nl("  [Run from the Shadow - Character Dump]")
	nl()

	nnl(("%-32s"):format(makelabel("Name", player.name)))
	nl(("Damage: %d to %d"):format(player.base_dam, player.max_dam))

	nnl(("%-32s"):format(makelabel("Level", ("%d"):format(player.level))))
	nl(("Defence:      %d"):format(player.defence))

	nnl(("%-32s"):format(makelabel("Exp", ("%d%%"):format(100 * cur_exp / max_exp))))
	nl(("Health:    %d/%d"):format(player.life, player.max_life))

	nl()
	nnl(("%-32s"):format(makelabel("Explored to level", (" %d"):format(game.level.level))))
	
	nl()
	nl("  [Last Messages]")
	nl()

	nl(table.concat(game.logdisplay:getLines(40), "\n"):removeColorCodes())

	fff:close()

	Dialog:simplePopup("Character dump complete", "File: "..fs.getRealPath(file))
end

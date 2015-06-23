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

return {
	name = "Dark caves",
	short_name = "dungeon",
	level_range = {1, 50},
	max_level = 2000,
	--decay = {300, 800},
	width = 40, height = 20,
	--persistent = "zone",
	generator =  {
		map = {
			class = "engine.generator.map.Cavern",
			floor = "FLOOR",
			wall = "WALL",
			up = "FLOOR",
			down = "DOWN",
			door = "FLOOR",
			zoom = 14,
			min_floor = 180,
		},
		actor = {
			class = "engine.generator.actor.Random",
			nb_npc = {15, 25},
		},
		object = {
            class = "engine.generator.object.Random",
            nb_object = {6, 9},
        },
	},
	levels =
	{
	},
	on_enter = function(lev, old_lev, newzone)
    if lev == 1 then
		local Dialog = require("engine.ui.Dialog")
	
		Dialog:simpleLongPopup("Run from the Shadow", [[You are in a dark place, and something is after you.  Something terrible, a strong and vicious fiend that seeks to destroy you.  But you are not strong enough to face it... you must run!  Perhaps in the dark corners of your mind you will find the tools to defeat your enemy.

Game instructions:
 Move with mouse keys or numpad.
 Bump into enemies to attack.
 g to pickup items, i to access inventory, > to descend stairs.
 Escape to rebind keys and other options.
 Find items in the dungeon and kill enemies to get stronger.
 
Beware, beware of The Shadow... it is coming.
]],400)
	end
    end,
}

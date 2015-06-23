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
	name = "Dictionary Dungeon",
	short_name = "dungeon",
	level_range = {1, 26},
	max_level = 2000,
	--decay = {300, 800},
	width = 30, height = 15,
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
			nb_npc = {5, 25}, --range of how many are spawned on a level
		},
		object = {
            class = "engine.generator.object.Random",
            nb_object = {6, 9},
        },
	},
	levels =
	{--what is this?
	},
	on_enter = function(lev, old_lev, newzone)
    if lev == 1 then
		local Dialog = require("engine.ui.Dialog")
	
		Dialog:simpleLongPopup("Entering the Dictionary Dungeon", [[You have failed. The legendary letter Z has been destroyed due to your short-sighted mistake.

Your former colleagues at the Alphamancer Academy have vowed to excecute you unless you replace it.

Go into the depths of the treacherous Dictionary Dungeon and find a new one, or die trying.

Game instructions:
 Move with mouse keys or numpad.
 Bump into enemies to attack.
 g to pickup items, i to access inventory, > to descend stairs.
 Escape to rebind keys and other options.
 Find items in the dungeon and kill enemies to get stronger.
]],400)
	end
    end,
}

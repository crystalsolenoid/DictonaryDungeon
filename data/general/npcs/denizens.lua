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

newEntity{ define_as = "BASE_RAT",
    type = "creature",
	display = "r", color=colors.DARK_UMBER,
    desc = [[A small animal that thinks it's better than what it is.]],

    ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	name = "judgemental rat",
	level_range = {1, 20}, exp_worth = 1,
	rarity = 4,
	max_life = resolvers.rngavg(2,4),
	base_dam = resolvers.rngavg(1,2),
	max_dam = resolvers.rngavg(2,3),
	defence = 0,
    energy = {mod = 1.0},
    sight = 5,
}

newEntity{ define_as = "BASE_BUG",
    type = "creature",
	display = "i", color=colors.GREEN,
    desc = [[A pestering insect that is constantly chittering at you.]],

    ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	name = "guilt bug",
	level_range = {1, 25}, exp_worth = 1,
	rarity = 4,
	max_life = resolvers.rngavg(1,3),
	base_dam = 1,
	max_dam = 2,
	defence = 1,
    energy = {mod = 1.2},
    sight = 4,
}

newEntity{ define_as = "BASE_GOBLIN",
    type = "creature",
	display = "g", color=colors.BLUE,
    desc = [[A base and vulgar monster that serves only to annoy.]],

    ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	name = "doubt goblin",
	level_range = {3, 30}, exp_worth = 1,
	rarity = 5,
	max_life = resolvers.rngavg(3,6),
	base_dam = resolvers.rngavg(1,3),
	max_dam = resolvers.rngavg(3,4),
	defence = resolvers.rngavg(0,1),
    energy = {mod = 1.0},
    sight = 5,
}

newEntity{ define_as = "BASE_GHOST",
    type = "creature",
	display = "G", color=colors.WHITE,
    desc = [[An evil thing to be forgotten.  Get it away!]],

    ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	name = "memory ghost",
	level_range = {2, 40}, exp_worth = 1,
	rarity = 6,
	max_life = resolvers.rngavg(2,5),
    base_dam = resolvers.rngavg(1,2),
	max_dam = resolvers.rngavg(2,3),
	defence = 0,
    energy = {mod = 1.0},
    sight = 6,
	-- Insert slowing attack - or in combat class instead?
}

newEntity{ define_as = "BASE_SNAKE",
    type = "creature",
	display = "s", color=colors.RED,
    desc = [[Don't look at it, don't think about it, just remove it!]],

    ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	name = "snake of shame",
	level_range = {5, 50}, exp_worth = 1.4,
	rarity = 7,
	max_life = resolvers.rngavg(6,12),
	base_dam = resolvers.rngavg(1,2),
	max_dam = resolvers.rngavg(4,5),
	defence = 1,
    energy = {mod = 1.3},
    sight = 5,
}

newEntity{ define_as = "BASE_BAT",
    type = "creature",
	display = "b", color=colors.UMBER,
    desc = [[Flapping, leeching, horrible creature!]],

    ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	name = "blaming bat",
	level_range = {3, 30}, exp_worth = 1.1,
	rarity = 6,
	max_life = resolvers.rngavg(2,5),
	base_dam = resolvers.rngavg(1,2),
	max_dam = resolvers.rngavg(2,3),
	defence = 0,
    energy = {mod = 1.2},
    sight = 8,
}

newEntity{ define_as = "BASE_TROLL",
    type = "creature",
	display = "T", color=colors.GREY,
    desc = [[A horrible creature with a yowling mouth that's hard to silence, recovering easily from any attack.]],

    ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	name = "accusing troll",
	level_range = {7, 50}, exp_worth = 2,
	rarity = 10,
	max_life = resolvers.rngavg(10,20),
	life_regen = 1,
	base_dam = resolvers.rngavg(4,8),
	max_dam = resolvers.rngavg(9,15),
	defence = 4,
    energy = {mod = 0.8},
    sight = 5,
}

newEntity{ define_as = "BASE_ORC",
    type = "creature",
	display = "o", color=colors.DARK_GREEN,
    desc = [[A green and ugly thing that serves only to torment.]],

    ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	name = "condemning orc",
	level_range = {5, 50}, exp_worth = 1.5,
	rarity = 7,
	max_life = resolvers.rngavg(8,14),
	base_dam = resolvers.rngavg(2,5),
	max_dam = resolvers.rngavg(5,8),
	defence = 2,
    energy = {mod = 1.0},
    sight = 6,
}


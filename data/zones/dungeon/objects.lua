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

newEntity{
    define_as = "BASE_SWORD",
    slot = "WEAPON",
    type = "sword",
    display = ")", color=colors.WHITE,
    rarity = 8,
    encumber = 0,
	desc = [[A viciously sharp sword.]],
}

newEntity{ base = "BASE_SWORD",
    name = "Sword of Lies",
    level_range = {1, 10},
	rarity = 5,
    wielder = {
        base_dam = 1,
		max_dam = resolvers.rngavg(2,3),
    },
}

newEntity{ base = "BASE_SWORD",
    name = "Sword of Justification",
    level_range = {2, 10},
	rarity = 6,
    wielder = {
        base_dam = resolvers.rngavg(2,3),
		max_dam = 3,
    },
}

newEntity{ base = "BASE_SWORD",
    name = "Sword of Repression",
    level_range = {4, 20},
	rarity = 7,
    wielder = {
        base_dam = resolvers.rngavg(2,3),
		max_dam = resolvers.rngavg(3,4),
		defence = 2,
    },
}

newEntity{ base = "BASE_SWORD",
    name = "Sword of Deceipt",
    level_range = {5, 20},
	rarity = 7,
    wielder = {
        base_dam = resolvers.rngavg(3,4),
		max_dam = resolvers.rngavg(5,7),
    },
}

newEntity{ base = "BASE_SWORD",
    name = "Sword of Denial",
	color=colors.YELLOW,
    level_range = {8, 50},
	rarity = 10,
    wielder = {
        base_dam = resolvers.rngavg(4,5),
		max_dam = resolvers.rngavg(5,12),
    },
}


newEntity{
    define_as = "BASE_SHIELD",
    slot = "SHIELD",
    type = "shield",
    display = "]", color=colors.SLATE,
    rarity = 8,
    encumber = 0,
	desc = [[A sturdy shield providing necessary protection.]],
}

newEntity{ base = "BASE_SHIELD",
    name = "Shield of Rationalisation",
    level_range = {1, 10},
	rarity = 5,
    wielder = {
        defence = 1,
    },
}

newEntity{ base = "BASE_SHIELD",
    name = "Shield of Dismissal",
    level_range = {2, 10},
	rarity = 6,
    wielder = {
        defence = resolvers.rngavg(2,3),
    },
}

newEntity{ base = "BASE_SHIELD",
    name = "Shield of Ego",
    level_range = {4, 20},
	rarity = 7,
    wielder = {
        defence = resolvers.rngavg(3,4),
		life_regen = 0.5,
    },
}

newEntity{ base = "BASE_SHIELD",
    name = "Shield of Shifted Blame",
    level_range = {5, 20},
	rarity = 7,
    wielder = {
        defence = resolvers.rngavg(4,6),
		max_dam = 2,
    },
}

newEntity{ base = "BASE_SHIELD",
    name = "Shield of Excuses",
	color=colors.YELLOW,
    level_range = {8, 50},
	rarity = 10,
    wielder = {
        defence = resolvers.rngavg(6,10),
    },
}


newEntity{
	define_as = "BASE_POTION",
	type = "potion",
    name = "potion of escapism",
    display = "!",
    level_range = {1, 50},
	color = colors.PURPLE,
    encumber = 0,
	rarity = 3,
	stacking = true,
	desc = [[A beautiful and entrancing elixir that stops all but the harshest pains.]],
	
    use_simple = { name = "boost defence by 10 for 4 rounds", use = function(self, who)
		game.logSeen(who, "#4444dd#You slowly down the contents.  You feel almost invulnerable!")
        --game.flyers:add(game.player.x, game.player.y, 30, (rng.range(0,2)-1) * 0.5, -3, "+shield", {150,150,240})
		who.shield = who.shield + 4
		who.defence = who.defence + 10
		return {used=true, destroy=true}
	end},
}

newEntity{
	define_as = "BASE_SCROLL",
	type = "scroll",
    name = "scroll of suppress memories",
    display = "!",
    level_range = {1, 50},
	color = colors.RED,
    encumber = 0,
	rarity = 3,
	stacking = true,
	desc = [[A magical scroll guaranteed to repair all harm!]],
	
    use_simple = { name = "restore 15 Sanity", use = function(self, who)
		game.logSeen(who, "#ee1111#You read the scroll.  Your mind feels totally refreshed!")
		local diff = who.max_life - who.life
		if diff > 15 then diff = 15 end
		who.life = who.life + diff
		--game.flyers:add(game.player.x, game.player.y, 30, (rng.range(0,2)-1) * 0.5, -3, tostring(-math.ceil(diff)), {240,150,150})
		
		return {used=true, destroy=true}
	end},
}


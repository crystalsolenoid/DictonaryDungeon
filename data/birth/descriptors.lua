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

newBirthDescriptor{
	type = "base",
	name = "base",
	desc = {
	},
	experience = 1.0,
	body = { INVEN = 80, WEAPON = 1, SHIELD = 1 },

	copy = {
		max_level = 20,
		lite = 4,
		max_life = 30,
		desc = "A noble and valiant hero of unequalled grace and virtue.",
	},
}

newBirthDescriptor{
	type = "role",
	name = "Rogue",
	desc =
	{
		"You are alone in a very dark place.",
	},
}


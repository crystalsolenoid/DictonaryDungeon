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

module(..., package.seeall, class.make)


-------------------------------------------------------------
-- Resources
-------------------------------------------------------------


TOOLTIP_LIFE = [[#GOLD#Sanity#LAST#
Your sanity keeps you going.  You naturally regenerate 0.25 per turn.]]

TOOLTIP_LEVEL = [[#GOLD#Level and experience#LAST#
Each level gives +5 Sanity and +1 damage.
]]

TOOLTIP_DAMAGE = [[#GOLD#Damage#LAST#
Damage inflicted is a random number between the base and max.
]]

TOOLTIP_DEFENCE = [[#GOLD#Defence#LAST#
Defence reduces the damage received from attacks.
]]
